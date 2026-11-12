import 'package:get/get.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';

/// Local response ownership only: does not cancel or change any wire request.
class RequestGuard {
  int _generation = 0;
  bool _closed = false;

  RequestTicket begin() {
    final generation = ++_generation;
    final token = Cache.getdata(key: 'token');
    final cachedUser = Cache.getdata(key: 'user');
    final session =
        Get.isRegistered<SessionService>() ? Get.find<SessionService>() : null;
    final user = session?.user;
    final sessionGeneration = session?.generation;
    return RequestTicket(
      () =>
          !_closed &&
          generation == _generation &&
          token == Cache.getdata(key: 'token') &&
          cachedUser == Cache.getdata(key: 'user') &&
          identical(
            session,
            Get.isRegistered<SessionService>()
                ? Get.find<SessionService>()
                : null,
          ) &&
          identical(user, session?.user) &&
          sessionGeneration == session?.generation,
    );
  }

  void invalidate() => _generation++;
  void close() {
    _closed = true;
    invalidate();
  }
}

class RequestTicket {
  final bool Function() _isCurrent;
  RequestTicket(this._isCurrent);
  bool get isCurrent => _isCurrent();
}
