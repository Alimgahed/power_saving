
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';

class LoginController extends GetxController {
  late TextEditingController name;
  late TextEditingController password;

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
      final res = await http.post(
        Uri.parse("http://$ip/login"),
        body: {
          "name": name,
          "password": password,
        },
      );
      if (res.statusCode == 200) {
        // final Map<String, dynamic> jsonData = json.decode(res.body);
      //   USERname = name;
      //   userinfo = user.fromJson(jsonData);
      //   print(userinfo?.name);

      //   // ignore: unrelated_type_equality_checks
      //   if (userinfo?.dep_id == 2) {
      //     id.value = true;
      //   } else {
      //     id.value = false;
      //   }
      //   showSuccessToast("تم تسجيل الدخول بنجاح");
      //   // await get_departments();
      //   Get.offAll(() => home());
      // } else if (res.statusCode == 400) {
      //   showCustomErrorDialog(
      //       iconColor: Colors.red,
      //       buttonColor: Colors.red,
      //       title: "خطأ",
      //       errorMessage: res.body,
      //       titleColor: Colors.red);
      }
      // ignore: empty_catches
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> get_departments() async {
  //   try {
  //     final res = await http.get(
  //       Uri.parse("http://172.16.0.10:3000/home"),
  //     );

  //     if (res.statusCode == 200) {
  //       print(res.body);
  //     } else if (res.statusCode == 400) {
  //       showCustomErrorDialog(
  //           iconColor: Colors.red,
  //           buttonColor: Colors.red,
  //           title: "خطأ",
  //           errorMessage: "ليس لديك الصلاحية للدخول لهذه الادارة",
  //           titleColor: Colors.red);
  //     }
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }
}
