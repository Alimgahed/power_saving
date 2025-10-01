import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/shared_pref/cache.dart';

// A global function to fetch data with headers including the authorization token
Future<http.Response> fetchData(String url) async {
  // Get the token from the cache (replace Cache.getdata with your token fetching method)
  String? token = Cache.getdata(key: "token")??"";

  // If token is null or empty, handle the error or throw an exception


  // Create the headers for the request, including the token
  final headers = {
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token',
  };

  // Make the HTTP GET request with the headers
  final res = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  // Handle response, logging or parsing it as needed
  if (res.statusCode == 200) {
    // Successfully fetched data
    return res;
  } else {
    // Handle errors (e.g., 401 Unauthorized)
    throw Exception('Failed to load data. Status code: ${res.statusCode}');
  }
}


/// A global function to send POST requests with bearer token
Future<http.Response> postData(String url, Map<String, dynamic> body) async {
  // Get the token from cache
  String token = Cache.getdata(key: "token")??"";



  // Set headers with token
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  // Send POST request
  final res = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  // Optional: handle errors globally here
  if (res.statusCode >= 200 && res.statusCode < 300) {
    return res;
  } else {
       final errorBody = jsonDecode(res.body);
      final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
      showCustomErrorDialog(errorMessage: errorMessage);
    throw Exception('POST failed with status code: ${res.statusCode}\nBody: ${res.body}');
  }
}
