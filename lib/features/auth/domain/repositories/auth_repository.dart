import '../../../../core/utils/result.dart';
import '../../model/login.dart';

/// AuthRepository defining clean boundary interfaces for the User authentication actions
abstract class AuthRepository {
  /// Performs user login and returns mapped User model or Failure
  Future<Result<User>> login(String username, String password);

  /// Triggers user password update operations
  Future<Result<bool>> changePassword(String currentPassword, String newPassword);
}
