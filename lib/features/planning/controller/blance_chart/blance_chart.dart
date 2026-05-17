import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/features/planning/model/area_model.dart';
import 'package:power_saving/features/planning/model/blance_model.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/network/network.dart';

class BalanceChartController extends GetxController {
  var isloading = false.obs;
  int areaid=0;
  bool edited = true;
  TextEditingController incresableController = TextEditingController();
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
   Future<void> allareas() async {
    try {

      final response = await fetchData("${ApiConfig.baseUrl}/all-areas");
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        // Clear and populate master list
        areas.clear();
        areas.addAll(
          jsonData.map((json) => AreaOfService.fromJson(json))
        );
        
        // Update display list
       areas.value = List.from(areas);
       update();
        
      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحميل البيانات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("Error fetching places: $e");
    }
  }

  Future<void> allvalues() async {
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        allTypes.clear();
        textControllers.clear();

        for (var json in jsonData) {
          final type = PlaceType.fromJson(json);
          allTypes.add(type);

          /// create controller per place type
          textControllers[type.placeTypeId] = TextEditingController();
        }

      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحميل البيانات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
    Map<String, dynamic> buildRequestBody() {
    final Map<String, dynamic> body = {
      "calc_type": selectedMethod.value,
      "is_modified": edited,
      "increasable": int.tryParse(incresableController.text) ?? 0,
      "goal_year": int.tryParse(yearController.text) ?? 0,
    };

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
      
      // Validate and store data
      if (responseJson['table'] is List) {
        balanceData.value = WaterDataResponse.fromJson(responseJson);
        
        isloading.value = false;
        
      
        
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.to(
            () =>  BalanceChartPrintScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 100),
          );
        });
        
      } 
    } else {
      isloading.value = false;
      Get.snackbar(
        'خطأ',
        'فشل حفظ البيانات: ${response.statusCode}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  } catch (e) {
    isloading.value = false;
    Get.snackbar(
      'خطأ',
      'حدث خطأ أثناء الإرسال',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
    );
    debugPrint("Error: $e");
  }
}





  @override
  void onClose() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
