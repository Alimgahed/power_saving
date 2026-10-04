import 'package:get/get.dart';
import 'package:power_saving/controller/voltage/financial.dart';

class ChartsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinancialController());
  }
}