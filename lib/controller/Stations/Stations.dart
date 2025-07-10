import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddStationController extends GetxController {
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

    // No need to dispose integers
    super.onClose();
  }

  Future<void> addStation({
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("http://172.16.144.197:5000/new-station"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
        }),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم اضافة المحطة بنجاح");
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

  Future<void> edit_Stations({
    required int Stations_id,
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("http://172.16.144.197:5000/edit-station/$Stations_id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
        }),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم تعديل المحطة بنجاح");
        Get.offNamed('/Stations');
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

  List<Branch> branchList = [];
  List<WaterSource> waterSourceList = [];

  Future<void> allBranches() async {
    try {
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/new-station"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        // Parse with the existing model
        final parsedData = AddStationData.fromJson(jsonData);

        // Assign to local lists
        branchList = parsedData.branches;
        waterSourceList = parsedData.waterSources;
        update();

        // Debug prints
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }
}

class get_all_stations extends GetxController {
  List<Station> allstations = [];
  Station? station;
  @override
  void onInit() {
    get_stations();
    super.onInit();
  }

  void get_stations() async {
    try {
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/stations"),
      );
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          station = Station.fromJson(i);
          allstations.add(station!);
        }
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
