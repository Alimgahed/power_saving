import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/place/places_controller.dart';

class PlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlacesController());
  }
}
