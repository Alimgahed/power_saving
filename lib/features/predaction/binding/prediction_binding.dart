import 'package:get/get.dart';
import 'package:power_saving/features/predaction/controller/prediaction.dart';
import 'package:power_saving/features/stations/controller/all_stations_controller.dart';

class PredictionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Prediactioncontroller());
    Get.put(StationsController());
  }
}