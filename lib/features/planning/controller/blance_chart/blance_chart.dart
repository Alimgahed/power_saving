import 'dart:convert';
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
  static List<dynamic>? areasCache;
  static List<dynamic>? valuesCache;
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
    isIncreasableArea.value = selected?.increasable ?? false;
    if (!isIncreasableArea.value) {
      incresableController.clear();
    }
  }
  Future<void> allareas({bool isBackground = false}) async {
    if (!isBackground && areasCache != null) {
      areas.clear();
      areas.addAll(areasCache!.map((json) => AreaOfService.fromJson(json)));
      areas.value = List.from(areas);
      update();
      _fetchLatestBackgroundAreas();
      return;
    }
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/all-areas");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        areasCache = jsonData;
        areas.clear();
        areas.addAll(jsonData.map((json) => AreaOfService.fromJson(json)));
        areas.value = List.from(areas);
        update();
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }
  
  Future<void> _fetchLatestBackgroundAreas() async {
    allareas(isBackground: true);
  }

  Future<void> allvalues({bool isBackground = false}) async {
    if (!isBackground && valuesCache != null) {
      allTypes.clear();
      textControllers.clear();
      for (var json in valuesCache!) {
        final type = PlaceType.fromJson(json);
        allTypes.add(type);
        textControllers[type.placeTypeId] = TextEditingController();
      }
      _fetchLatestBackgroundValues();
      return;
    }
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        valuesCache = jsonData;
        allTypes.clear();
        textControllers.clear();
        for (var json in jsonData) {
          final type = PlaceType.fromJson(json);
          allTypes.add(type);
          textControllers[type.placeTypeId] = TextEditingController();
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }
  
  Future<void> _fetchLatestBackgroundValues() async {
    allvalues(isBackground: true);
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
  isloading.value = true;
  final body = buildRequestBody();

  try {
    final response = await postData(
      "${ApiConfig.baseUrl}/balance-plot-calc/$id",
      body,
    );

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
    showCustomErrorDialog(errorMessage: e.toString());
    isloading.value = false;
    debugPrint("Error: $e");
  }
}





  @override
  void onClose() {
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
