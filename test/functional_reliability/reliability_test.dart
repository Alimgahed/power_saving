import 'dart:convert';
import 'dart:async';
import 'package:http/testing.dart';
import 'package:power_saving/features/analysis/view/screen/analysis.dart';
import 'package:power_saving/features/chemcails/view/widgets/chemical_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import 'package:power_saving/features/chemcails/controller/chemacial.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';
import 'package:power_saving/features/auth/controller/new_user.dart';
import 'package:power_saving/features/analysis/controller/analysis.dart';
import 'package:power_saving/controller/voltage/financial.dart';
import '../state_management/fixtures.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'synthetic'});
    await Cache.init();
    Get.put(SessionService());
  });
  tearDown(() {
    Get.reset();
  });
  testWidgets(
    'UX-02 typing and clearing preserve branch filter and draft without requests',
    (tester) async {
      final c = Techbills();
      final net = PendingHttp();
      await tester.runAsync(
        () => http.runWithClient(() async {
          c.onInit();
          await net.started(1);
          net.finish(0, [techBill(1), techBill(2, branch: 'South')]);
          await tester.pump();
          c.filterByBranch('South');
          c.getChlorineController(2).text = '7.5';
          c.searchController.text = 'unmatched';
          c.onSearchChanged('unmatched');
          await Future<void>.delayed(const Duration(milliseconds: 350));
          expect(c.filteredTechBills, isEmpty);
          c.searchController.clear();
          c.onSearchChanged('');
          await Future<void>.delayed(const Duration(milliseconds: 350));
          expect(c.filteredTechBills.single.techBillId, 2);
          expect(c.getChlorineController(2).text, '7.5');
          expect(net.requests, hasLength(1));
          c.onClose();
          await Future<void>.delayed(const Duration(milliseconds: 350));
        }, () => net.client),
      );
    },
  );
  for (final kind in ['chemicals', 'relations', 'technology']) {
    for (final status in [200, 500]) {
      testWidgets(
        'UX-03 $kind network refresh waits and terminates on $status',
        (tester) async {
          await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
          final dynamic c = switch (kind) {
            'chemicals' => Chemacialcontroller(),
            'relations' => RelationsController(),
            _ => TechnlogyController(),
          };
          final net = PendingHttp();
          bool done = false;
          await tester.runAsync(
            () => http.runWithClient(() async {
              final Future<void> task = c.forceRefresh();
              task.then((_) {
                done = true;
              });
              await net.started(1);
              await tester.pump();
              expect(done, isFalse);
              net.finish(
                0,
                status == 200 ? [] : {'message': 'synthetic failure'},
                status: status,
              );
              await task;
              await tester.pump();
              expect(done, isTrue);
              expect(
                kind == 'technology' ? c.isLoading.value : c.loading.value,
                isFalse,
              );
              expect((c.loadError.value as String).isNotEmpty, status != 200);
              expect(net.requests.single.method, 'GET');
              expect(
                net.requests.single.url.path,
                {
                  'chemicals': '/chemicals',
                  'relations': '/stg-relations',
                  'technology': '/technologies',
                }[kind],
              );
              expect(
                net.requests.single.headers['Authorization'],
                'Bearer synthetic',
              );
            }, () => net.client),
          );
          c.onClose();
        },
      );
    }
  }
  for (final status in [200, 500]) {
    testWidgets(
      'UX-04 registration excludes duplicate submits and terminates $status',
      (tester) async {
        await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
        final c = NewUsercontroller()..onInit();
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            Future<void> submit() => c.new_user(
              name: 'Employee',
              password: 'fake',
              username: 'fixture',
              code: '012',
            );
            final task = submit();
            await net.started(1);
            final duplicate = submit();
            expect(c.isLoading.value, isTrue);
            await duplicate;
            expect(net.requests, hasLength(1));
            expect(net.requests.single.url.path, '/register');
            expect(net.requests.single.method, 'POST');
            expect(jsonDecode(net.requests.single.body), {
              'username': 'fixture',
              'password': 'fake',
              'emp_code': '012',
              'emp_name': 'Employee',
            });
            net.finish(0, {'message': 'fixture'}, status: status);
            await task;
            expect(c.isLoading.value, isFalse);
          }, () => net.client),
        );
        await tester.pumpAndSettle();
        if (Get.isDialogOpen == true) {
          Get.back();
          await tester.pumpAndSettle();
        }
        c.onClose();
      },
    );
  }
  for (final financial in [false, true]) {
    for (final status in [200, 500]) {
      testWidgets(
        'REL-01 ${financial ? 'financial' : 'analysis'} terminates $status and retries same request',
        (tester) async {
          await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
          final dynamic c = financial ? FinancialController() : Analysis();
          final net = PendingHttp();
          await tester.runAsync(
            () => http.runWithClient(() async {
              Future<void> load() async {
                if (financial) {
                  await c.financialAnalysis();
                } else {
                  await c.getAnalysis(station: 7, tech: 9);
                }
              }

              final a = load();
              await net.started(1);
              net.finish(0, {}, status: status);
              await a;
              expect(financial ? c.loading.value : c.isLoading, isFalse);
              expect((c.errorMessage as String).isNotEmpty, status != 200);
              final b = load();
              await net.started(2);
              net.finish(
                1,
                financial
                    ? {'water_chart': '<div>fixture</div>'}
                    : {'power_plot': 'fixture'},
              );
              await b;
              expect(c.errorMessage, isEmpty);
              expect(
                financial ? c.waterChartHtml : c.anl.power,
                financial ? '<div>fixture</div>' : 'fixture',
              );
              expect(net.requests[0].url, net.requests[1].url);
              expect(
                net.requests[0].url.path,
                financial ? '/financial-analysis' : '/analysis-single/7/9',
              );
            }, () => net.client),
          );
          c.onClose();
        },
      );
    }
  }
  for (final financial in [false, true]) {
    for (final failure in ['malformed', 'timeout']) {
      testWidgets(
        'REL-01 ${financial ? 'financial' : 'analysis'} $failure exits loading',
        (tester) async {
          final dynamic c = financial ? FinancialController() : Analysis();
          await tester.runAsync(
            () => http.runWithClient(
              () async {
                if (financial) {
                  await c.financialAnalysis();
                } else {
                  await c.getAnalysis(station: 7, tech: 9);
                }
                expect(financial ? c.loading.value : c.isLoading, isFalse);
                expect(c.errorMessage, isNotEmpty);
                expect(financial ? c.waterChartHtml : c.anl, isNull);
              },
              () => MockClient((_) async {
                if (failure == 'timeout') throw TimeoutException('synthetic');
                return http.Response('invalid json', 200);
              }),
            ),
          );
          c.onClose();
        },
      );
    }
    testWidgets(
      'REL-01 ${financial ? 'financial' : 'analysis'} newer result rejects older failure',
      (tester) async {
        final dynamic c = financial ? FinancialController() : Analysis();
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            Future<void> load() async {
              if (financial) {
                await c.financialAnalysis();
              } else {
                await c.getAnalysis(station: 7, tech: 9);
              }
            }

            final a = load();
            final b = load();
            await net.started(2);
            net.finish(
              1,
              financial ? {'water_chart': 'new'} : {'power_plot': 'new'},
            );
            await b;
            net.finish(0, {'message': 'old'}, status: 500);
            await a;
            expect(c.errorMessage, isEmpty);
            expect(financial ? c.waterChartHtml : c.anl.power, 'new');
          }, () => net.client),
        );
        c.onClose();
      },
    );
  }
  testWidgets(
    'REL-01 route arguments load once across rebuild; error retry leads to empty',
    (tester) async {
      final rebuild = ValueNotifier(0);
      final net = PendingHttp();
      await tester.pumpWidget(
        GetMaterialApp(
          home: const Scaffold(),
          getPages: [
            GetPage(
              name: '/analysis',
              page:
                  () => ValueListenableBuilder<int>(
                    valueListenable: rebuild,
                    builder:
                        (_, value, child) =>
                            AnalysisView(key: const ValueKey('analysis')),
                  ),
            ),
          ],
        ),
      );
      await tester.runAsync(
        () => http.runWithClient(() async {
          Get.toNamed('/analysis', arguments: {'station': 7, 'tech': 9});
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          await net.started(1);
          rebuild.value++;
          await tester.pump();
          expect(net.requests, hasLength(1));
          net.finish(0, {}, status: 500);
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          expect(find.text('إعادة المحاولة'), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
          await tester.tap(find.text('إعادة المحاولة'));
          await tester.pump();
          await net.started(2);
          net.finish(1, {});
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          expect(find.text('لا توجد رسوم بيانية متاحة'), findsOneWidget);
          expect(net.requests, hasLength(2));
        }, () => net.client),
      );
      await tester.pumpWidget(const SizedBox());
      rebuild.dispose();
    },
  );
  testWidgets(
    'UX-03 catalog error is distinct from empty and retry loads again',
    (tester) async {
      final c = Chemacialcontroller();
      final net = PendingHttp();
      await tester.pumpWidget(
        GetMaterialApp(home: Scaffold(body: ChemicalsBody(controller: c))),
      );
      await tester.runAsync(
        () => http.runWithClient(() async {
          final a = c.forceRefresh();
          await net.started(1);
          net.finish(0, {}, status: 500);
          await a;
          await tester.pump();
          expect(find.text('إعادة المحاولة'), findsOneWidget);
          await tester.tap(find.text('إعادة المحاولة'));
          await net.started(2);
          net.finish(1, []);
          await Future<void>.delayed(Duration.zero);
          await tester.pump();
          expect(find.text('لا توجد بيانات للعرض'), findsOneWidget);
          expect(c.loading.value, isFalse);
        }, () => net.client),
      );
      c.onClose();
    },
  );
  for (final kind in ['chemicals', 'relations', 'technology']) {
    testWidgets(
      'UX-03 $kind no cached data appears while newest refresh owns state',
      (tester) async {
        Map<String, dynamic> row(int id) => switch (kind) {
          'chemicals' => {
            'chemical_id': id,
            'technology_id': id,
            'water_source_id': 1,
            'season': 'summer',
            'technology_name': 'T$id',
            'chlorine_range_from': 1,
            'chlorine_range_to': 2,
          },
          'relations' => {
            'account_number': 'A$id',
            'relation_status': true,
            'station_id': id,
            'station_name': 'S$id',
            'technology_id': id,
          },
          _ => {
            'technology_id': id,
            'technology_name': 'T$id',
            'technology_main_type': 'water',
            'power_per_water': 1.25,
          },
        };
        final dynamic c = switch (kind) {
          'chemicals' => Chemacialcontroller(),
          'relations' => RelationsController(),
          _ => TechnlogyController(),
        };
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            Future<void> load() async {
              if (kind == 'chemicals') {
                await c.getchemicals();
              } else if (kind == 'relations') {
                await c.getRelations();
              } else {
                await c.alltechnology();
              }
            }

            final a = load();
            await net.started(1);
            expect(c.isRefreshing.value, isFalse);
            expect(
              kind == 'technology' ? c.isLoading.value : c.loading.value,
              isTrue,
            );
            expect(
              kind == 'chemicals'
                  ? c.chemicals.length
                  : kind == 'relations'
                  ? c.relations.length
                  : c.filteredTechnologies.length,
              0,
            );
            final Future<void> b = c.forceRefresh();
            await net.started(2);
            net.finish(1, [row(2)]);
            await b;
            net.finish(0, {}, status: 500);
            await a;
            expect(c.loadError.value, isEmpty);
            expect(c.isRefreshing.value, isFalse);
            expect(
              kind == 'chemicals'
                  ? c.chemicals.single.technologyId
                  : kind == 'relations'
                  ? c.relations.single.technologyId
                  : c.filteredTechnologies.single.technologyId,
              2,
            );
            expect(net.requests, hasLength(2));
          }, () => net.client),
        );
        c.onClose();
      },
    );
  }
}
