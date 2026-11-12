import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';
import 'package:power_saving/my_widget/sharable.dart';

class LocalTechnologies extends TechnlogyController {
  @override
  Future<void> alltechnology({
    bool isBackground = false,
    bool force = false,
  }) async {}
}

void main() {
  tearDown(() => Get.reset());
  test('technology catalog releases all six exclusively owned fields', () {
    final c = LocalTechnologies()..onInit();
    final fields = [
      c.name,
      c.chlorine,
      c.liquid,
      c.solid,
      c.power,
      c.searchController,
    ];
    c.onClose();
    for (final field in fields) {
      expect(() => field.addListener(() {}), throwsFlutterError);
    }
  });
  testWidgets('dropdown deferred initialization does not use a closed owner', (
    tester,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<SearchableDropdownController>(tag: 'test', force: true);
    });
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: SearchableDropdown(
            items: [DropdownMenuItem(value: 'a', child: Text('A'))],
            initialValue: 'a',
            onChanged: ignore,
            labelText: 'label',
            hintText: 'hint',
            tag: 'test',
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('dropdown still initializes while its owner is live', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: SearchableDropdown(
            items: [DropdownMenuItem(value: 'a', child: Text('A'))],
            initialValue: 'a',
            onChanged: ignore,
            labelText: 'label',
            hintText: 'hint',
            tag: 'test',
          ),
        ),
      ),
    );
    final c = Get.find<SearchableDropdownController>(tag: 'test');
    expect(c.selectedValue.value, 'a');
    expect(c.searchController.text, 'A');
    await tester.pumpWidget(const SizedBox());
  });
}

void ignore(String? value) {}
