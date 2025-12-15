import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';
class EditTechController extends GetxController {
  RxBool looading = false.obs;
  String? main_type;
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
    // Do not dispose here to prevent issues with controllers in Edittech
    super.onClose();
  }

  Future<void> edittech({
    required TechnologyModel tech,
    required int id,
  }) async {
    try {
      looading.value = true;
      final res = await postData(
        "http://$ip/edit-tech/$id",
        (tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم تعديل التقنية بنجاح");
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
    }
  }
}