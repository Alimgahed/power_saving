import 'package:get/get.dart';
import 'package:power_saving/features/auth/model/login.dart';

/// Central Reactive Session State Manager
///
/// Replaces legacy mutable globals with a secure, lifecycle-aware GetX service
/// while providing reactive updates across views.
class SessionService extends GetxService {
  static SessionService get to => Get.find<SessionService>();

  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;
  set user(User? val) => _user.value = val;

  /// Completely wipe all in-memory session data
  int generation = 0;

  void clear() {
    generation++;
    _user.value = null;
  }
}

User? get user => SessionService.to.user;
set user(User? val) => SessionService.to.user = val;
