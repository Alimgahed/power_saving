import 'package:get/get.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';

class RelationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RelationsController());
  }
}
