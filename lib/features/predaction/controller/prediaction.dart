import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/predaction/model/predication.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Prediactioncontroller extends GetxController {
  PredictionModel? predictionModel;
  var isLoading = false.obs;

  Future<void> prediactions(int stationId) async {
    try {
      isLoading.value = true;
      update();

      final res = await postData("${ApiConfig.baseUrl}/prediction/$stationId", {});
      final jsonData = json.decode(res.body);
      predictionModel = PredictionModel.fromJson(jsonData);
      
    } catch (e) {
      if (e is ApiException) {
        showCustomErrorDialog(errorMessage: e.message);
      } else {
        showCustomErrorDialog(errorMessage: "تعذر الاتصال بالخادم. الرجاء المحاولة لاحقاً.\nالخطأ: $e");
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
