import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';

class BalanceChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BalanceChartController());
  }
}