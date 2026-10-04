import 'package:get/get.dart';
import 'package:power_saving/features/stations/controller/all_stations_controller.dart';

class StationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationsController());
  }
}
