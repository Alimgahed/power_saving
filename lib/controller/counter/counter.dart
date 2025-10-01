import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

// ignore: camel_case_types
class Counter_controller extends GetxController {
  List<ElectricMeter> allcounter = [];
  List<ElectricMeter> filteredCounters = [];
  RxBool looading=false.obs;
  @override
  void onInit() {
    all_counter();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Search/Filter function
  void filterCounters(String query) {
    if (query.isEmpty) {
      filteredCounters.clear();
    } else {
      filteredCounters = allcounter.where((meter) {
        // Search by meter ID (meterId) or account number (accountNumber)
        final meterIdMatch = meter.meterId?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final accountNumberMatch = meter.accountNumber?.toLowerCase().contains(query.toLowerCase()) ?? false;
        
        return meterIdMatch || accountNumberMatch;
      }).toList();
    }
    update(); // Notify listeners to rebuild UI
  }

  // Clear search filter
  void clearFilter() {
    filteredCounters.clear();
    update(); // Notify listeners to rebuild UI
  }

  Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      final res = await postData(
        "http://$ip/new-station",
    (counter.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم اضافة العداد بنجاح");
        // Refresh the list after adding
        await all_counter();
      } else {
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    // ignore: empty_catches
    } catch (e) {
   
    }
  }

  Future<void> all_counter() async {
    try {
              looading.value=true;

      final res = await fetchData(
        "http://$ip/gauges"
      );

      if (res.statusCode == 200) {
        looading.value=false;
        final jsonData = json.decode(res.body);
        print(jsonData);
        List<dynamic> responseData = jsonData;

        // Clear existing data
        allcounter.clear();
        
        for (var i in responseData) {
          ElectricMeter meter = ElectricMeter.fromJson(i);
          allcounter.add(meter);
        }
        
        conters = allcounter; // Update the global list
        
        // Clear filtered results when refreshing data
        filteredCounters.clear();
        
        update();
      }
    // ignore: empty_catches
    } catch (e) {
                    looading.value=false;

    }
  }
}

// ignore: camel_case_types
class addcounter extends GetxController {
  RxBool looading = false.obs;
  List<VoltageType> allVoltage = [];
  int? voltage;

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
        "http://$ip/new-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة العداد بنجاح");
        // Refresh the main counter list
        Get.find<Counter_controller>().all_counter();
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
       "http://$ip/new-gauge",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        for (var i in jsonData) {
          VoltageType voltage = VoltageType.fromJson(i);
          allVoltage.add(voltage);
          update();
        }
      } else {
        print("Failed to add station: ${res.body}");
        Get.snackbar(
          "خطأ",
          "فشل في إضافة المحطة: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    // ignore: empty_catches
    } catch (e) {
      
    }
  }
}

class EditCounter extends GetxController {
  RxBool looadig = false.obs;
  List<VoltageType> allVoltage = [];
  int? voltage;

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
        "http://$ip/edit-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looadig.value = false;
        showSuccessToast("تم تعديل العداد بنجاح");
        // Refresh the main counter list
        Get.find<Counter_controller>().all_counter();
      } else {
        looadig.value = false;
        print("Failed to edit station: ${res.body}");
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
        "http://$ip/new-gauge",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        for (var i in jsonData) {
          VoltageType voltage = VoltageType.fromJson(i);
          allVoltage.add(voltage);
          update();
        }
      } else {
        print("Failed to load voltage types: ${res.body}");
        Get.snackbar(
          "خطأ",
          "فشل في تحميل أنواع الجهد: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      print("Error loading voltage types: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تحميل أنواع الجهد",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }
}