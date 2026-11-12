import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:get/get.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/global/iframe_platform.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:power_saving/network/network.dart';

class FinancialController extends GetxController {
  final _requests = RequestGuard();
  String errorMessage = '';

  @override
  void onClose() {
    _requests.close();
    super.onClose();
  }

  RxBool loading = false.obs;

  String? waterChartHtml;
  static int _nextChartId = 0;
  String chartViewId = 'sunburst-chart';

  @override
  void onInit() {
    super.onInit();
    financialAnalysis();
  }

  Future<void> financialAnalysis() async {
    final request = _requests.begin();
    if (!request.isCurrent) return;
    loading.value = true;
    errorMessage = '';
    waterChartHtml = null;
    update();
    try {

      final res = await fetchData("${ApiConfig.baseUrl}/financial-analysis",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (res.statusCode != 200) throw StateError('تعذر تحميل التحليل');
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        waterChartHtml = jsonData["water_chart"] as String?;

        // Register iframe view for web compilation dynamically
        if (waterChartHtml != null && kIsWeb) {
          chartViewId = 'sunburst-chart-${++_nextChartId}';
          registerIframe(chartViewId, waterChartHtml!);
        }

        loading.value = false;
        update();
      }
    } catch (e) {
      if (!request.isCurrent) return;
      errorMessage = 'تعذر تحميل التحليل. يرجى إعادة المحاولة.';
    } finally {
      if (request.isCurrent) {
        loading.value = false;
        update();
      }
    }
  }
}
