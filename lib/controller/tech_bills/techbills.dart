import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/tech_bill.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Techbills extends GetxController {
  // ignore: unused_field
  final Map<int, GlobalKey<FormState>> formKeys = {};
  GlobalKey<FormState> getFormKey(int index) {
    return formKeys.putIfAbsent(index, () => GlobalKey<FormState>());
  }

  RxnInt loadingIndex = RxnInt(); // holds index of currently loading item
  List<TechnologyBill> techBills = [];
  // Create maps of TextEditingControllers per bill (by index)
  final chlorineControllers = <int, TextEditingController>{};
  final liquidAlumControllers = <int, TextEditingController>{};
  final solidAlumControllers = <int, TextEditingController>{};
  final waterProducedControllers = <int, TextEditingController>{};

  TextEditingController getChlorineController(int index) {
    return chlorineControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getLiquidAlumController(int index) {
    return liquidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getSolidAlumController(int index) {
    return solidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getWaterProducedController(int index) {
    return waterProducedControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  @override
  void onClose() {
    // Dispose all controllers when the controller is destroyed
    for (var controller in [
      ...chlorineControllers.values,
      ...liquidAlumControllers.values,
      ...solidAlumControllers.values,
      ...waterProducedControllers.values,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }

  @override
  void onInit() {
    fetchTechBills();
    super.onInit();
    // Initialize any data or state here if needed
  }

  // Example method to fetch tech bills data
  void fetchTechBills() async {
    try {
      final res = await http.get(
        Uri.parse("http://$ip/tech-bills"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;
        print(responseData);
        for (var i in responseData) {
          TechnologyBill technologyBill = TechnologyBill.fromJson(i);
          techBills.add(technologyBill);
        }
        update();

        // Debug prints
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  void addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index, // <-- Add this parameter
  }) async {
    try {
      loadingIndex.value = index; // mark current item as loading

      final res = await http.post(
        headers: {"Content-Type": "application/json"},
        Uri.parse("http://$ip/edit-tech-bill/$id"),
        body: json.encode({
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        }),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تمت الإضافة بنجاح");
      } else {
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      print("Error during bill submission: $e");
    } finally {
      loadingIndex.value = null; // reset after done
    }
  }
}
