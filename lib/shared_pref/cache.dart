
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getdata({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value == null) {
      // Decide how you want to handle the case when value is null.
      // For example, you can choose to not save anything and return false.
      return false;
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else {
      throw ArgumentError('Unsupported data type: ${value.runtimeType}');
    }
  }
}
