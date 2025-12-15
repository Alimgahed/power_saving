import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Techbills extends GetxController {
  // Add this method to your Techbills controller class


  RxBool looading = false.obs;
  final Map<int, GlobalKey<FormState>> formKeys = {};
  
  GlobalKey<FormState> getFormKey(int index) {
    return formKeys.putIfAbsent(index, () => GlobalKey<FormState>());
  }

  RxnInt loadingIndex = RxnInt();
  List<TechnologyBill> techBills = [];
  
  // Filter properties
  RxnString selectedBranch = RxnString();
  RxnString selectedStation = RxnString();
  RxList<TechnologyBill> filteredTechBills = <TechnologyBill>[].obs;
  
  // Lists for filter dropdowns
  List<String> get branches {
    return techBills
        .map((bill) => bill.branch ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }
  
  List<String> get stations {
    return techBills
        .map((bill) => bill.stationName)
        .toSet()
        .toList()
      ..sort();
  }

  // Create maps of TextEditingControllers per bill (by index)
  final chlorineControllers = <int, TextEditingController>{};
  final liquidAlumControllers = <int, TextEditingController>{};
  final solidAlumControllers = <int, TextEditingController>{};
  final waterProducedControllers = <int, TextEditingController>{};

  TextEditingController getChlorineController(int index) {
    return chlorineControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getLiquidAlumController(int index) {
    return liquidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getSolidAlumController(int index) {
    return solidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getWaterProducedController(int index) {
    return waterProducedControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  @override
  void onClose() {
    // Dispose all controllers when the controller is destroyed
    for (var controller in [
      ...chlorineControllers.values,
      ...liquidAlumControllers.values,
      ...solidAlumControllers.values,
      ...waterProducedControllers.values,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }

  @override
  void onInit() {
    fetchTechBills();
    super.onInit();
  }

  // Filter methods
  void filterByBranch(String? branch) {
    selectedBranch.value = branch;
    applyFilters();
  }

  void filterByStation(String? station) {
    selectedStation.value = station;
    applyFilters();
  }

  void clearFilters() {
    selectedBranch.value = null;
    selectedStation.value = null;
    applyFilters();
  }

  void applyFilters() {
    filteredTechBills.value = techBills.where((bill) {
      bool matchesBranch = selectedBranch.value == null ||
          bill.branch == selectedBranch.value;
      bool matchesStation = selectedStation.value == null ||
          bill.stationName == selectedStation.value;
      return matchesBranch && matchesStation;
    }).toList();
  }

  // Example method to fetch tech bills data
  void fetchTechBills() async {
    try {
      looading.value = true;
      techBills.clear();
      final res = await fetchData("http://$ip/tech-bills");

      if (res.statusCode == 200) {
        looading.value = false;
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;
        for (var i in responseData) {
          TechnologyBill technologyBill = TechnologyBill.fromJson(i);
          techBills.add(technologyBill);
        }
        applyFilters(); // Apply filters after fetching data
        update();
      }
    } catch (e) {
      looading.value = false;
      print("Error fetching tech bills: $e");
    }
  }

  void addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index,
  }) async {
    try {
      looading.value = true;
      loadingIndex.value = index;

      final res = await postData(
        "http://$ip/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        fetchTechBills();
        showSuccessToast("تمت الإضافة بنجاح");

        /// ✅ Clear input fields after successful submission
        getChlorineController(index).clear();
        getLiquidAlumController(index).clear();
        getSolidAlumController(index).clear();
        getWaterProducedController(index).clear();
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      print("Error during bill submission: $e");
    } finally {
      loadingIndex.value = null;
    }
  }
}
