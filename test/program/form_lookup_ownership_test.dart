import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/Counter/controller/add_counter_controller.dart';
import 'package:power_saving/features/Counter/controller/edit_counter_controller.dart';
import 'package:power_saving/features/planning/controller/place/add_places_controller.dart';
import 'package:power_saving/features/planning/controller/place/edit_places_controller.dart';
import 'package:power_saving/features/planning/controller/place/edit_place_type_controller.dart';
import 'package:power_saving/features/stations/controller/add_stations_controller.dart';
import 'package:power_saving/features/stations/controller/edit_stations_controller.dart';
import 'package:power_saving/features/relations/controller/add_relations_controller.dart';
import 'package:power_saving/features/chemcails/controller/add_chemacial.dart';
import '../state_management/fixtures.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'fixture'});
    await Cache.init();
    Get.put(SessionService());
  });
  tearDown(() => Get.reset());
  final factories = <String, GetxController Function()>{
    'add meter': addcounter.new,
    'edit meter': EditCounter.new,
    'add place': AddPlacesController.new,
    'edit place': EditPlacesController.new,
    'place types': EditPlaceTypeController.new,
    'add station': AddStationController.new,
    'edit station': EditStationsController.new,
    'relations': addrelationcontroller.new,
    'chemicals': addchemical.new,
  };
  for (final entry in factories.entries) {
    testWidgets(
      '${entry.key} lookup error after closure does not show a dialog',
      (tester) async {
        await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
        final net = PendingHttp();
        await tester.runAsync(
          () => http.runWithClient(() async {
            final c = entry.value()..onInit();
            final expected = entry.key.contains('station') ? 2 : 1;
            await net.started(expected);
            for (final r in net.requests) {
              expect(r.method, 'GET');
              expect(r.body, isEmpty);
              expect(r.headers['Authorization'], 'Bearer fixture');
            }
            c.onClose();
            for (var i = 0; i < net.requests.length; i++) {
              net.finish(i, {'message': 'error'}, status: 500);
            }
            await Future<void>.delayed(Duration.zero);
            expect(Get.isDialogOpen, isNot(true));
          }, () => net.client),
        );
        await tester.pumpAndSettle();
      },
    );
  }
}
