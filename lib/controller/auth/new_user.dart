import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class NewUsercontroller extends GetxController{
  RxBool isLoading = false.obs;

   late TextEditingController name;
  late TextEditingController password;
  late TextEditingController confirmpassword;
  late TextEditingController username;
    late TextEditingController code;


  @override
  void onInit() {
    super.onInit();
    password = TextEditingController();
    name = TextEditingController();
      confirmpassword = TextEditingController();
    username = TextEditingController();
    code=TextEditingController();

  }

  // Override onClose to dispose of the controllers
  @override
  void onClose() {
    // Dispose of the controllers when the controller is closed
    password.dispose();
    name.dispose();
    confirmpassword.dispose();
    username.dispose();
    code.dispose();

    super.onClose();
  }

  // ignore: non_constant_identifier_names
  Future<void> new_user({required String name,required String password,
  required String username,required String code,} ) async {
    try {
      isLoading.value==true;

      final res = await postData(
        "http://$ip/register",

        {
          "username": username,
          "password": password,
          "emp_code":code,
          "emp_name":name,

        });
      
      if (res.statusCode == 200) {
           isLoading.value==false;
showSuccessToast("تم تسجيل المستخدم بنجاح");
      }else{
 final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
        isLoading.value==false;

    }
  }

}