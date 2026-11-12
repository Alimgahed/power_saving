import 'dart:convert';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/features/planning/model/area_model.dart';
import 'package:power_saving/features/planning/model/blance_model.dart';
import 'package:power_saving/features/planning/model/ml_forecast_model.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/ml_forecast_result_screen.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class FutureCapacityEntry {
  final TextEditingController yearController;
  final TextEditingController productionController;

  FutureCapacityEntry({
    TextEditingController? yearController,
    TextEditingController? productionController,
  })  : yearController = yearController ?? TextEditingController(),
        productionController = productionController ?? TextEditingController();

  void dispose() {
    yearController.dispose();
    productionController.dispose();
  }
}

class BalanceChartController extends GetxController {
  final _areaRequests = RequestGuard();
  final _typeRequests = RequestGuard();
  final _submitRequests = RequestGuard();
  AreaOfService? selectedArea;

  void _applyAreas(List<AreaOfService> updated) {
    selectedArea = updated.firstWhereOrNull((a) => a.areaId == areaid)
        ?? selectedArea;
    areas.assignAll(updated);
    update();
  }

  void _applyTypes(List<PlaceType> updated) {
    // Retain removed drafts until this form closes, so a temporarily absent
    // reference can return without losing input. Only allTypes is submitted.
    for (final type in updated) {
      textControllers.putIfAbsent(type.placeTypeId, () => TextEditingController());
    }
    allTypes.assignAll(updated);
  }


  var isloading = false.obs;
  int areaid = 0;
  final isIncreasableArea = false.obs;
  bool edited = true;
  TextEditingController incresableController = TextEditingController();

  /// 🔮 الوضع الحالي مقابل الوضع المستقبلي
  final isFuture = false.obs;
  final futureCapacities = <FutureCapacityEntry>[].obs;
  var balanceData = Rxn<WaterDataResponse>();
  final areas = <AreaOfService>[].obs; 
  /// 🔽 Calculation method
  var selectedMethod = 'machine_learning'.obs;
  final TextEditingController yearController = TextEditingController();

  /// 📋 Place types list
  RxList<PlaceType> allTypes = <PlaceType>[].obs;

  /// 🧮 Controllers for each row
  final Map<int, TextEditingController> textControllers = {};

  @override
  void onInit() {
    super.onInit();
    allareas();
    allvalues();
  }

  /// 🔄 Method change
  void onMethodChanged(String? value) {
    if (value != null) {
      selectedMethod.value = value;
    }
  }

  /// 🔮 الوضع المستقبلي
  void toggleIsFuture(bool value) {
    isFuture.value = value;
    if (value && futureCapacities.isEmpty) {
      addFutureCapacityRow();
    }
  }

  void addFutureCapacityRow() {
    futureCapacities.add(FutureCapacityEntry());
  }

  void removeFutureCapacityRow(int index) {
    if (index >= 0 && index < futureCapacities.length) {
      final item = futureCapacities.removeAt(index);
      item.dispose();
    }
  }

  /// 🔄 Area selection change
  void onAreaChanged(int? newAreaId) {
    if (newAreaId == null) return;
    areaid = newAreaId;
    final selected = areas.firstWhereOrNull((a) => a.areaId == newAreaId);
    selectedArea = selected;
    isIncreasableArea.value = selected?.increasable ?? false;
    if (!isIncreasableArea.value) {
      incresableController.clear();
    }
  }
  Future<void> allareas({bool isBackground = false}) async {
    final request = _areaRequests.begin();
    if (!request.isCurrent) return;

    try {
      final response = await fetchData("${ApiConfig.baseUrl}/all-areas",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        final updated = jsonData.map((json) => AreaOfService.fromJson(json)).toList();

        _applyAreas(updated);
      }
    } catch (e) {
      if (request.isCurrent && !isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }

  Future<void> allvalues({bool isBackground = false}) async {
    final request = _typeRequests.begin();
    if (!request.isCurrent) return;

    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final updated = jsonData.map((json) => PlaceType.fromJson(json)).toList();

        _applyTypes(updated);
      }
    } catch (e) {
      if (request.isCurrent && !isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }

    Map<String, dynamic> buildRequestBody() {
    final Map<String, dynamic> body = {
      "calc_type": selectedMethod.value,
      "is_modified": edited,
      "increasable": int.tryParse(incresableController.text) ?? 0,
      "goal_year": int.tryParse(yearController.text) ?? 0,
      "is_future": isFuture.value,
    };

    if (isFuture.value) {
      final List<Map<String, dynamic>> futureList = [];
      for (var item in futureCapacities) {
        final y = int.tryParse(item.yearController.text.trim());
        final p = num.tryParse(item.productionController.text.trim());
        if (y != null && p != null) {
          futureList.add({
            "future_year": y,
            "future_production": p,
          });
        }
      }
      body["future_years_capacity"] = futureList;
    }

    for (var type in allTypes) {
      final value = textControllers[type.placeTypeId]?.text;
      if (value != null && value.isNotEmpty) {
        body[type.placeTypeId.toString()] = int.parse(value);
      }
    }

    return body;
  }
Future<void> submitData(int id) async {
  final request = _submitRequests.begin();
  if (!request.isCurrent) return;
  isloading.value = true;
  final body = buildRequestBody();

  try {
    final response = await postData(
      "${ApiConfig.baseUrl}/balance-plot-calc/$id",
      body,
      isCurrent: () => request.isCurrent,
    );
    if (!request.isCurrent) return;

    if (response.statusCode == 200) {
      // Parse response
      final responseJson = jsonDecode(response.body);

      // If Machine Learning response
      if (responseJson['best_model'] != null) {
        final mlResponse = MLForecastResponse.fromJson(responseJson);
        isloading.value = false;
        Get.to(
          () => MLForecastResultScreen(result: mlResponse),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 100),
        );
      } else if (responseJson['table'] is List) {
        // Validate and store equation/ministry data
        balanceData.value = WaterDataResponse.fromJson(responseJson);

        isloading.value = false;

        Future.delayed(const Duration(milliseconds: 100), () {
          if (!request.isCurrent) return;
          Get.to(
            () => BalanceChartPrintScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 100),
          );
        });
      } else {
        isloading.value = false;
        showCustomErrorDialog(errorMessage: "تنسيق البيانات المستلمة غير متوقع");
      }
    } else {
      isloading.value = false;
    }
  } catch (e) {
    if (!request.isCurrent) return;
    showCustomErrorDialog(errorMessage: e.toString());
    isloading.value = false;
    debugPrint("Error: $e");
  }
}





  @override
  void onClose() {
    _areaRequests.close();
    _typeRequests.close();
    _submitRequests.close();
    incresableController.dispose();
    yearController.dispose();
    for (var item in futureCapacities) {
      item.dispose();
    }
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
