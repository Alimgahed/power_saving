import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class EditTechController extends GetxController {
  final _requests = RequestGuard();
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
    _requests.close();
    name.dispose();
    chlorine.dispose();
    liquid.dispose();
    solid.dispose();
    power.dispose();
    super.onClose();
  }

  Future<void> edittech({
    required TechnologyModel tech,
    required int id,
  }) async {
    final request = _requests.begin();
    if (!request.isCurrent) return;
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech/$id",
        (tech.toJson()), // ✅ Proper JSON encoding
        isCurrent: () => request.isCurrent,
      );

      if (!request.isCurrent) return;
      if (res.statusCode == 200) {
        looading.value = false;

        showSuccessToast("تم تعديل التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage =
            errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      if (!request.isCurrent) return;
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
    }
  }
}
