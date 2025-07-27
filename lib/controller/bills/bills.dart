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
    late TextEditingController notes;

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
 // Text controllers
 

  // Observable values for real-time calculations
  var calculatedConsumption = 0.obs;
    var calculatedEnergyCost = 0.0.obs;

  var fixed = 0.0.obs;
  var calculatedSubtotal = 0.0.obs;
  var calculatedTotal = 0.0.obs;
  var isCalculating = false.obs;

  // Pricing tiers (you can modify these based on your pricing structure)


  @override
  void onInit() {
    super.onInit();
    settlementsControllerratio=TextEditingController();
    notes=TextEditingController();
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
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to changes in key fields to trigger auto-calculations
    briefReadingController.addListener(_calculateFields);
    currentReadingController.addListener(_calculateFields);
    readingFactorController.addListener(_calculateFields);
    fixedInstallmentController.addListener(_calculateFields);
    settlementsController.addListener(_calculateFields);
    settlementsControllerratio.addListener(_calculateFields);
    prevPaymentsController.addListener(_calculateFields);
  }

  void _calculateFields() {
    if (isCalculating.value) return;
    
    isCalculating.value = true;
    
    try {
      // Calculate consumption
      _calculateConsumption();
      
      // Calculate energy cost based on consumption
      // _calculateEnergyCost();
      
      // Calculate other automatic fields
      
      // Calculate final total
      _calculateTotal();
      
    } catch (e) {
      print('Calculation error: $e');
    } finally {
      isCalculating.value = false;
    }
  }

  void _calculateConsumption() {
    final prevReading = int.tryParse(briefReadingController.text) ?? 0;
    final currentReading = int.tryParse(currentReadingController.text) ?? 0;
    final factor = int.tryParse(readingFactorController.text) ?? 1;
    
    if (currentReading > prevReading) {
      final rawConsumption = currentReading - prevReading;
      calculatedConsumption.value = rawConsumption * factor;
      
      // Auto-fill the consumption field
      powerConsumpController.text = calculatedConsumption.value.toString();
    }
  }

  // void _calculateEnergyCost() {
  //   final consumption = calculatedConsumption.value;
  //   if (consumption <= 0) {
  //     calculatedEnergyCost.value = 0.0;
  //     return;
  //   }

  //   double totalCost = 0.0;
  //   int remainingConsumption = consumption;

  //   for (final tier in pricingTiers) {
  //     if (remainingConsumption <= 0) break;
      
  //     final tierConsumption = remainingConsumption > (tier.maxKwh - tier.minKwh + 1)
  //         ? (tier.maxKwh - tier.minKwh + 1).toInt()
  //         : remainingConsumption;
      
  //     totalCost += tierConsumption * tier.pricePerKwh;
  //     remainingConsumption -= tierConsumption;
      
  //     if (tier.maxKwh == double.infinity) break;
  //   }

  //   calculatedEnergyCost.value = totalCost;
  // }



  void _calculateTotal() {
        final consumption =double.tryParse( powerConsumpController.text)??0;

    final energyCost = calculatedEnergyCost.value;
    final fixedInstallment = double.tryParse(fixedInstallmentController.text) ?? 0.0;
    final settlements = double.tryParse(settlementsController.text) ?? 0.0;
    final stamp = double.tryParse(stampController.text) ?? 0.0;
    final rounding = double.tryParse(roundingController.text) ?? 0.0;
    final prevPayments = double.tryParse(prevPaymentsController.text) ?? 0.0;
    
    final total =
    ((consumption*calculatedEnergyCost.value)+fixed.value+
       fixedInstallment + settlements + stamp + rounding - prevPayments);
    
    calculatedTotal.value = total;
    billTotalController.text = total.toStringAsFixed(2);
  }

  // Method to auto-fill date fields with current month/year
  void autoFillCurrentDate() {
    final now = DateTime.now();
    billMonthController.text = now.month.toString();
    billyearController.text = now.year.toString();
  }

  // Method to get suggested values based on historical data
  void applySuggestedValues(String accountNumber) {
    // You can implement logic to get average values from historical bills
    // For now, providing reasonable defaults
    
    if (fixedInstallmentController.text.isEmpty) {
      fixedInstallmentController.text = "5.00"; // Default fixed installment
    }
    
    if (readingFactorController.text.isEmpty) {
      readingFactorController.text = "1"; // Default meter factor
    }
    
    autoFillCurrentDate();
  }

  @override
  void onClose() {
    // Remove listeners before disposing
    briefReadingController.removeListener(_calculateFields);
    currentReadingController.removeListener(_calculateFields);
    readingFactorController.removeListener(_calculateFields);
    fixedInstallmentController.removeListener(_calculateFields);
    settlementsController.removeListener(_calculateFields);
    settlementsControllerratio.removeListener(_calculateFields);
    prevPaymentsController.removeListener(_calculateFields);
    notes.dispose();
    // Dispose controllers
    briefReadingController.dispose();
    currentReadingController.dispose();
    readingFactorController.dispose();
    powerConsumpController.dispose();
    fixedInstallmentController.dispose();
    settlementsController.dispose();
    settlementsControllerratio.dispose();
    stampController.dispose();
    roundingController.dispose();
    prevPaymentsController.dispose();
    billMonthController.dispose();
    billyearController.dispose();
    billTotalController.dispose();
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
// Enhanced Bills Controller with auto-calculations


// Pricing tier model
class PricingTier {
  final double minKwh;
  final double maxKwh;
  final double pricePerKwh;

  PricingTier({
    required this.minKwh,
    required this.maxKwh,
    required this.pricePerKwh,
  });
}
