import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'package:power_saving/features/analysis/model/analysis.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/network/network.dart';

class Analysis extends GetxController {
  final _requests = RequestGuard();
  AnalysisModel? anl;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void onClose() {
    _requests.close();
    super.onClose();
  }

  Future<void> getAnalysis({required int station, required int tech}) async {
    final request = _requests.begin();
    if (!request.isCurrent) return;
    isLoading = true;
    errorMessage = '';
    anl = null;
    update();
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/analysis-single/$station/$tech",
        isCurrent: () => request.isCurrent,
      );
      if (!request.isCurrent) return;
      if (res.statusCode != 200) throw StateError('تعذر تحميل التحليل');
      anl = AnalysisModel.fromJson(json.decode(res.body));
    } catch (e) {
      if (!request.isCurrent) return;
      errorMessage = 'تعذر تحميل التحليل. يرجى إعادة المحاولة.';
    } finally {
      if (request.isCurrent) {
        isLoading = false;
        update();
      }
    }
  }
}
