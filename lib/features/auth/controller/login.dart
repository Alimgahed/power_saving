import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/auth/domain/repositories/auth_repository.dart';
import 'package:power_saving/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:power_saving/my_widget/sharable.dart';

class LoginController extends GetxController {
  late TextEditingController name;
  late TextEditingController password;
  final RxBool isLoading = false.obs;
  
  // Dependency injection via GetX
  final AuthRepository _authRepository = Get.put<AuthRepository>(AuthRepositoryImpl());

  @override
  void onInit() {
    super.onInit();
    password = TextEditingController();
    name = TextEditingController();
  }

  @override
  void onClose() {
    password.dispose();
    name.dispose();
    super.onClose();
  }

  /// Performs user authentication using robust Repository Pattern
  Future<void> login(String name, String password) async {
    try {
      isLoading.value = true;

      final result = await _authRepository.login(name, password);

      isLoading.value = false;

      result.fold(
        (userData) {
          // Success pathway: store User instance dynamically in session
          user = userData;
          Get.offNamed('/home');
        },
        (failure) {
          // Failure pathway: map failure message securely to custom user dialogs
          showCustomErrorDialog(errorMessage: failure.message);
        },
      );
    } catch (e) {
      isLoading.value = false;
      showCustomErrorDialog(errorMessage: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }
}
