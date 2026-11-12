import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/place/edit_places_controller.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/features/planning/view/screens/places/edit_places.dart';
import 'package:power_saving/features/stations/controller/edit_stations_controller.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/features/stations/view/screens/edit_staion.dart';

class LocalPlace extends EditPlacesController {
  @override
  Future<void> allNewData() async {}
}
class LocalStation extends EditStationsController {
  @override
  Future<void> allBranches() async {}
  @override
  Future<void> allareas() async {}
}

void main() {
  tearDown(() => Get.reset());
  for (final station in [false, true]) {
    for (final close in [false, true]) {
      testWidgets('${station ? 'station' : 'place'} deferred init ${close ? 'closed' : 'live'} owner', (tester) async {
        Get.testMode = true;
        tester.view.physicalSize = const Size(1440, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
        final p = LocalPlace();
        final s = LocalStation();
        if (station) { Get.put<EditStationsController>(s); }
        else { Get.put<EditPlacesController>(p); }
        Get.to(() => station ? EditStationsScreen() : EditPlacesScreen(), arguments: station
          ? {'Stations': Station(stationName: 'محطة اختبار', stationType: 'مياة', stationWaterCapacity: 100)}
          : {'place': Place(placeName: 'مكان اختبار', placeTypeId: 1, branchId: 1, areaId: 1)});
        if (close) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (station) { Get.delete<EditStationsController>(force: true); }
            else { Get.delete<EditPlacesController>(force: true); }
          });
        }
        await tester.pump();
        expect(tester.takeException(), isNull);
        if (!close) {
          expect(station ? s.name.text : p.name.text, station ? 'محطة اختبار' : 'مكان اختبار');
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });
    }
  }
}
