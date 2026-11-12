import 'dart:convert';
import 'dart:io';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/core/auth/session_manager.dart';
import 'package:power_saving/core/auth/session_middleware.dart';
import 'package:power_saving/core/network/api_client.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:power_saving/features/auth/domain/repositories/auth_repository.dart';
import 'package:power_saving/features/auth/controller/chang_password.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import '../state_management/fixtures.dart';

Map<String, dynamic> identity([dynamic group = 1]) => {
  'emp_code': 'fixture',
  'emp_name': 'Synthetic User',
  'group_id': group,
  'group_name': 'fixture',
  'is_active': true,
  'username': 'fixture',
  'reset': false,
};
Future<void> establish([int group = 1]) async {
  final generation = SessionManager.beginLogin();
  expect(
    await SessionManager.establish(identity(group), 'opaque-token', generation),
    isTrue,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await Cache.init();
    Get.put(SessionService(), permanent: true);
    SessionManager.notice.value = null;
  });
  tearDown(() async {
    await SessionManager.clear();
    Get.reset();
  });
  final invalids = <String, dynamic>{
    'missing': null,
    'null': null,
    'empty': '',
    'string': '1',
    'zero': 0,
    'unknown': 8,
    'negative': -1,
    'fraction': 1.5,
    'bool': true,
    'map': <String, dynamic>{},
  };
  for (final entry in invalids.entries) {
    for (final restore in [false, true]) {
      test(
        '${restore ? 'restore' : 'login'} rejects ${entry.key} group without privileged fallback',
        () async {
          final raw = identity(entry.value);
          if (entry.key == 'missing') raw.remove('group_id');
          await Cache.saveData(key: 'token', value: 'old-token');
          await Cache.saveData(key: 'user', value: jsonEncode(identity()));
          if (restore) {
            await Cache.saveData(key: 'user', value: jsonEncode(raw));
            await SessionManager.restore();
          } else {
            final repo = AuthRepositoryImpl(
              apiClient: ApiClient(
                client: MockClient((request) async {
                  expect(request.method, 'POST');
                  expect(request.url.path, '/login');
                  expect(jsonDecode(request.body), {
                    'username': 'fixture',
                    'password': 'fake',
                  });
                  expect(request.headers['Accept'], 'application/json');
                  expect(request.headers['Authorization'], 'Bearer old-token');
                  return jsonResponse({
                    'current_user': raw,
                    'token': 'new-token',
                  });
                }),
              ),
            );
            expect((await repo.login('fixture', 'fake')).isFailure, isTrue);
          }
          expect(SessionManager.isAuthenticated, isFalse);
          expect(SessionService.to.user, isNull);
          expect(Cache.getdata(key: 'token'), isNull);
          expect(Cache.getdata(key: 'user'), isNull);
          expect(SessionManager.notice.value, isNotEmpty);
          if (entry.key == 'missing' ||
              entry.key == 'null' ||
              entry.value is! int) {
            expect(User.fromJson(raw).groupId, isNull);
          }
        },
      );
    }
  }
  for (var group = 1; group <= 7; group++) {
    test(
      'valid group $group retains session and survives nested legacy restore',
      () async {
        await establish(group);
        expect(SessionManager.isAuthenticated, isTrue);
        await Cache.saveData(
          key: 'user',
          value: jsonEncode(jsonEncode(identity(group))),
        );
        SessionService.to.clear();
        await SessionManager.restore();
        expect(SessionManager.isAuthenticated, isTrue);
        expect(SessionService.to.user!.groupId, group);
        expect(Cache.sharedPreferences.getKeys(), {'token', 'user'});
      },
    );
  }
  for (final malformed in [null, '', '{broken', 42, jsonEncode(identity())]) {
    test(
      'partial or malformed persisted session $malformed is rejected',
      () async {
        if (malformed != null) {
          await Cache.saveData(key: 'user', value: malformed);
        }
        // Valid user without token is invalid too.
        await SessionManager.restore();
        expect(SessionManager.isAuthenticated, isFalse);
        expect(Cache.sharedPreferences.getKeys(), isEmpty);
      },
    );
  }
  test('guard rejects same-token new session after clear', () async {
    await establish();
    final ticket = RequestGuard().begin();
    await SessionManager.clear();
    await establish();
    expect(ticket.isCurrent, isFalse);
  });
  test('late login after logout cannot restore authentication', () async {
    final net = PendingHttp();
    final repo = AuthRepositoryImpl(apiClient: ApiClient(client: net.client));
    final task = repo.login('fixture', 'fake');
    await net.started(1);
    await SessionManager.clear();
    net.finish(0, {'current_user': identity(), 'token': 'late'});
    expect((await task).isFailure, isTrue);
    expect(SessionManager.isAuthenticated, isFalse);
    expect(Cache.sharedPreferences.getKeys(), isEmpty);
  });
  test('older login cannot replace a newer authenticated identity', () async {
    final net = PendingHttp();
    final repo = AuthRepositoryImpl(apiClient: ApiClient(client: net.client));
    final a = repo.login('A', 'fake');
    final b = repo.login('B', 'fake');
    await net.started(2);
    net.finish(1, {'current_user': identity(7), 'token': 'B'});
    expect((await b).isSuccess, isTrue);
    net.finish(0, {'current_user': identity(1), 'token': 'A'});
    expect((await a).isFailure, isTrue);
    expect(SessionService.to.user!.groupId, 7);
    expect(Cache.getdata(key: 'token'), 'B');
  });
  test(
    'late business response after logout cannot update active reviewed controller',
    () async {
      await establish();
      final c = Techbills();
      final net = PendingHttp();
      await http.runWithClient(() async {
        final task = c.fetchTechBills();
        await net.started(1);
        await SessionManager.clear();
        net.finish(0, [techBill(1)]);
        await task;
        expect(c.techBills, isEmpty);
        expect(Cache.sharedPreferences.getKeys(), isEmpty);
      }, () => net.client);
      c.onClose();
    },
  );
  testWidgets(
    'protected navigation rejects unauthenticated access; public registration remains accessible; logout clears access',
    (tester) async {
      var protectedBuilds = 0;
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/Login',
          getPages: [
            GetPage(
              name: '/Login',
              page: () => const Scaffold(body: Text('login')),
            ),
            GetPage(
              name: '/NewUser',
              page: () => const Scaffold(body: Text('registration')),
            ),
            GetPage(
              name: '/protected',
              middlewares: [SessionMiddleware()],
              page: () {
                protectedBuilds++;
                return const Scaffold(body: Text('protected'));
              },
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      Get.toNamed('/protected');
      await tester.pumpAndSettle();
      expect(protectedBuilds, 0);
      expect(Get.currentRoute, '/Login');
      Get.toNamed('/NewUser');
      await tester.pumpAndSettle();
      expect(find.text('registration'), findsOneWidget);
      await tester.runAsync(() => establish());
      Get.toNamed('/protected');
      await tester.pumpAndSettle();
      expect(find.text('protected'), findsOneWidget);
      await tester.runAsync(() => SessionManager.logout());
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/Login');
      Get.toNamed('/protected');
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/Login');
      expect(Cache.sharedPreferences.getKeys(), isEmpty);
    },
  );
  testWidgets(
    'password change keeps session/navigation and preserves exact request',
    (tester) async {
      await tester.runAsync(() => establish());
      final original = SessionService.to.user;
      final net = PendingHttp();
      Get.put<AuthRepository>(
        AuthRepositoryImpl(apiClient: ApiClient(client: net.client)),
      );
      final c = ChangePasswordController();
      await tester.pumpWidget(
        GetMaterialApp(home: const Scaffold(body: Text('password screen'))),
      );
      final route = Get.currentRoute;
      await tester.runAsync(() async {
        final task = c.changePassword('old', 'new');
        await net.started(1);
        expect(net.requests.single.url.path, '/change-password');
        expect(net.requests.single.method, 'POST');
        expect(jsonDecode(net.requests.single.body), {
          'old_password': 'old',
          'new_password': 'new',
        });
        expect(
          net.requests.single.headers['Authorization'],
          'Bearer opaque-token',
        );
        net.finish(0, {});
        await task;
      });
      await tester.pumpAndSettle();
      expect(SessionManager.isAuthenticated, isTrue);
      expect(identical(original, SessionService.to.user), isTrue);
      expect(Get.currentRoute, route);
      if (Get.isDialogOpen == true) {
        Get.back();
        await tester.pumpAndSettle();
      }
      c.onClose();
    },
  );
  test(
    'all declared protected routes use middleware and public route names remain',
    () {
      final main = File('lib/main.dart').readAsStringSync();
      final declarations = main
          .split('\n')
          .where(
            (l) =>
                l.contains('GetPage(name:') && !l.trimLeft().startsWith('//'),
          );
      expect(declarations.length, 36);
      for (final line in declarations) {
        final name = RegExp("name: '([^']+)'").firstMatch(line)!.group(1)!;
        expect(
          line.contains('middlewares: [SessionMiddleware()]'),
          !SessionManager.publicRoutes.contains(name),
          reason: name,
        );
      }
      expect(
        File('lib/features/auth/view/screens/login.dart').readAsStringSync(),
        contains("Get.toNamed('/NewUser')"),
      );
    },
  );
  test(
    'no reusable API data cache or shared business list remains in source',
    () {
      final sources = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));
      for (final file in sources) {
        final s = file.readAsStringSync();
        expect(
          RegExp(r'\b(sessionCache|areasCache|valuesCache)\b').hasMatch(s),
          isFalse,
          reason: file.path,
        );
        expect(
          RegExp(r'\b(localStorage|sessionStorage|indexedDB)\b').hasMatch(s),
          isFalse,
          reason: file.path,
        );
      }
      expect(
        File('lib/global/data.dart').readAsStringSync(),
        isNot(contains('RxList')),
      );
    },
  );
  test(
    'new screen instance fetches its own response, never another screen data',
    () async {
      final a = Techbills(), b = Techbills();
      final net = PendingHttp();
      await http.runWithClient(() async {
        final first = a.fetchTechBills();
        await net.started(1);
        net.finish(0, [techBill(1)]);
        await first;
        final next = b.fetchTechBills();
        await net.started(2);
        expect(b.techBills, isEmpty);
        net.finish(1, [techBill(2)]);
        await next;
        expect(a.techBills.single.techBillId, 1);
        expect(b.techBills.single.techBillId, 2);
        expect(Cache.sharedPreferences.getKeys(), isEmpty);
      }, () => net.client);
      a.onClose();
      b.onClose();
    },
  );
  test(
    'logout during queued persistence cannot create a partial authenticated session',
    () async {
      final generation = SessionManager.beginLogin();
      final pending = SessionManager.establish(
        identity(),
        'opaque-token',
        generation,
      );
      final clearing = SessionManager.clear();
      expect(await pending, isFalse);
      await clearing;
      expect(SessionManager.isAuthenticated, isFalse);
      expect(Cache.sharedPreferences.getKeys(), isEmpty);
    },
  );
  test('dashboard derived lists preserve mapping without memoized copies', () {
    final raw = {
      'station_id': 7,
      'station_name': 'Fixture',
      'tech_bill_id': 9,
      'technology_bill_total': 12.5,
    };
    final model = ConsumptionModel.fromJson({
      'money': 45.25,
      'over_power_consump': [raw],
    });
    final first = model.overPowerConsump;
    final second = model.overPowerConsump;
    expect(identical(first, second), isFalse);
    expect(model.overPowerConsumpCount, 1);
    expect(first.single.stationId, 7);
    expect(second.single.techBillId, 9);
    expect(second.single.technologyBillTotal, '12.5');
    expect(model.money, 45.25);
  });
  testWidgets(
    'current unauthorized response clears both auth representations and redirects',
    (tester) async {
      await tester.runAsync(() => establish());
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/protected',
          getPages: [
            GetPage(
              name: '/protected',
              middlewares: [SessionMiddleware()],
              page: () => const Scaffold(body: Text('protected')),
            ),
            GetPage(
              name: '/Login',
              page: () => const Scaffold(body: Text('login')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => http.runWithClient(() async {
          await expectLater(
            fetchData('http://fixture.test/read'),
            throwsA(isA<ApiException>()),
          );
        }, () => MockClient((_) async => jsonResponse({}, status: 401))),
      );
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/Login');
      expect(SessionService.to.user, isNull);
      expect(Cache.getdata(key: 'user'), isNull);
      expect(Cache.getdata(key: 'token'), isNull);
    },
  );
}
