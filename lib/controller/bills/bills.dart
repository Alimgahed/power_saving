import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/bills_model.dart';
import 'package:power_saving/model/relations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Bills extends GetxController {
  RxBool isLoading = false.obs;

  // Optional server-side values
  bool? showPercent;

  // Text controllers for user input (based on GuageBill model)
  late TextEditingController briefReadingController;
  late TextEditingController currentReadingController;
  late TextEditingController powerConsumpController;
  late TextEditingController readingFactorController;
  late TextEditingController voltageIdController;
  late TextEditingController voltageCostController;
  late TextEditingController fixedInstallmentController;
  late TextEditingController settlementsController;
    late TextEditingController settlementsControllerratio;

  late TextEditingController stampController;
  late TextEditingController prevPaymentsController;
  late TextEditingController roundingController;
  late TextEditingController billTotalController;
  late TextEditingController billMonthController;
  late TextEditingController billyearController;

  // List of TextEditingControllers for ratio fields
  List<TextEditingController> ratioControllers = [];
  List<double> ratios = [];
  List<StationGaugeTechnologyRelation> gauges = [];

  @override
  void onInit() {
    super.onInit();
settlementsControllerratio=TextEditingController();
    // Initialize controllers
    briefReadingController = TextEditingController();
    currentReadingController = TextEditingController();
    powerConsumpController = TextEditingController();
    readingFactorController = TextEditingController();
    voltageIdController = TextEditingController();
    voltageCostController = TextEditingController();
    billMonthController = TextEditingController();
    billyearController = TextEditingController();
    // Initialize other controllers
    fixedInstallmentController = TextEditingController();
    settlementsController = TextEditingController();
    stampController = TextEditingController();
    prevPaymentsController = TextEditingController();
    roundingController = TextEditingController();
    billTotalController = TextEditingController();

    // Initialize ratio controllers (for example, 3 ratios)
  }

  @override
  void onClose() {
    settlementsControllerratio.dispose();
    billMonthController.dispose();
    billyearController.dispose();
    briefReadingController.dispose();
    currentReadingController.dispose();
    powerConsumpController.dispose();
    readingFactorController.dispose();
    voltageIdController.dispose();
    voltageCostController.dispose();
    fixedInstallmentController.dispose();
    settlementsController.dispose();
    stampController.dispose();
    prevPaymentsController.dispose();
    roundingController.dispose();
    billTotalController.dispose();

    // Dispose ratio controllers

    super.onClose();
  }

  Future<void> newbill(String number) async {
    try {
      gauges = [];
      final res = await http.get(
        Uri.parse("http://$ip/new-bill/$number"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        // Parse gauge_sgt_list into List<StationGaugeTechnologyRelation>
        gauges =
            (jsonData['gauge_sgt_list'] as List)
                .map((item) => StationGaugeTechnologyRelation.fromJson(item))
                .toList();

        // Extract show_percent
        showPercent = jsonData['show_percent'];

        if (showPercent == true) {
          // Clear existing controllers and create new ones
          ratioControllers.clear();
          for (int i = 0; i < gauges.length; i++) {
            ratioControllers.add(TextEditingController());
          }
        }
        // Call update() to notify GetBuilder widgets
        update();

        print("Gauges updated: ${gauges.length}");
        print("Show percent: $showPercent");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> addnewbill({
    required String number,
    required GuageBill bill,
  }) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        headers: {"Content-Type": "application/json"},
        Uri.parse("http://$ip/new-bill/$number"),
        body: json.encode(bill.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم تسجيل الفاتورة بنجاح");
        isLoading.value = false;

        // Optional: clear or populate text fields here if needed
      } else {
        isLoading.value = false;

        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      isLoading.value = false;

      print("Error fetching data: $e");
    }
  }
}
