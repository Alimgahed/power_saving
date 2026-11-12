import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';
import 'package:power_saving/features/stations/controller/all_stations_controller.dart';
import 'package:power_saving/features/planning/controller/place/places_controller.dart';
import 'package:power_saving/features/home/controller/home.dart';
import 'package:power_saving/features/auth/controller/all_user.dart';
import 'package:power_saving/features/predaction/controller/prediaction.dart';
import '../state_management/fixtures.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'fixture'});
    await Cache.init();
    Get.put(SessionService());
  });
  tearDown(() => Get.reset());
  for (final kind in [
    'meters',
    'stations',
    'places',
    'home',
    'users',
    'prediction',
  ]) {
    for (final scenario in ['latest', 'closed', 'closed-error']) {
      testWidgets('$kind $scenario response ownership preserves request', (
        tester,
      ) async {
        await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            late GetxController c;
            late Future<void> Function() read;
            late Object? Function() value;
            late Object Function(int) fixture;
            late String path;
            switch (kind) {
              case 'meters':
                final x = CounterController();
                c = x;
                read = x.fetchAllCounters;
                value = () => x.allcounter.firstOrNull?.meterId;
                path = '/gauges';
                fixture =
                    (id) => [
                      {
                        'meter_id': '$id',
                        'account_number': '$id',
                        'meter_factor': 1,
                        'final_reading': 0.0,
                      },
                    ];
              case 'stations':
                final x = StationsController();
                c = x;
                read = x.getStations;
                value = () => x.stations.firstOrNull?.stationName;
                path = '/stations';
                fixture =
                    (id) => [
                      {
                        'station_id': id,
                        'station_name': '$id',
                        'station_type': 'type',
                        'station_water_capacity': 5,
                      },
                    ];
              case 'places':
                final x = PlacesController();
                c = x;
                read = x.allPlaces;
                value = () => x.places.firstOrNull?.placeName;
                path = '/places';
                fixture =
                    (id) => [
                      {
                        'place_id': id,
                        'place_name': '$id',
                        'place_type_id': 1,
                        'branch_id': 1,
                        'area_id': 1,
                      },
                    ];
              case 'home':
                final x = HomeController();
                c = x;
                read = x.home;
                value = () => x.animatedMoney.value?.toInt().toString();
                path = '';
                fixture = (id) => {'money': id};
              case 'users':
                final x = AllUserController();
                c = x;
                read = x.loadUsers;
                value = () => x.users.firstOrNull?.empCode;
                path = '/all-users';
                fixture =
                    (id) => [
                      {
                        'emp_code': '$id',
                        'emp_name': 'name',
                        'username': 'name',
                        'group_id': 2,
                        'is_active': true,
                      },
                    ];
              case 'prediction':
                final x = Prediactioncontroller();
                c = x;
                read = () => x.prediactions(7);
                value = () => x.predictionModel?.expectedYear;
                path = '/prediction/7';
                fixture = (id) => {'expected_year': '$id'};
            }
            final first = read();
            await net.started(1);
            expect(
              net.requests.first.url.toString(),
              '${ApiConfig.baseUrl}$path',
            );
            expect(
              net.requests.first.method,
              kind == 'prediction' ? 'POST' : 'GET',
            );
            expect(net.requests.first.body, kind == 'prediction' ? '{}' : '');
            expect(
              net.requests.first.headers['Authorization'],
              'Bearer fixture',
            );
            if (scenario == 'latest') {
              final second = read();
              await net.started(2);
              net.finish(1, fixture(2));
              await second;
              expect(value(), '2');
              net.finish(0, fixture(1));
              await first;
              expect(value(), '2');
              c.onClose();
            } else {
              c.onClose();
              net.finish(
                0,
                scenario == 'closed' ? fixture(1) : {'message': 'failed'},
                status: scenario == 'closed' ? 200 : 500,
              );
              await first;
              expect(value(), isNull);
              expect(Get.isDialogOpen, isNot(true));
            }
          }, () => net.client),
        );
        await tester.pumpAndSettle();
      });
    }
  }
  for (final kind in ['meters', 'stations', 'places', 'users']) {
    testWidgets(
      '$kind background refresh terminates superseded foreground loading',
      (tester) async {
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            late GetxController c;
            late Future<void> Function(bool) read;
            late bool Function() loading;
            switch (kind) {
              case 'meters':
                final x = CounterController();
                c = x;
                read = (b) => x.fetchAllCounters(isBackground: b);
                loading = () => x.looading.value;
              case 'stations':
                final x = StationsController();
                c = x;
                read = (b) => x.getStations(isBackground: b);
                loading = () => x.loading.value;
              case 'places':
                final x = PlacesController();
                c = x;
                read = (b) => x.allPlaces(isBackground: b);
                loading = () => x.loading.value;
              case 'users':
                final x = AllUserController();
                c = x;
                read = (b) => x.loadUsers(isBackground: b);
                loading = () => x.isLoading.value;
            }
            final first = read(false);
            await net.started(1);
            expect(loading(), true);
            final second = read(true);
            await net.started(2);
            net.finish(0, []);
            await first;
            expect(loading(), true);
            net.finish(1, []);
            await second;
            expect(loading(), false);
            c.onClose();
          }, () => net.client),
        );
      },
    );
  }
}
