import 'dart:convert';
import 'package:power_saving/core/network/api_client.dart';
import 'package:power_saving/core/repositories/base_repository.dart';
import 'package:power_saving/core/utils/result.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/shared_pref/cache.dart';
import '../../domain/repositories/auth_repository.dart';

/// Concrete implementation of AuthRepository
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Result<User>> login(String username, String password) async {
    return safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/login",
        {
          "username": username,
          "password": password,
        },
      );

      final jsonResponse = jsonDecode(response.body);

      // Extract user info and token
      final userMap = jsonResponse['current_user'];
      final token = jsonResponse['token'];

      // Save to cache
      await Cache.saveData(key: "user", value: jsonEncode(userMap));
      await Cache.saveData(key: "token", value: token);

      return User.fromJson(userMap);
    });
  }

  @override
  Future<Result<bool>> changePassword(String currentPassword, String newPassword) async {
    return safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/change-password",
        {
          "old_password": currentPassword,
          "new_password": newPassword,
        },
      );

      return response.statusCode == 200;
    });
  }
}
