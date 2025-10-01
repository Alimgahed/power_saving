
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/login.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

import '../../shared_pref/cache.dart';

class LoginController extends GetxController {
  late TextEditingController name;
  late TextEditingController password;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    password = TextEditingController();
    name = TextEditingController();
  }

  // Override onClose to dispose of the controllers
  @override
  void onClose() {
    // Dispose of the controllers when the controller is closed
    password.dispose();
    name.dispose();

    super.onClose();
  }
  
  
// ignore: non_constant_identifier_names
Future<void> Login(String name, String password) async {
  try {
    isLoading.value = true;

   final res = await postData(
  "http://$ip/login",
  {
    "username": name,
    "password": password,
  },
);


    isLoading.value = false;

    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);

      // 👇 Optional: print to see structure
      print("Login response: $jsonResponse");

      // ✅ Step 1: Extract user info and token
      final userMap = jsonResponse['current_user']; // or just jsonResponse if no wrapper
      final token = jsonResponse['token']; // adjust based on actual structure

      // ✅ Step 2: Save to cache
       Cache.saveData(key: "user", value: jsonEncode(userMap));
       Cache.saveData(key: "token", value: token);

      // ✅ Step 3: Store in global `user` variable
      user = User.fromJson(userMap);

      // ✅ Step 4: Navigate to home
      Get.offNamed('/home');
    } else {
      final errorBody = jsonDecode(res.body);
      final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
      showCustomErrorDialog(errorMessage: errorMessage);
    }
  } catch (e) {
    isLoading.value = false;
  }
}

}
