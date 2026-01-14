import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:ui_web' as ui_web; // platformViewRegistry
import 'package:get/get.dart';

import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/main.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/network/network.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  ConsumptionModel? consumptionModel;

  String? waterChartHtml;
  IFrameElement? iframeElement;
  bool iframeRegistered = false;

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

        // Delay iframe creation to avoid lifecycle warning
        if (waterChartHtml != null && kIsWeb) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _createIframe(waterChartHtml!);
            update();
          });
        }

        animateAll();
      }
    } catch (e) {
      print("❌ Error fetching home: $e");
    } finally {
      loading.value = false;
      update();
    }
  }

  void _createIframe(String htmlContent) {
    iframeElement = IFrameElement()
      ..style.width = '${width}px'
      ..style.height = '${height}px'
      ..style.border = 'none'
      ..srcdoc = htmlContent;

    if (!iframeRegistered) {
      ui_web.platformViewRegistry.registerViewFactory(
        'sunburst-chart',
        (int viewId) => iframeElement!,
      );
      iframeRegistered = true;
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
    const duration = Duration(milliseconds: 200);
    const interval = Duration(milliseconds: 5);

    final steps = duration.inMilliseconds ~/ interval.inMilliseconds;
    final stepValue = targetValue / steps;
    num current = 0;

    Timer.periodic(interval, (timer) {
      current += stepValue;
      if (current >= targetValue) {
        rxValue.value = targetValue;
        timer.cancel();
      } else {
        rxValue.value = current;
      }
    });
  }
}
