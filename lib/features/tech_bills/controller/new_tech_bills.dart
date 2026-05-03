import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';
import 'package:power_saving/gloable/ip_config.dart';

class Station {
  final int stationId;
  final String stationName;
  final String stationType;
  final int stationWaterCapacity;
  final String branchName;
  final String waterSourceName;
  final List<TechnologyModel> techs;

  Station({
    required this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    required this.branchName,
    required this.waterSourceName,
    required this.techs,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    var techsFromJson = json['techs'] as List<dynamic>? ?? [];
    List<TechnologyModel> techList =
        techsFromJson.map((e) => TechnologyModel.fromJson(e)).toList();

    return Station(
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      branchName: json['branch_name'],
      waterSourceName: json['water_source_name'],
      techs: techList,
    );
  }
}

class NewTechBillsController extends GetxController {
  RxList<Station> stations = <Station>[].obs;
  Station? selectedStation;
  TechnologyModel? selectedTech;
  var loading = false.obs;
  
  late TextEditingController chlorineController;
  late TextEditingController liquidAlumController;
  late TextEditingController solidAlumController;
  late TextEditingController waterProducedController;
  late TextEditingController yearController;
  late TextEditingController monthController;

  // Filter for new tech bills
  RxnString selectedBranch = RxnString();

  @override
  void onInit() {
    super.onInit();
    chlorineController = TextEditingController();
    liquidAlumController = TextEditingController();
    solidAlumController = TextEditingController();
    waterProducedController = TextEditingController();
    yearController = TextEditingController();
    monthController = TextEditingController();
    stationsTechs();
  }

  @override
  void onClose() {
    chlorineController.dispose();
    liquidAlumController.dispose();
    solidAlumController.dispose();
    waterProducedController.dispose();
    yearController.dispose();
    monthController.dispose();
    super.onClose();
  }

  Future<void> stationsTechs() async {
    final res = await fetchData("${ApiConfig.baseUrl}/station-techs");

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      stations.value = data.map((e) => Station.fromJson(e)).toList();
      update();
    }
  }

 void addTechBills({
    required int staionid,
    required int techid,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index,
  }) async {
    try {
      loading.value = true;

      final res = await postData(
        "${ApiConfig.baseUrl}/insert-or-edit-tech-bill",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
          "station_id": selectedStation?.stationId,
          "technology_id": selectedTech?.technologyId,
          "bill_month": int.parse(monthController.text),
          "bill_year": int.parse(yearController.text),
        },
      );

      if (res.statusCode == 200) {
        loading.value = false;
        showSuccessToast("تمت الإضافة بنجاح");

        // Clear input fields after successful submission
    
      } else {
        loading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      loading.value = false;
      print("Error during bill submission: $e");
    } finally {
    }
  }

  void onStationChanged(Station? station) {
    selectedStation = station;
    selectedTech = null;
    update();
  }

  void onTechChanged(TechnologyModel? tech) {
    selectedTech = tech;
    update();
  }

  List<String> getBranches() {
    return stations
        .map((station) => station.branchName)
        .toSet()
        .toList()
      ..sort();
  }

  void filterByBranch(String? branch) {
    selectedBranch.value = branch;
    update();
  }

  void clearFilters() {
    selectedBranch.value = null;
    update();
  }
}