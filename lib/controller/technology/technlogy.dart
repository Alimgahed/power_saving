// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:http/http.dart' as http;

class TechnlogyController extends GetxController {
  List<TechnologyModel> all_technology = [];
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
    alltechnology();
    super.onInit();
  }

  @override
  void onClose() {
    // Do not dispose here to prevent issues with controllers in Edittech
    super.onClose();
  }

  Future<void> alltechnology() async {
    try {
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/technologies"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
          technologies = all_technology; // Update the global list
          update();
        }
      } else {
        print("Failed to fetch branches: ${res.body}");
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> addtech({required TechnologyModel tech}) async {
    try {
      final res = await http.post(
        Uri.parse("http://172.16.144.197:5000/new-tech"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم اضافة التقنية بنجاح");
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
}

class edit_tech extends GetxController {
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
      final res = await http.post(
        Uri.parse("http://172.16.144.197:5000/edit-tech/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم تعديل التقنية بنجاح");
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
}
