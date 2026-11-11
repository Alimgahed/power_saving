import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/place/edit_place_type_controller.dart';

class PlaceTypesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPlaceTypeController>(() => EditPlaceTypeController());
  }
}
