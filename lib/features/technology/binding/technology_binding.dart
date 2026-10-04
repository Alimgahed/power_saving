import 'package:get/get.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';

class TechnologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TechnlogyController());
  }
}
