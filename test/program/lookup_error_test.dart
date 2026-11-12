import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/stations/controller/following_stations_controller.dart';
import 'package:power_saving/features/stations/controller/add_stations_controller.dart';
import 'package:power_saving/features/stations/view/screens/following_stations.dart';
import 'package:power_saving/features/stations/view/screens/add_station.dart';
import '../state_management/fixtures.dart';

class LocalAddStation extends AddStationController {
  @override
  Future<void> allareas() async {}
}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'fixture'});
    await Cache.init();
    Get.put(SessionService());
  });
  tearDown(() => Get.reset());
  testWidgets('following stations failed lookup reaches a retry state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final net = PendingHttp();
    await tester.runAsync(
      () => http.runWithClient(() async {
        final c = FollowingStationsController();
        final pending = c.stationsTechs();
        await net.started(1);
        net.finish(0, {'message': 'failure'}, status: 500);
        await pending;
        Get.put(
          c,
        ); // onInit performs another lookup; complete it as a failure too.
        await net.started(2);
        net.finish(1, {'message': 'failure'}, status: 500);
        await Future<void>.delayed(Duration.zero);
      }, () => net.client),
    );
    await tester.pumpWidget(
      const GetMaterialApp(home: FollowingStationsScreen()),
    );
    await tester.pump();
    expect(find.text('إعادة المحاولة'), findsOneWidget);
    await tester.runAsync(
      () => http.runWithClient(() async {
        await tester.tap(find.text('إعادة المحاولة'));
        await net.started(3);
        expect(net.requests.last.method, 'GET');
        expect(net.requests.last.url.path, '/station-techs');
        net.finish(2, []);
        await Future<void>.delayed(Duration.zero);
      }, () => net.client),
    );
    await tester.pump();
    expect(find.text('إعادة المحاولة'), findsNothing);
    expect(find.text('لا توجد محطات متاحة.'), findsOneWidget);
    expect(Get.find<FollowingStationsController>().isLoading, false);
  });
  testWidgets(
    'add station failed branch lookup preserves form and exposes retry',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final net = PendingHttp();
      await tester.runAsync(
        () => http.runWithClient(() async {
          Get.put(AddStationController());
          await net.started(2);
          for (var i = 0; i < 2; i++) {
            net.finish(
              i,
              net.requests[i].url.path.endsWith('/all-areas')
                  ? []
                  : {'message': 'failure'},
              status:
                  net.requests[i].url.path.endsWith('/all-areas') ? 200 : 500,
            );
          }
          await Future<void>.delayed(Duration.zero);
        }, () => net.client),
      );
      await tester.pumpWidget(GetMaterialApp(home: AddStationScreen()));
      await tester.pump();
      expect(find.text('إعادة المحاولة'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      final c = Get.find<AddStationController>();
      c.name.text = 'محطة محفوظة';
      await tester.runAsync(
        () => http.runWithClient(() async {
          await tester.tap(find.text('إعادة المحاولة'));
          await net.started(3);
          expect(net.requests.last.method, 'GET');
          expect(net.requests.last.url.path, '/new-station');
          net.finish(2, {'branches': [], 'water_sources': []});
          await Future<void>.delayed(Duration.zero);
        }, () => net.client),
      );
      await tester.pump();
      expect(find.text('إعادة المحاولة'), findsNothing);
      expect(c.name.text, 'محطة محفوظة');
      expect(c.branchesLoading, false);
      expect(find.text('لا توجد فروع أو مصادر مياه متاحة.'), findsOneWidget);
    },
  );
  for (final branch in [false, true]) {
    testWidgets('lookup ignores response after close branch=$branch', (
      tester,
    ) async {
      final net = PendingHttp();
      await tester.runAsync(
        () => http.runWithClient(() async {
          if (branch) {
            final c = LocalAddStation()..onInit();
            await net.started(1);
            c.onClose();
            net.finish(0, {
              'branches': [
                {'branch_id': 1, 'branch_name': 'B'},
              ],
              'water_sources': [],
            });
            await Future<void>.delayed(Duration.zero);
            expect(c.branchList, isEmpty);
          } else {
            final c = FollowingStationsController();
            final pending = c.stationsTechs();
            await net.started(1);
            c.onClose();
            net.finish(0, [
              {
                'station_id': 1,
                'station_name': 'S',
                'station_type': 'T',
                'station_water_capacity': 5,
                'branch_name': 'B',
                'water_source_name': 'W',
                'techs': [],
              },
            ]);
            await pending;
            expect(c.stations, isEmpty);
          }
        }, () => net.client),
      );
    });
  }
}
