import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class EditTechbillsController extends GetxController {
    RxBool looading = false.obs;

  late TextEditingController chlorineController;
  late TextEditingController liquidAlumController;
  late TextEditingController solidAlumController;
  late TextEditingController waterProducedController;

  @override
  void onInit() {
    chlorineController = TextEditingController();
    liquidAlumController = TextEditingController();
    solidAlumController = TextEditingController();
    waterProducedController = TextEditingController();
    super.onInit();
  }
  
  @override
  void onClose() {
    chlorineController.dispose();
    liquidAlumController.dispose();
    solidAlumController.dispose();
    waterProducedController.dispose();
    super.onClose();
  }
  void editTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
  }) async {
    try {
      looading.value = true;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم التعديل بنجاح");

       
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      print("Error during bill submission: $e");
    } 
  }
}