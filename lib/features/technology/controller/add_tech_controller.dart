// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class AddTechController extends GetxController {
  RxBool looading = false.obs;

  String main_type = "";
  String selectedFilter = 'all';

  late TextEditingController name;
  late TextEditingController chlorine;
  late TextEditingController liquid;
  late TextEditingController solid;
  late TextEditingController power;

  @override
  void onInit() {
    liquid = TextEditingController();
    solid = TextEditingController();
    power = TextEditingController();
    chlorine = TextEditingController();
    name = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose(); 
    chlorine.dispose();
    liquid.dispose();
    solid.dispose();
    power.dispose();

    // Do not dispose here to prevent issues with controllers in Edittech
    super.onClose();
  }

  // Filter function
  

  Future<void> addtech({required TechnologyModel tech}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      print("Error adding station: $e");
    }
  }
}

