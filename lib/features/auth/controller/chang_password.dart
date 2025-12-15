import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class ChangePasswordController extends GetxController {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  var isLoading = false.obs;



  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
  Future<void> changePassword(String old, String newpassword ) async {
  try {
    isLoading.value = true;

   final res = await postData(
  "http://$ip/change-password",
  {
    "old_password": old,
    "new_password": newpassword,
  },
);


    isLoading.value = false;

    if (res.statusCode == 200) {
    

      showSuccessToast("تم تغيير كلمة المرور بنجاح");
      Get.offNamed('/home');
    } else {
      showCustomErrorDialog(errorMessage: "خطأ");
    }
  } catch (e) {
    isLoading.value = false;
  }
}
}