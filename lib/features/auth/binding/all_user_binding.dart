import 'package:get/get.dart';
import 'package:power_saving/features/auth/controller/all_user.dart';

class AllUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllUserController());
  }
}