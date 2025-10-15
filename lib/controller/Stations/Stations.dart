import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class AddStationController extends GetxController {
  RxBool looading = false.obs;
  late TextEditingController name;
  late TextEditingController capacity;

  int? branchId;
  int? sourceId;
  bool? stationStatusId;
  String? stationTypeId;

  @override
  void onInit() {
    name = TextEditingController();
    capacity = TextEditingController();

    branchId = null;
    sourceId = null;
    stationStatusId = null;
    stationTypeId = null;

    allBranches();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    capacity.dispose();
    super.onClose();
  }

  Future<void> addStation({
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "http://$ip/new-station",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة المحطة بنجاح");
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

  // ignore: non_constant_identifier_names
  Future<void> edit_Stations({
    // ignore: non_constant_identifier_names
    required int Stations_id,
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
  }) async {
    try {
      looading.value = true;
      final res = await postData(
        "http://$ip/edit-station/$Stations_id",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم تعديل المحطة بنجاح");
        Get.offAllNamed('/Stations');
      } else {
        final errorBody = jsonDecode(res.body);
        looading.value = false;
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
    }
  }

  List<Branch> branchList = [];
  List<WaterSource> waterSourceList = [];

  Future<void> allBranches() async {
    try {
      final res = await fetchData(
        "http://$ip/new-station",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final parsedData = AddStationData.fromJson(jsonData);
        branchList = parsedData.branches;
        waterSourceList = parsedData.waterSources;
        update();
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }
}

// ignore: camel_case_types
class get_all_stations extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  List<Station> allstations = [];
  List<Station> filteredStations = [];
  Station? station;
  late TextEditingController searchController;

  @override
  void onInit() {
    searchController = TextEditingController();
    get_stations();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredStations.clear();
    }
    update();
  }

  void filterStations(String query) {
    if (query.isEmpty) {
      filteredStations.clear();
    } else {
      filteredStations = allstations.where((station) {
        String branchName = station.branchName?.toLowerCase() ?? '';
        return branchName.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  // ignore: non_constant_identifier_names
  void get_stations() async {
    isLoading.value = true;
    allstations.clear();
    filteredStations.clear();
    
    try {
      final res = await fetchData(
        "http://$ip/stations",
      );
      
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          station = Station.fromJson(i);
          allstations.add(station!);
        }
        
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
      }
    } catch (e) {
      isLoading.value = false;
      update();
    }
  }
}