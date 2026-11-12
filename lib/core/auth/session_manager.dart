import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';

/// Authentication metadata only. Never stores API business data.
class SessionManager {
  static const publicRoutes = {'/Login', '/NewUser'};
  static const invalidMessage =
      'بيانات الجلسة غير صالحة. يرجى تسجيل الدخول مرة أخرى.';
  static final notice = RxnString();
  static Future<void>? _writes;
  static bool _redirecting = false;

  static SessionService get session => SessionService.to;
  static bool validGroup(dynamic value) =>
      value is int && value >= 1 && value <= 7;
  static bool validToken(dynamic value) =>
      value is String && value.trim().isNotEmpty;

  static User parseUser(dynamic raw) {
    if (raw is! Map<String, dynamic> || !validGroup(raw['group_id'])) {
      throw const FormatException(invalidMessage);
    }
    return User.fromJson(raw);
  }

  static bool get isAuthenticated {
    if (!Get.isRegistered<SessionService>()) return false;
    final current = session.user;
    if (current == null ||
        !validGroup(current.groupId) ||
        !validToken(Cache.getdata(key: 'token'))) {
      return false;
    }
    try {
      return jsonEncode(
            parseUser(_decode(Cache.getdata(key: 'user'))).toJson(),
          ) ==
          jsonEncode(current.toJson());
    } catch (_) {
      return false;
    }
  }

  static dynamic _decode(dynamic raw) {
    while (raw is String) {
      raw = jsonDecode(raw);
    }
    return raw;
  }

  static Future<void> _serialize(Future<void> Function() action) {
    final next = (_writes ?? Future<void>.value()).then((_) => action());
    final settled = next.catchError((_) {});
    _writes = settled;
    settled.then((_) {
      if (identical(_writes, settled)) _writes = null;
    });
    return next;
  }

  static Future<void> restore() async {
    final token = Cache.getdata(key: 'token');
    final raw = Cache.getdata(key: 'user');
    try {
      if (!validToken(token)) throw const FormatException(invalidMessage);
      session.user = parseUser(_decode(raw));
      notice.value = null;
    } catch (_) {
      await clear(
        message: token != null || raw != null ? invalidMessage : null,
      );
    }
  }

  static int beginLogin() {
    session.clear();
    notice.value = null;
    return session.generation;
  }

  static Future<bool> establish(
    dynamic raw,
    dynamic token,
    int generation,
  ) async {
    final owner = session;
    if (owner.generation != generation) return false;
    final User parsed;
    try {
      if (!validToken(token)) throw const FormatException(invalidMessage);
      parsed = parseUser(raw);
    } catch (_) {
      if (owner.generation == generation) await clear(message: invalidMessage);
      return false;
    }
    var accepted = false;
    try {
      await _serialize(() async {
        if (!identical(owner, session) || owner.generation != generation) {
          return;
        }
        final userSaved = await Cache.saveData(key: 'user', value: jsonEncode(parsed.toJson()));
        final tokenSaved = await Cache.saveData(key: 'token', value: token);
        if (!userSaved || !tokenSaved) {
          throw StateError('Authentication persistence failed');
        }
        if (!identical(owner, session) || owner.generation != generation) {
          return;
        }
        owner.user = parsed;
        accepted = true;
      });
    } catch (_) {
      if (identical(owner, session) && owner.generation == generation) {
        await clear(message: invalidMessage);
      }
      return false;
    }
    return accepted;
  }

  static Future<void> clear({String? message}) {
    if (Get.isRegistered<SessionService>()) session.clear();
    notice.value = message;
    return _serialize(() async {
      await Cache.sharedPreferences.remove('token');
      await Cache.sharedPreferences.remove('user');
    });
  }

  static Future<void> logout({String? message}) async {
    final clearing = clear(message: message);
    final generation =
        Get.isRegistered<SessionService>() ? session.generation : null;
    await clearing;
    if (!Get.isRegistered<SessionService>() || session.generation == generation) {
      toLogin();
    }
  }

  static void toLogin() {
    if (_redirecting || Get.currentRoute == '/Login') return;
    _redirecting = true;
    Get.offAllNamed('/Login');
    Future.microtask(() => _redirecting = false);
  }
}
