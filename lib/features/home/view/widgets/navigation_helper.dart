import 'package:power_saving/core/auth/session_manager.dart';
import 'package:get/get.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/my_widget/sharable.dart';

/// Navigation Helper
/// 
/// Handles navigation with authentication checks
class NavigationHelper {
  /// Navigate to a route with authentication check
  void navigateWithAuth(String route) {
    if (SessionManager.isAuthenticated) {
      Get.toNamed(route);
    } else {
      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
    }
  }

  /// Navigate to a route with arguments and authentication check
  void navigateWithAuthAndArgs(String route, dynamic arguments) {
    if (SessionManager.isAuthenticated) {
      Get.toNamed(route, arguments: arguments);
    } else {
      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
    }
  }

  /// Check if user has access based on group ID
  bool hasAccess(List<int> allowedGroups) {
    if (user == null) return false;
    return allowedGroups.contains(user!.groupId);
  }

  /// Check if user is authenticated
  bool get isAuthenticated => SessionManager.isAuthenticated;

  /// Get current user group ID
  int? get currentUserGroup => user?.groupId;
}