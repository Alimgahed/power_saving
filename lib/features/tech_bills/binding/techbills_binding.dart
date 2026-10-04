import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';

class TechbillsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Techbills());
  }
}