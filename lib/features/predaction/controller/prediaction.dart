import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:power_saving/features/predaction/model/predication.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Prediactioncontroller extends GetxController {
  PredictionModel? predictionModel;
  Future<void> prediactions(int stationId) async {
    try {
      final res = await postData("${ApiConfig.baseUrl}/prediction/$stationId",{});

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        predictionModel = PredictionModel.fromJson(jsonData);

        update();

        // Debug prints
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';


        showCustomErrorDialog(errorMessage: errorMessage);
      }
    // ignore: empty_catches
    } catch (e) {
    
    }
  }
}
