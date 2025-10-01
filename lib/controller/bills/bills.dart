import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/bills_model.dart';
import 'package:power_saving/model/relations.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Bills extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPaid = true.obs;
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
  late TextEditingController delayYearController;
  late TextEditingController delayMonthController;

  // List of TextEditingControllers for ratio fields
  List<TextEditingController> powerControllers = [];
  List<TextEditingController> moneyControllers = [];
  List<double> ratios = [];
  List<StationGaugeTechnologyRelation> gauges = [];
  // Text controllers

  // Observable values for real-time calculations
  var calculatedConsumption = 0.0.obs;
  var calculatedEnergyCost = 0.0.obs;

  var fixed = 0.0.obs;
  var calculatedSubtotal = 0.0.obs;
  var calculatedTotal = 0.0.obs;
  var isCalculating = false.obs;

  // Pricing tiers (you can modify these based on your pricing structure)

  @override
  void onInit() {
    super.onInit();
    settlementsControllerratio = TextEditingController();
    notes = TextEditingController();
    delayMonthController = TextEditingController();
    delayYearController = TextEditingController();
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
    stampController.addListener(_calculateFields);
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
    final prevReading = double.tryParse(briefReadingController.text) ?? 0;
    final currentReading = double.tryParse(currentReadingController.text) ?? 0;
    final factor = double.tryParse(readingFactorController.text) ?? 1;

    // Validate input values
    if (prevReading < 0 || currentReading < 0) {
      print('Error: Meter readings cannot be negative');
      calculatedConsumption.value = 0;
      powerConsumpController.text = '0';
      return;
    }

    // Use generic reading difference calculation with rollover support
    final readingDiff = _calculateReadingDifference(
      prevReading,
      currentReading,
    );

    if (readingDiff > 0) {
      final rawConsumption = readingDiff;
      calculatedConsumption.value = rawConsumption * factor;

      // Auto-fill the consumption field
      powerConsumpController.text = calculatedConsumption.value.toString();

      print(
        'Final consumption: ${calculatedConsumption.value} kWh (with factor: $factor)',
      );
    } else {
      calculatedConsumption.value = 0;
      powerConsumpController.text = '0';
      print('No consumption calculated - check meter readings');
    }
  }

  // Generic method to calculate reading difference with rollover support
  double _calculateReadingDifference(double prevReading, double currentReading) {
    double readingDiff = currentReading - prevReading;

    if (readingDiff < 0) {
      final numDigits = prevReading.toString().length;
      final rolloverValue = pow(10, numDigits).toDouble();
      readingDiff += rolloverValue - 1;
      print('Meter rollover detected:');
      print('Previous reading: $prevReading (${numDigits} digits)');
      print('Current reading: $currentReading');
      print('Rollover value: $rolloverValue');
      print('Calculated consumption: $readingDiff');

      // Optional: Add reasonable consumption validation
      _validateConsumption(
        readingDiff,
        rolloverValue,
        prevReading,
        currentReading,
      );
    }

    return readingDiff;
  }

  // Generic validation method for consumption values
  void _validateConsumption(
    double consumption,
    double rolloverValue,
    double prevReading,
    double currentReading,
  ) {
    // Check if consumption seems unreasonably high (more than 80% of rollover value)
    if (consumption > rolloverValue * 0.8) {
      print('⚠️ Warning: Very high consumption detected ($consumption)');
      print('This might indicate incorrect meter readings. Please verify:');
      print('Previous reading: $prevReading');
      print('Current reading: $currentReading');
    }

    // Check if consumption is unreasonably low for rollover scenario
    if (consumption < 10) {
      print('ℹ️ Info: Very low consumption after rollover ($consumption)');
      print(
        'This might be normal for new connections or brief billing periods.',
      );
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
    final consumption = double.tryParse(powerConsumpController.text) ?? 0;

    final energyCost = calculatedEnergyCost.value;
    final fixedInstallment =
        double.tryParse(fixedInstallmentController.text) ?? 0.0;
    final settlements = double.tryParse(settlementsController.text) ?? 0.0;
    final stamp = double.tryParse(stampController.text) ?? 0.0;
    final rounding = double.tryParse(roundingController.text) ?? 0.0;
    final prevPayments = double.tryParse(prevPaymentsController.text) ?? 0.0;

    final total =
        ((consumption * calculatedEnergyCost.value) +
            fixed.value +
            fixedInstallment +
            settlements +
            stamp +
            rounding -
            prevPayments);

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
    delayMonthController.dispose();
    delayYearController.dispose();
    notes.dispose();

    super.onClose();
  }

  Future<void> newbill(String number) async {
    try {
      gauges = [];
      final accountNumber = Uri.encodeComponent(number);

      final res = await fetchData("http://$ip/new-bill/$accountNumber");

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
          powerControllers.clear();
          moneyControllers.clear();
          for (int i = 0; i < gauges.length; i++) {
            powerControllers.add(TextEditingController());
            moneyControllers.add(TextEditingController());
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
      final res = await postData(
        "http://$ip/new-bill/$number",
      (bill.toJson()),
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
