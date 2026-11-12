import 'package:power_saving/core/utils/request_guard.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class EditPlaceTypeController extends GetxController {
  final _lookupRequests0 = RequestGuard();
  final placeTypes = <PlaceType>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPlaceTypes();
  }

  @override
  void onClose() {
    _lookupRequests0.close();
    nameController.dispose();
    fromController.dispose();
    toController.dispose();
    super.onClose();
  }

  Future<void> fetchPlaceTypes({bool forceRefresh = false}) async {
    final request = _lookupRequests0.begin();
    if (!request.isCurrent) return;


    isLoading.value = true;
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types",
        isCurrent: () => request.isCurrent,
      );
      if (!request.isCurrent) return;
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        placeTypes.clear();
        for (var json in jsonData) {
          placeTypes.add(PlaceType.fromJson(json));
        }
      }
    } catch (e) {
      if (!request.isCurrent) return;
      showCustomErrorDialog(errorMessage: e.toString());
    } finally {
      if (request.isCurrent) isLoading.value = false;
    }
  }

  void prepareForEdit(PlaceType type) {
    nameController.text = type.placeTypeName;
    fromController.text = type.personPortionFrom.toString();
    toController.text = type.personPortionTo.toString();
  }

  Future<bool> updatePlaceType(int placeTypeId) async {
    isSubmitting.value = true;
    try {
      final body = {
        "place_type_name": nameController.text.trim(),
        "person_portion_from": int.tryParse(fromController.text.trim()) ?? 0,
        "person_portion_to": int.tryParse(toController.text.trim()) ?? 0,
      };

      final response = await postData(
        "${ApiConfig.baseUrl}/edit-place-type/$placeTypeId",
        body,
      );

      if (response.statusCode == 200) {



        // Refresh our local list
        await fetchPlaceTypes(forceRefresh: true);

        // If BalanceChartController is already registered in memory, refresh it
        if (Get.isRegistered<BalanceChartController>()) {
          Get.find<BalanceChartController>().allvalues(isBackground: false);
        }

        showSuccessToast("تم تعديل نوع المكان ونطاق الاستهلاك بنجاح");
        return true;
      } else {
        final resBody = jsonDecode(response.body);
        final msg = resBody["error"] ?? "فشل حفظ التعديلات";
        showCustomErrorDialog(errorMessage: msg);
        return false;
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
