import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_manager.dart';

class SessionMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (SessionManager.isAuthenticated) return null;
    SessionManager.clear(message: SessionManager.invalidMessage);
    return const RouteSettings(name: '/Login');
  }
}
