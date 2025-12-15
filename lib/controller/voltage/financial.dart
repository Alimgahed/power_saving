import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:ui_web' as ui_web; // platformViewRegistry
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/main.dart';
import 'package:power_saving/network/network.dart';

class FinancialController extends GetxController {
  RxBool loading = false.obs;

  String? waterChartHtml;
  IFrameElement? iframeElement;
  bool iframeRegistered = false;

 
  @override
  void onInit() {
    super.onInit();
    financialAnalysis();
  }

  void financialAnalysis() async {
    try {
      loading.value = true;

      final res = await fetchData("http://$ip/financial-analysis");
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        waterChartHtml = jsonData["water_chart"] as String?;

        // Delay iframe creation to avoid lifecycle warning
        if (waterChartHtml != null && kIsWeb) {
          Future.delayed(Duration(milliseconds: 100), () {
            _createIframe(waterChartHtml!);
            update();
          });
        }

        loading.value = false;
        update();
      }
    } catch (e) {
      loading.value = false;
      print("Error fetching home: $e");
    }
  }

  void _createIframe(String htmlContent) {
    iframeElement = IFrameElement()
      ..style.width = '${width}px' // increased width
      ..style.height = '${height}px' // increased height
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

 
}
