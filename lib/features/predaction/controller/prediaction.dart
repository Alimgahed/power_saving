import 'package:power_saving/core/utils/request_guard.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/predaction/model/predication.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Prediactioncontroller extends GetxController {
  final _reads = RequestGuard();
  PredictionModel? predictionModel;
  var isLoading = false.obs;

  @override
  void onClose() {
    _reads.close();
    super.onClose();
  }

  Future<void> prediactions(int stationId) async {
    final request = _reads.begin();
    if (!request.isCurrent) return;
    try {
      isLoading.value = true;
      update();

      final res = await postData("${ApiConfig.baseUrl}/prediction/$stationId", {}, isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      final jsonData = json.decode(res.body);
      predictionModel = PredictionModel.fromJson(jsonData);
      
    } catch (e) {
      if (!request.isCurrent) return;
      if (e is ApiException) {
        if (e.statusCode != 401 && e.statusCode != 403) {
          showCustomErrorDialog(errorMessage: e.message);
        }
      } else {
        showCustomErrorDialog(errorMessage: "تعذر الاتصال بالخادم. الرجاء المحاولة لاحقاً.\nالخطأ: $e");
      }
    } finally {
      if (request.isCurrent) {
        isLoading.value = false;
        update();
      }
    }
  }
}
