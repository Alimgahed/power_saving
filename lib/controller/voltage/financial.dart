import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:get/get.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/global/iframe_platform.dart';
import 'package:power_saving/network/network.dart';

class FinancialController extends GetxController {
  RxBool loading = false.obs;

  String? waterChartHtml;

  @override
  void onInit() {
    super.onInit();
    financialAnalysis();
  }

  void financialAnalysis() async {
    try {
      loading.value = true;

      final res = await fetchData("${ApiConfig.baseUrl}/financial-analysis");
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        waterChartHtml = jsonData["water_chart"] as String?;

        // Register iframe view for web compilation dynamically
        if (waterChartHtml != null && kIsWeb) {
          registerIframe('sunburst-chart', waterChartHtml!);
        }

        loading.value = false;
        update();
      }
    } catch (e) {
      loading.value = false;
      debugPrint("Error fetching financial analysis: $e");
    }
  }
}
