import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/auth/controller/all_user.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/features/auth/view/screens/all_user.dart';

class DialogUsers extends AllUserController {
  User? submitted;
  @override
  Future<void> loadUsers({bool isBackground = false}) async {}
  @override
  Future<void> editUser(int index, User editedUser) async { submitted = editedUser; }
}
void main() {
  tearDown(() => Get.reset());
  for (final dismiss in ['cancel', 'barrier', 'route']) {
    testWidgets('user dialog releases owned fields after $dismiss dismissal', (tester) async {
      Get.testMode = true;
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = Get.put<AllUserController>(DialogUsers()) as DialogUsers;
      c.users.add(User(empCode:'123', empName:'اسم اختبار', username:'test', groupId:1, isActive:true));
      await tester.pumpWidget(const GetMaterialApp(home: AllUserScreen()));
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();
      final fields = tester.widgetList<TextField>(find.descendant(of:find.byType(Dialog), matching:find.byType(TextField))).map((w) => w.controller!).toList();
      expect(fields.length, 3);
      expect(fields.map((c) => c.text), ['123','اسم اختبار','test']);
      final toggle = tester.widget<ValueListenableBuilder<bool>>(find.ancestor(of: find.byType(Switch), matching: find.byType(ValueListenableBuilder<bool>)).first).valueListenable;
      await tester.tap(find.text('حفظ'));
      await tester.pump();
      expect(c.submitted!.toJson(), c.users.single.copyForTest());
      expect(find.byType(Dialog), findsOneWidget);
      if (dismiss == 'cancel') { await tester.tap(find.text('إلغاء')); }
      else if (dismiss == 'barrier') { await tester.tapAt(const Offset(10,100)); }
      else { Get.back(); }
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      for (final field in fields) { expect(() => field.addListener(() {}), throwsFlutterError); }
      expect(() => toggle.addListener(() {}), throwsFlutterError);
      expect(tester.takeException(), isNull);
    });
  }
}
extension on User {
  Map<String,dynamic> copyForTest() => User(empCode:empCode,empName:empName,username:username,groupId:groupId,isActive:isActive,reset:false).toJson();
}
