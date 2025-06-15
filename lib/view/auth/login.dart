import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:power_saving/controller/auth/login.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC), // Light clean background
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (controller) {
              return Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.energy_savings_leaf, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'تسجيل الدخول - قسم ترشيد الطاقة',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(controller: controller.name,
                    label: 'اسم المستخدم', icon: Icons.person, hintText: 'اسم المستخدم',),
                  const SizedBox(height: 16),
                  CustomTextFormField(controller:controller.password,
                  obscureText: true,
                    label: 'كلمة المرور', icon: Icons.lock, hintText: 'كلمة المرور',),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  
                ],
              ),
            );
            },
            
          ),
        ),
      ),
    );
  }

}
