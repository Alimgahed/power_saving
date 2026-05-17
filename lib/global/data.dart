import 'package:get/get.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';

/// Central Reactive Session State Manager
///
/// Replaces legacy mutable globals with a secure, lifecycle-aware GetX service
/// while providing reactive updates across views.
class SessionService extends GetxService {
  static SessionService get to => Get.find<SessionService>();

  final RxList<TechnologyModel> _technologies = <TechnologyModel>[].obs;
  final RxList<ElectricMeter> _counters = <ElectricMeter>[].obs;
  final Rxn<User> _user = Rxn<User>();

  List<TechnologyModel> get technologies => _technologies;
  set technologies(List<TechnologyModel> val) => _technologies.assignAll(val);

  List<ElectricMeter> get counters => _counters;
  set counters(List<ElectricMeter> val) => _counters.assignAll(val);

  User? get user => _user.value;
  set user(User? val) => _user.value = val;
}

// Backwards compatibility layer to keep all other workspace files fully functional
List<TechnologyModel> get technologies => SessionService.to.technologies;
set technologies(List<TechnologyModel> val) =>
    SessionService.to.technologies = val;

List<ElectricMeter> get conters => SessionService.to.counters;
set conters(List<ElectricMeter> val) => SessionService.to.counters = val;

User? get user => SessionService.to.user;
set user(User? val) => SessionService.to.user = val;
