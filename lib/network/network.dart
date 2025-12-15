import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/shared_pref/cache.dart';
Future<http.Response> fetchData(String url) async {
  String? token = Cache.getdata(key: "token")??"";
  final headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token',
  };
  final res = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (res.statusCode == 200) {
    return res;
  } else {
    throw Exception('Failed to load data. Status code: ${res.statusCode}');
  }
}
Future<http.Response> postData(String url, Map<String, dynamic> body) async {
  String token = Cache.getdata(key: "token")??"";
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
       final errorBody = jsonDecode(res.body);
      final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
      showCustomErrorDialog(errorMessage: errorMessage);
    throw Exception('POST failed with status code: ${res.statusCode}\nBody: ${res.body}');
  }
}
