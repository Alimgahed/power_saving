import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/auth/new_user.dart';
import 'package:power_saving/my_widget/sharable.dart';

class NewUser extends StatelessWidget {
  const NewUser({super.key});

  @override
  Widget build(BuildContext context) {


    final RxString selectedRole = ''.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC),
    appBar: AppBar(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  automaticallyImplyLeading: false,
  leading:  IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      // fallback behavior: navigate to home or a safe route
      Get.offAllNamed('/home');
    }
  
          },
        ),
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text("إنشاء حساب جديد", textDirection: TextDirection.rtl,style: TextStyle(fontSize: 20),),
         
        ],
      ),
    ),
  ],
),

      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<NewUsercontroller>(
            init: NewUsercontroller(),
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
                children: [
                  const Icon(Icons.person_add, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'إنشاء حساب مستخدم جديد',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
            
                  CustomTextFormField(
                    label: 'الاسم الكامل',
                    hintText: 'أدخل الاسم الكامل',
                    icon: Icons.person,
                    controller:controller.name ,
                  ),
                  const SizedBox(height: 16),
            
                  CustomTextFormField(
                    label: 'البريد الإلكتروني',
                    hintText: 'أدخل البريد الإلكتروني',
                    icon: Icons.email,
                    controller:controller.email
                  ),
                  const SizedBox(height: 16),
            
                  CustomTextFormField(
                    label: 'كلمة المرور',
                    hintText: '********',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: controller.password,
                  ),
                  const SizedBox(height: 16),
            
                  CustomTextFormField(
                    label: 'تأكيد كلمة المرور',
                    hintText: '********',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: controller.confirmpassword,
                  ),
                  const SizedBox(height: 16),
            
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'الدور الوظيفي',
                        prefixIcon: const Icon(Icons.security, color: Colors.blue),
                        filled: true,
                        fillColor: const Color(0xFFF5F8FB),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: selectedRole.value == '' ? null : selectedRole.value,
                      items: ['مشرف', 'مستخدم', 'مدير']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedRole.value = value!;
                      },
                    );
                  }),
            
                  const SizedBox(height: 32),
            
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add validation and controller logic here
                        Get.snackbar('تم الإنشاء', 'تم إنشاء المستخدم بنجاح',
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black87);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('إنشاء المستخدم'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
