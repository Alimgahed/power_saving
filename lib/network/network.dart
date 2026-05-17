import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_saving/shared_pref/cache.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => message;
}

Future<http.Response> fetchData(String url) async {
  String? token = Cache.getdata(key: "token") ?? "";
  final headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token',
  };
  final res = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (res.statusCode >= 200 && res.statusCode < 300) {
    return res;
  } else {
    String errorMessage = 'حدث خطأ غير متوقع أثناء تحميل البيانات';
    try {
      final errorBody = jsonDecode(res.body);
      errorMessage = errorBody['error'] ?? errorMessage;
    } catch (_) {}
    throw ApiException(statusCode: res.statusCode, message: errorMessage);
  }
}

Future<http.Response> postData(String url, Map<String, dynamic> body) async {
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
  if (res.statusCode >= 200 && res.statusCode < 300) {
    return res;
  } else {
    String errorMessage = 'حدث خطأ غير متوقع';
    try {
      final errorBody = jsonDecode(res.body);
      errorMessage = errorBody['error'] ?? errorMessage;
    } catch (_) {}
    throw ApiException(statusCode: res.statusCode, message: errorMessage);
  }
}

