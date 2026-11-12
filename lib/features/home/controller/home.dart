import 'package:power_saving/core/utils/request_guard.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:get/get.dart';

import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class HomeController extends GetxController {
  final _reads = RequestGuard();
  RxBool loading = false.obs;
  ConsumptionModel? consumptionModel;



  // Animated values
  RxnNum animatedMoney = RxnNum();
  RxnNum animatedWater = RxnNum();
  RxnNum animatedPower = RxnNum();
  RxnNum animatedChlorine = RxnNum();
  RxnNum animatedLiquidAlum = RxnNum();
  RxnNum animatedSolidAlum = RxnNum();
  RxnNum saintion = RxnNum();

  @override
  void onInit() {
    super.onInit();
    home();
  }

  @override
  void onClose() {
    _reads.close();
    super.onClose();
  }

  Future<void> home() async {
    final request = _reads.begin();
    if (!request.isCurrent) return;
    try {
      loading.value = true;

      // ✅ Use new ApiConfig
      final res = await fetchData(ApiConfig.baseUrl, isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);

        consumptionModel = ConsumptionModel.fromJson(jsonData);


        animateAll();
      }
    } catch (e) {
      if (!request.isCurrent) return;
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint("❌ Error fetching home: $e");
    } finally {
      if (request.isCurrent) {
        loading.value = false;
        update();
      }
    }
  }

  void animateAll() {
    if (consumptionModel == null) return;

    animateValue(animatedMoney, consumptionModel!.money ?? 0);
    animateValue(animatedWater, consumptionModel!.water ?? 0);
    animateValue(animatedPower, consumptionModel!.power ?? 0);
    animateValue(animatedChlorine, consumptionModel!.chlorine ?? 0);
    animateValue(animatedLiquidAlum, consumptionModel!.liquidAlum ?? 0);
    animateValue(animatedSolidAlum, consumptionModel!.solidAlum ?? 0);
    animateValue(saintion, consumptionModel!.sanitaion ?? 0);
  }

  void animateValue(RxnNum rxValue, num targetValue) {
    rxValue.value = targetValue;
  }
}
