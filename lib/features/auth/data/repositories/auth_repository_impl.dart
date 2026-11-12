import 'dart:convert';
import 'package:power_saving/core/network/api_client.dart';
import 'package:power_saving/core/repositories/base_repository.dart';
import 'package:power_saving/core/utils/result.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/core/auth/session_manager.dart';
import 'package:power_saving/core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';

/// Concrete implementation of AuthRepository
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Result<User>> login(String username, String password) async {
    final generation = SessionManager.beginLogin();
    final owner = SessionManager.session;
    bool current() => identical(owner, SessionManager.session) && owner.generation == generation;
    final result = await safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/login",
        {"username": username, "password": password},
        isCurrent: current,
      );
      if (!current()) throw StateError('Obsolete authentication response');
      dynamic jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        if (jsonResponse is! Map<String, dynamic>) throw const FormatException();
      } catch (_) {
        await SessionManager.clear(message: SessionManager.invalidMessage);
        throw const FormatException(SessionManager.invalidMessage);
      }
      final accepted = await SessionManager.establish(
          jsonResponse['current_user'], jsonResponse['token'], generation);
      if (!accepted) throw const FormatException(SessionManager.invalidMessage);
      return SessionManager.session.user!;
    }, isCurrent: current);
    if (result.isFailure && current()) {
      await SessionManager.clear(message: SessionManager.invalidMessage);
    }
    if (!current() && !SessionManager.isAuthenticated) {
      return Result.failure(Failure(SessionManager.invalidMessage));
    }
    return result;
  }

  @override
  Future<Result<bool>> changePassword(String currentPassword, String newPassword) async {
    final owner = SessionManager.session;
    final generation = owner.generation;
    bool current() => identical(owner, SessionManager.session) && owner.generation == generation;
    return safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/change-password",
        {
          "old_password": currentPassword,
          "new_password": newPassword,
        },
        isCurrent: current,
      );

      return response.statusCode == 200;
    }, isCurrent: current);
  }
}
