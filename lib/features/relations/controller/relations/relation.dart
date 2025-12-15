import 'dart:convert';

import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/relations/model/relations.dart';

import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Relation extends GetxController {
  List<StationGaugeTechnologyRelation> allrelations = [];
  RxBool isLoading = false.obs;
  int? techid;
  String? counterid;
  int? stationid;

  @override
  void onInit() {
    all_relations();
    super.onInit();
  }

  @override
  void onClose() {
    // No need to dispose integers
    super.onClose();
  }

  // ignore: non_constant_identifier_names
  Future<void> all_relations() async {
    try {
      final res = await fetchData(
        ("http://$ip/stg-relations"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          StationGaugeTechnologyRelation relation =
              StationGaugeTechnologyRelation.fromJson(i);
          allrelations.add(relation);
          update();
          // Assign to local lists
        }

        // Debug prints
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<void> editRelation(int id, String text) async {
    try {
      isLoading.value = true; // Start loading
      final res = await fetchData(
        "http://$ip/edit-relation/$id",
      );

      if (res.statusCode == 200) {
        isLoading.value = false;
        Get.offAllNamed("/Relations"); // Force a fresh load
        showSuccessToast(text);
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading
    }
  }
}

