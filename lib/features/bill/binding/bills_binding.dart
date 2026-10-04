import 'package:get/get.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';

class BillsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllBills());
  }
}
