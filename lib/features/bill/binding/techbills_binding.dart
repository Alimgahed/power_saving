import 'package:get/get.dart';
import 'package:power_saving/features/bill/controller/tech_bills.dart';

class TechBillsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TechBillscontroller());
  }
}