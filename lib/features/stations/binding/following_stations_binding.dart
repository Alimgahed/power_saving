import 'package:get/get.dart';
import 'package:power_saving/features/stations/controller/following_stations_controller.dart';

class FollowingStationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FollowingStationsController());
  }
}