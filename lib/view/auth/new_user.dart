import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/auth/new_user.dart';
import 'package:power_saving/my_widget/sharable.dart';

class NewUser extends StatelessWidget {
  NewUser({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      Get.offNamed('/Login');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
            )
          ],
          title: const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF8FAFC),
                Colors.blue.shade50,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: GetBuilder<NewUsercontroller>(
                init: NewUsercontroller(),
                builder: (controller) {
                  return Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header Section with Gradient
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.blue.shade800],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'إنشاء مستخدم جديد',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Form Section
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _globalKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name Field using CustomTextFormField
                                CustomTextFormField(
                                  label: 'الاسم الكامل',
                                  hintText: 'أدخل الاسم الكامل',
                                  icon: Icons.person,
                                  controller: controller.name,
                                ),

                                const SizedBox(height: 16),

                                // Employee Code Field using CustomTextFormField
                                CustomTextFormField(
                                  label: 'كود الموظف',
                                  hintText: 'أدخل كود الموظف',
                                  icon: Icons.badge,
                                  controller: controller.code,
                                ),

                                const SizedBox(height: 16),

                                // Username Field using CustomTextFormField
                                CustomTextFormField(
                                  label: 'اسم المستخدم',
                                  hintText: 'أدخل اسم المستخدم',
                                  icon: Icons.account_circle,
                                  controller: controller.username,
                                ),

                                const SizedBox(height: 16),

                                // Password Field using CustomTextFormField
                                CustomTextFormField(
                                  label: 'كلمة المرور',
                                  hintText: 'أدخل كلمة المرور',
                                  icon: Icons.lock,
                                  controller: controller.password,
                                  obscureText: true,
                                ),

                                const SizedBox(height: 16),

                                // Confirm Password Field using CustomTextFormField
                                CustomTextFormField(
                                  label: 'تأكيد كلمة المرور',
                                  hintText: 'أعد إدخال كلمة المرور',
                                  icon: Icons.lock_outline,
                                  controller: controller.confirmpassword,
                                  obscureText: true,
                                ),

                                const SizedBox(height: 32),

                                // Create User Button - Optimized with AnimatedSwitcher
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        if (_globalKey.currentState!.validate()) {
                                          if (controller.password.text != controller.confirmpassword.text) {
                                            showCustomErrorDialog(errorMessage: "كلمة المرور غير متطابقة");
                                          } else {
                                            controller.new_user(
                                              name: controller.name.text,
                                              password: controller.password.text,
                                              username: controller.username.text,
                                              code: controller.code.text,
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        child: Obx(() {
                                          return AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 300),
                                            child: controller.isLoading.value
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'إنشاء المستخدم',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Footer Note
                                Center(
                                  child: Text(
                                    'سيتم إضافة المستخدم بصلاحيات محدودة',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}