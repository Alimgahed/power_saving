// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class TechnlogyController extends GetxController {
  RxBool looading = false.obs;
  RxBool isLoading = false.obs;
  List<TechnologyModel> all_technology = [];
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
    alltechnology();
    super.onInit();
  }

  @override
  void onClose() {
    // Do not dispose here to prevent issues with controllers in Edittech
    super.onClose();
  }

  // Filter function
  void filterByType(String type) {
    selectedFilter = type;
    update();
  }

  // Get filtered technologies
  List<TechnologyModel> getFilteredTechnologies() {
    if (selectedFilter == 'all') {
      return all_technology;
    }
    return all_technology
        .where((tech) => tech.main_type == selectedFilter)
        .toList();
  }

  Future<void> alltechnology() async {
    isLoading.value = true;
    all_technology.clear(); // Clear old data
    
    try {
      final res = await fetchData(
        "http://$ip/technologies",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
          technologies = all_technology; // Update the global list
        }
        
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
        print("Failed to fetch technologies: ${res.body}");
      }
    } catch (e) {
      isLoading.value = false;
      update();
      print("Error fetching technologies: $e");
    }
  }

  Future<void> addtech({required TechnologyModel tech}) async {
    try {
      looading.value = true;
      final res = await postData(
        "http://$ip/new-tech",
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

class edit_tech extends GetxController {
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