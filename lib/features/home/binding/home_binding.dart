import 'package:get/get.dart';
import 'package:power_saving/features/home/controller/home.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
