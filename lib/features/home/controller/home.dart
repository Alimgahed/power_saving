import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:get/get.dart';

import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/global/iframe_platform.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/network/network.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  ConsumptionModel? consumptionModel;

  String? waterChartHtml;

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

  Future<void> home() async {
    try {
      loading.value = true;

      // ✅ Use new ApiConfig
      final res = await fetchData(ApiConfig.baseUrl);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);

        consumptionModel = ConsumptionModel.fromJson(jsonData);
        waterChartHtml = jsonData["water_chart"] as String?;

        // Register dynamic iframe view for web compilation
        if (waterChartHtml != null && kIsWeb) {
          Future.delayed(const Duration(milliseconds: 100), () {
            registerIframe('sunburst-chart', waterChartHtml!);
            update();
          });
        }

        animateAll();
      }
    } catch (e) {
      debugPrint("❌ Error fetching home: $e");
    } finally {
      loading.value = false;
      update();
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
