import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/controller/new_tech_bills.dart';

class NewTechBillsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewTechBillsController());
  }
}