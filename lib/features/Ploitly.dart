import 'package:power_saving/core/widgets/request_error_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/voltage/financial.dart';
import 'package:power_saving/global/iframe_platform.dart';

// ignore: use_key_in_widget_constructors
class SunburstPage extends StatelessWidget {
  final FinancialController controller = Get.find<FinancialController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "نسبة توزيع انتاج المياة",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Get.offNamed('/home');
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<FinancialController>(
        builder: (c) {
          if (c.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.errorMessage.isNotEmpty) {
            return RequestErrorView(message: c.errorMessage, onRetry: c.financialAnalysis);
          }
          if (c.waterChartHtml == null || c.waterChartHtml!.isEmpty) {
            return RequestErrorView(message: 'لا توجد رسوم بيانية متاحة', onRetry: c.financialAnalysis);
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 20,
            width: double.infinity,
            child: buildIframeWidget(c.chartViewId),
          );
        },
      ),
    );
  }
}
