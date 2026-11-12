import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:power_saving/core/auth/session_manager.dart';
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => message;
}

Future<http.Response> fetchData(String url, {bool Function()? isCurrent}) async {
  final sessionRequest = RequestGuard().begin();
  String? token = Cache.getdata(key: "token") ?? "";
  final headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token',
  };
  final res = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (!sessionRequest.isCurrent) throw ApiException(statusCode: 0, message: 'Obsolete session response');
  if (res.statusCode >= 200 && res.statusCode < 300) {
    return res;
  } else if (res.statusCode == 401 || res.statusCode == 403) {
    // A superseded caller must not invalidate a newer session or navigate.
    if (isCurrent == null || isCurrent()) {
      await SessionManager.logout(message: SessionManager.invalidMessage);
    }
    throw ApiException(statusCode: res.statusCode, message: 'انتهت صلاحية الجلسة');
  } else {
    String errorMessage = 'حدث خطأ غير متوقع أثناء تحميل البيانات';
    try {
      final errorBody = jsonDecode(res.body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
    } catch (_) {}
    throw ApiException(statusCode: res.statusCode, message: errorMessage);
  }
}

Future<http.Response> postData(String url, Map<String, dynamic> body, {bool Function()? isCurrent}) async {
  final sessionRequest = RequestGuard().begin();
  String token = Cache.getdata(key: "token") ?? "";
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
  final res = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  if (!sessionRequest.isCurrent) throw ApiException(statusCode: 0, message: 'Obsolete session response');
  if (res.statusCode >= 200 && res.statusCode < 300) {
    return res;
  } else if (res.statusCode == 401 || res.statusCode == 403) {
    // A superseded caller must not invalidate a newer session or navigate.
    if (isCurrent == null || isCurrent()) {
      await SessionManager.logout(message: SessionManager.invalidMessage);
    }
    throw ApiException(statusCode: res.statusCode, message: 'انتهت صلاحية الجلسة');
  } else {
    String errorMessage = 'حدث خطأ غير متوقع';
    try {
      final errorBody = jsonDecode(res.body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
    } catch (_) {}
    throw ApiException(statusCode: res.statusCode, message: errorMessage);
  }
}

