import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/controller/chemacial.dart';

class ChemicalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Chemacialcontroller());
  }
}
