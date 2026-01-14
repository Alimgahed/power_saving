// ignore: camel_case_types
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class addcounter extends GetxController {
  RxBool looading = false.obs;
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

  Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة العداد بنجاح");
        // Refresh the main counter list
        Get.find<CounterController>().fetchAllCounters();
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
     
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
      }
    // ignore: empty_catches
    } catch (e) {
      
    }
  }
}

