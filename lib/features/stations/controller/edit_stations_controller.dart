

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';
  RxBool looading = false.obs;
class EditStationsController extends GetxController {
    List<Branch> branchList = [];
  List<WaterSource> waterSourceList = [];
   RxBool looading = false.obs;
  late TextEditingController name;
  late TextEditingController capacity;

  int? branchId;
  int? sourceId;
  bool? stationStatusId;
  String? stationTypeId;
  int? areaId;

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
    Future<void> allBranches() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-station",
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
  Future<void> edit_Stations({
    // ignore: non_constant_identifier_names
    required int Stations_id,
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    int? areaId,
    required int capacity,
  }) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-station/$Stations_id",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId,
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

}



  


// ignore: camel_case_types

