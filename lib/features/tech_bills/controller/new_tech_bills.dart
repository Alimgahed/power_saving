import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';
import 'package:power_saving/global/ip_config.dart';

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
  late TextEditingController calculatedWaterController;
  late TextEditingController measuredWaterController;

  // Filter for new tech bills
  RxnString selectedBranch = RxnString();

  List<Station> get filteredStations {
    if (selectedBranch.value == null) {
      return stations.toList();
    }
    return stations
        .where((station) => station.branchName == selectedBranch.value)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    chlorineController = TextEditingController();
    liquidAlumController = TextEditingController();
    solidAlumController = TextEditingController();
    waterProducedController = TextEditingController();
    yearController = TextEditingController();
    monthController = TextEditingController();
    calculatedWaterController = TextEditingController();
    measuredWaterController = TextEditingController();
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
    loading.value = true;
    try {
      final res = await fetchData("${ApiConfig.baseUrl}/station-techs");
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        List<dynamic> data = [];

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('stations') && decoded['stations'] is List) {
            data = decoded['stations'] as List<dynamic>;
          } else if (decoded.containsKey('data') && decoded['data'] is List) {
            data = decoded['data'] as List<dynamic>;
          }
        }

        stations.value =
            data
                .whereType<Map<String, dynamic>>()
                .map((e) => Station.fromJson(e))
                .toList();

        if (selectedBranch.value != null &&
            !getBranches().contains(selectedBranch.value)) {
          selectedBranch.value = null;
          selectedStation = null;
          selectedTech = null;
        }
      } else {
        showCustomErrorDialog(
          errorMessage: 'فشل في جلب بيانات المحطات. حاول مرة أخرى.',
        );
      }
    } catch (e) {
      print('Error fetching station techs: $e');
      showCustomErrorDialog(
        errorMessage: 'حدث خطأ أثناء تحميل بيانات الفروع والمحطات.',
      );
    } finally {
      loading.value = false;
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
    required double measuredWater,
    required double calculatedWater,
  }) async {
    try {
      loading.value = true;

      final res =
          await postData("${ApiConfig.baseUrl}/insert-or-edit-tech-bill", {
            "technology_chlorine_consump": chlorine,
            "technology_liquid_alum_consump": liquid,
            "technology_solid_alum_consump": solid,
            "technology_water_amount": water,
            "measured_water": double.parse(measuredWaterController.text),
            "calculated_water": double.parse(calculatedWaterController.text),
            
            "station_id": selectedStation?.stationId,
            "technology_id": selectedTech?.technologyId,
            "bill_month": int.parse(monthController.text),
            "bill_year": int.parse(yearController.text),
          });

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
    } finally {}
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
    return stations.map((station) => station.branchName).toSet().toList()
      ..sort();
  }

  void filterByBranch(String? branch) {
    selectedBranch.value = branch;
    if (branch == null) return;

    if (selectedStation != null && selectedStation!.branchName != branch) {
      selectedStation = null;
      selectedTech = null;
    }
    update();
  }

  void clearFilters() {
    selectedBranch.value = null;
    selectedStation = null;
    selectedTech = null;
    update();
  }
}
