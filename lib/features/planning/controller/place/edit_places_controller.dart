import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/features/planning/model/area_model.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class EditPlacesController extends GetxController {
  RxBool looading = false.obs;
  late TextEditingController name;
    List<Branch> branchList = [];
  List<AreaOfService> areaList = [];
    List<PlaceType> placeTypeList = [];


  int? branchId;
  int? areaId;
  int? placeTypeId;

  @override
  void onInit() {
    name = TextEditingController();

    branchId = null;
    areaId = null;
    placeTypeId = null;

    allNewData();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    super.onClose();
  }

  Future<void> editplace({
required   Place  place,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "http://$ip/edit-place/${place.placeId}",
          (place.toJson()),
       
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم تعديل المكان بنجاح");
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


  Future<void> allNewData() async {
    try {
      final res = await fetchData(
        "http://$ip/new-place",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        branchList = (jsonData['branches'] as List)
            .map((branch) => Branch.fromJson(branch))
            .toList();
             areaList = (jsonData['areas'] as List)
            .map((area) => AreaOfService.fromJson(area))
            .toList();
             placeTypeList = (jsonData['place_types'] as List)
            .map((placeType) => PlaceType.fromJson(placeType))
            .toList();
update();
      

      }
    // ignore: empty_catches
    } catch (e) {
    }
  }
  }