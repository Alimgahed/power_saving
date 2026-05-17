import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:power_saving/shared_pref/cache.dart';
import '../errors/exceptions.dart';

/// Production-grade HttpClient wrapper with automatic retries, timeouts, and safe error mapping
class ApiClient {
  final http.Client _client;
  static const int defaultTimeoutSeconds = 15;
  static const int maxRetryAttempts = 3;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Formulates default headers with Bearer token authentication dynamically fetched
  Map<String, String> _buildHeaders() {
    final String? token = Cache.getdata(key: "token");
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  /// Safe GET request with automatic retry policy
  Future<http.Response> get(
    String url, {
    int timeoutSeconds = defaultTimeoutSeconds,
  }) async {
    return _executeWithRetry(() async {
      final response = await _client
          .get(Uri.parse(url), headers: _buildHeaders())
          .timeout(Duration(seconds: timeoutSeconds));
      return _processResponse(response);
    });
  }

  /// Safe POST request with body serialization
  Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    int timeoutSeconds = defaultTimeoutSeconds,
  }) async {
    return _executeWithRetry(() async {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: _buildHeaders(),
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: timeoutSeconds));
      return _processResponse(response);
    });
  }

  /// Dynamic request wrapper implementing retry count policies
  Future<http.Response> _executeWithRetry(
    Future<http.Response> Function() action,
  ) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await action();
      } on SocketException catch (e) {
        if (attempts >= maxRetryAttempts) {
          throw NetworkException(
            'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصال الشبكة.',
            originalError: e,
          );
        }
      } on http.ClientException catch (e) {
        if (attempts >= maxRetryAttempts) {
          throw NetworkException(
            'فشل الاتصال بالخادم. يرجى المحاولة لاحقاً.',
            originalError: e,
          );
        }
      } catch (e) {
        if (e is AppException) rethrow;
        if (attempts >= maxRetryAttempts) {
          throw ServerException(
            'حدث خطأ غير متوقع أثناء معالجة الطلب.',
            originalError: e,
          );
        }
      }
      // Brief progressive delay before retrying
      await Future.delayed(Duration(milliseconds: attempts * 300));
    }
  }

  /// Analyzes responses and throws typed exception maps
  http.Response _processResponse(http.Response response) {
    final int code = response.statusCode;
    if (code >= 200 && code < 300) {
      return response;
    }

    String serverErrorMessage = ExceptionMapper.getLocalizedMessage(code);
    try {
      final body = jsonDecode(response.body);
      serverErrorMessage =
          body['error'] ?? body['message'] ?? serverErrorMessage;
    } catch (_) {}

    if (code == 401 || code == 403) {
      throw AuthenticationException(serverErrorMessage, statusCode: code);
    } else if (code == 422) {
      throw ValidationException(serverErrorMessage, statusCode: code);
    } else if (code >= 500) {
      throw ServerException(serverErrorMessage, statusCode: code);
    } else {
      throw ServerException(serverErrorMessage, statusCode: code);
    }
  }
}
