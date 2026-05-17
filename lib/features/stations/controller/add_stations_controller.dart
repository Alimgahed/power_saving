import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/global/ip_config.dart';
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

  Future<void> addStation({
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
     int? areaId,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/new-station",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId
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
  List<Branch> branchList = [];
  List<WaterSource> waterSourceList = [];

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
  }