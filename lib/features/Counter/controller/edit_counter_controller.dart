import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class EditCounter extends GetxController {
  RxBool looadig = false.obs;
  List<VoltageType> allVoltage = [];
  int? voltage;

  // ignore: non_constant_identifier_names
  late TextEditingController Counter_number;
  late TextEditingController finalReading;
  late TextEditingController meterFactor;
  late TextEditingController meterId;
  late TextEditingController voltageType;

  @override
  void onInit() {
    allVoltige();
    Counter_number = TextEditingController();
    finalReading = TextEditingController();
    meterFactor = TextEditingController();
    meterId = TextEditingController();
    voltageType = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    Counter_number.dispose();
    meterId.dispose();
    meterFactor.dispose();
    finalReading.dispose();
    voltageType.dispose();
    super.onClose();
  }

  Future<void> editCounter({
    required ElectricMeter counter,
    required String serial,
  }) async {
    try {
      looadig.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looadig.value = false;
        showSuccessToast("تم تعديل العداد بنجاح");
        // Refresh the main counter list
        Get.find<CounterController>().fetchAllCounters();
      } else {
        looadig.value = false;
        Get.snackbar(
          "خطأ",
          "فشل في تعديل المحطة: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      looadig.value = false;
      
    }
  }

  Future<void> allVoltige() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-gauge",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        for (var i in jsonData) {
          VoltageType voltage = VoltageType.fromJson(i);
          allVoltage.add(voltage);
          update();
        }
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في تحميل أنواع الجهد: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تحميل أنواع الجهد",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }
}