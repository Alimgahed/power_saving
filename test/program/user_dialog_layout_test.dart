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
  for (final width in [375.0, 768.0, 1440.0]) {
    testWidgets('user card and edit dialog preserve controls at $width', (tester) async {
      Get.testMode = true;
      tester.view.physicalSize = Size(width, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = Get.put<AllUserController>(DialogUsers()) as DialogUsers;
      c.users.add(User(empCode:'123', empName:'اسم اختبار', username:'test', groupId:1, isActive:true));
      await tester.pumpWidget(const GetMaterialApp(home: AllUserScreen()));
      expect(tester.takeException(), isNull);
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)), findsNWidgets(3));
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
      await tester.ensureVisible(find.text('حفظ'));
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      expect(c.submitted!.empName, 'اسم اختبار');
      expect(c.submitted!.groupId, 1);
      expect(tester.takeException(), isNull);
      Get.back();
      await tester.pumpAndSettle();
    });
  }
}
