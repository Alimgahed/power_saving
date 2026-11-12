import 'package:power_saving/core/auth/session_manager.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
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
        drawer: SessionManager.isAuthenticated ? HomeDrawer() : null,
      appBar: const CustomAppBar(title: 'التحليل الاقتصادي', backRoute: '/home'),
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
