import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/predication.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Prediactioncontroller extends GetxController {
  PredictionModel? predictionModel;
  Future<void> prediactions(int stationId) async {
    try {
      final res = await fetchData("http://$ip/prediction/$stationId");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        predictionModel = PredictionModel.fromJson(jsonData);
        // Parse with the existing model

        update();

        // Debug prints
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }
}
