import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/vlotage.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Voltage extends GetxController {
  var isLoading = false.obs;
  List<VoltagePlan> vlotages = [];
  late TextEditingController lowcost;
  late TextEditingController lowfixed;

  late TextEditingController avaragecost;
  late TextEditingController avaargefixed;

  @override
  void onInit() {
    lowcost = TextEditingController();
    lowfixed = TextEditingController();
    avaargefixed = TextEditingController();
    avaragecost = TextEditingController();
    allVoltage();
    super.onInit();
  }

  @override
  void onClose() {
    lowcost.dispose();
    lowfixed.dispose();
    avaargefixed.dispose();
    avaragecost.dispose();

    super.onClose();
  }

  Future<void> allVoltage() async {
    try {
      vlotages = [];
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/voltage-costs"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          VoltagePlan vlotag = VoltagePlan.fromJson(i);
          vlotages.add(vlotag);
          update();
        }
        for (var i in vlotages) {
          if (i.voltageId == 2) {
            avaargefixed = TextEditingController(text: i.fixedFee.toString());
            avaragecost = TextEditingController(text: i.voltageCost.toString());
          } else {
            lowfixed = TextEditingController(text: i.fixedFee.toString());
            lowcost = TextEditingController(text: i.voltageCost.toString());
          }
        }

        // Debug prints
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> editVoltage({
    required VoltagePlan volt,
    required int voltid,
  }) async {
    try {
      final res = await http.post(
        headers: {"Content-Type": "application/json"},
        Uri.parse("http://172.16.144.197:5000/edit-v-cost/$voltid"),
        body: json.encode(volt.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم الحفظ بنجاح");
        // Debug prints
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }
}
