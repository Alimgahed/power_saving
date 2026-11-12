import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/Counter/controller/edit_counter_controller.dart';
import 'package:power_saving/features/Counter/view/screens/edit_counter.dart';
import 'package:power_saving/features/chemcails/controller/add_chemacial.dart';
import 'package:power_saving/features/chemcails/view/screens/edit_chemcials.dart';
import 'package:power_saving/features/planning/controller/place/edit_places_controller.dart';
import 'package:power_saving/features/planning/view/screens/places/edit_places.dart';
import 'package:power_saving/features/stations/controller/edit_stations_controller.dart';
import 'package:power_saving/features/stations/view/screens/edit_staion.dart';
import 'package:power_saving/features/technology/view/screens/edittech.dart';
import 'package:power_saving/features/analysis/view/screen/analysis.dart';
import 'edit_initialization_lifecycle_test.dart' show LocalPlace, LocalStation;

class LocalMeter extends EditCounter {
  @override
  Future<void> allVoltige() async {}
}
class LocalChemical extends addchemical {
  @override
  void getchemicals() {}
}
void main() {
  tearDown(() => Get.reset());
  final screens = <String, Widget Function()>{
    '/Places': EditPlacesScreen.new,
    '/Stations': EditStationsScreen.new,
    '/Countrts': EditCounterScreen.new,
    '/Chemicals': EditChemcials.new,
    '/Technology': EditTechScreen.new,
  };
  for (final entry in screens.entries) {
    for (final replaced in [false, true]) {
      testWidgets('${entry.key} missing args ${replaced ? 'does not hijack replacement' : 'uses existing fallback'}', (tester) async {
        Get.testMode = true;
        tester.view.physicalSize = const Size(1440, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        // Read-only dependencies are stubbed; no backend requests or mutations.
        Get.put<EditPlacesController>(LocalPlace());
        Get.put<EditStationsController>(LocalStation());
        Get.put<EditCounter>(LocalMeter());
        Get.put<addchemical>(LocalChemical());
        await tester.pumpWidget(GetMaterialApp(
          initialRoute: '/start',
          getPages: [
            GetPage(name:'/start',page:()=>const Scaffold()),
            GetPage(name:'/edit',page:entry.value),
            GetPage(name:entry.key,page:()=>Scaffold(body:Text('fallback ${entry.key}'))),
            GetPage(name:'/replacement',page:()=>const Scaffold(body:Text('replacement'))),
          ],
        ));
        await tester.pumpAndSettle();
        Get.toNamed('/edit');
        if (replaced) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed('/replacement'));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(Get.currentRoute, replaced ? '/replacement' : entry.key);
      });
    }
  }
  for (final covered in [false, true]) {
    testWidgets('analysis missing args ${covered ? "cannot pop newer route" : "returns to previous route"}', (tester) async {
      Get.testMode = true;
      await tester.pumpWidget(GetMaterialApp(initialRoute:'/start',getPages:[
        GetPage(name:'/start',page:()=>const Scaffold()),
        GetPage(name:'/analysis',page:()=>const AnalysisView()),
        GetPage(name:'/replacement',page:()=>const Scaffold(body:Text('replacement'))),
      ]));
      await tester.pumpAndSettle();
      Get.toNamed('/analysis');
      if (covered) {
        WidgetsBinding.instance.addPostFrameCallback((_) => Get.toNamed('/replacement'));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(Get.currentRoute, covered ? '/replacement' : '/start');
    });
  }

}
