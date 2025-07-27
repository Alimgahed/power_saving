import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

// ignore: camel_case_types
class Counter_controller extends GetxController {
  List<ElectricMeter> allcounter = [];
  // ignore: non_constant_identifier_names

  @override
  void onInit() {
    all_counter();
    super.onInit();
  }

  @override
  void onClose() {
    // No need to dispose integers
    super.onClose();
  }

  Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      final res = await http.post(
        Uri.parse("http://$ip/new-station"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(counter.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم اضافة العداد بنجاح");
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      print("Error adding station: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإضافة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }

  Future<void> all_counter() async {
    try {
      final res = await http.get(
        Uri.parse("http://$ip/gauges"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        print(jsonData);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          ElectricMeter meter = ElectricMeter.fromJson(i);
          allcounter.add(meter);
          conters = allcounter; // Update the global list
          update();
        }
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }
}

// ignore: camel_case_types
class addcounter extends GetxController {
  RxBool looading=false.obs;
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

    // No need to dispose integers
    super.onClose();
  }

  Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      looading.value=true;
      final res = await http.post(
        Uri.parse("http://$ip/new-gauge"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(counter.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value=false;
        showSuccessToast("تم اضافة العداد بنجاح");
      } else {
        looading.value=false;
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value=false;
      print("Error adding station: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإضافة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }

  Future<void> allVoltige() async {
    try {
      final res = await http.get(
        Uri.parse("http://$ip/new-gauge"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body); // returns a String

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
    } catch (e) {
      print("Error adding station: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإضافة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }
}

class EditCounter extends GetxController {
  RxBool looadig=false.obs;
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

    // No need to dispose integers
    super.onClose();
  }

  Future<void> editCounter({
    required ElectricMeter counter,
    required String serial,
  }) async {
    try {
      looadig.value=true;
      final res = await http.post(
        Uri.parse("http://$ip/edit-gauge/$serial"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(counter.toJson()),
      );

      if (res.statusCode == 200) {
        looadig.value=false;
        showSuccessToast("تم تعديل العداد بنجاح");
      } else {
         looadig.value=false;
        print("Failed to add station: ${res.body}");
        Get.snackbar(
          "خطأ",
          "فشل في إضافة المحطة: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
       looadig.value=false;
      print("Error adding station: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإضافة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }

  Future<void> allVoltige() async {
    try {
      final res = await http.get(
        Uri.parse("http://$ip/new-gauge"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body); // returns a String

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
    } catch (e) {
      print("Error adding station: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإضافة",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }
}
