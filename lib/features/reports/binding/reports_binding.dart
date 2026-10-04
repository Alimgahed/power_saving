import 'package:get/get.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReportsController());
  }
}