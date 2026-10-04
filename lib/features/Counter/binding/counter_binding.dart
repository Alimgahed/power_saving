import 'package:get/get.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';

class CounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CounterController());
  }
}
