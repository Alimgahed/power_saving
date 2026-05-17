import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/auth/domain/repositories/auth_repository.dart';
import 'package:power_saving/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:power_saving/my_widget/sharable.dart';

class ChangePasswordController extends GetxController {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final RxBool isLoading = false.obs;

  // Injection of AuthRepository interface
  final AuthRepository _authRepository = Get.put<AuthRepository>(AuthRepositoryImpl());

  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  /// Triggers safe password updates via the repository
  Future<void> changePassword(String old, String newpassword) async {
    try {
      isLoading.value = true;

      final result = await _authRepository.changePassword(old, newpassword);

      isLoading.value = false;

      result.fold(
        (success) {
          if (success) {
            showSuccessToast("تم تغيير كلمة المرور بنجاح");
            Get.offNamed('/home');
          } else {
            showCustomErrorDialog(errorMessage: "فشل تغيير كلمة المرور.");
          }
        },
        (failure) {
          showCustomErrorDialog(errorMessage: failure.message);
        },
      );
    } catch (e) {
      isLoading.value = false;
      showCustomErrorDialog(errorMessage: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }
}