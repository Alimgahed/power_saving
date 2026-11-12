import 'package:get/get.dart';
import 'package:power_saving/features/stations/controller/add_stations_controller.dart';
import 'package:power_saving/features/stations/view/screens/add_station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power_saving/my_widget/sharable.dart';

class LayoutStation extends AddStationController {
  @override Future<void> allBranches() async {}
  @override Future<void> allareas() async {}
}
void main() {
  tearDown(()=>Get.reset());
  for(final width in [375.0,768.0,1440.0]) {
    testWidgets('full add station form fits viewport $width',(tester) async {
      tester.view.physicalSize=Size(width,1000);tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
      Get.put<AddStationController>(LayoutStation());
      await tester.pumpWidget(GetMaterialApp(home:AddStationScreen()));await tester.pump();
      expect(tester.takeException(),isNull);expect(find.byType(TextFormField),findsWidgets);
      expect(find.byType(DropdownButtonFormField<int>),findsNWidgets(3));
      expect(find.byType(DropdownButtonFormField<String>),findsOneWidget);
    });
  }

  for (final width in [160.0, 240.0, 375.0]) {
    testWidgets(
      'dropdown keeps all items and validation within $width pixels',
      (tester) async {
        final key = GlobalKey<FormState>();
        String? selected;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: width,
                  child: Form(
                    key: key,
                    child: CustomDropdownFormField<String>(
                      labelText: 'نوع المحطة',
                      hintText: 'اختر نوع المحطة المطلوبة',
                      prefixIcon: Icons.water,
                      items: const [
                        DropdownMenuItem(value: 'a', child: Text('مياه')),
                        DropdownMenuItem(value: 'b', child: Text('صرف')),
                      ],
                      onChanged: (v) => selected = v,
                      validator:
                          (v) => v == null ? 'الرجاء اختيار نوع المحطة' : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(key.currentState!.validate(), false);
        await tester.pump();
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        expect(find.text('مياه'), findsWidgets);
        expect(find.text('صرف'), findsWidgets);
        await tester.tap(find.text('صرف').last);
        await tester.pumpAndSettle();
        expect(selected, 'b');
        expect(key.currentState!.validate(), true);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
