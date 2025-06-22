import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/model/relations.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

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
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/stg-relations"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        print(jsonData);
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
    } catch (e) {
      print("Error fetching branches: $e");
    }
  }

  Future<void> editRelation(int id, String text) async {
    try {
      isLoading.value = true; // Start loading
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/edit-relation/$id"),
        headers: {"Content-Type": "application/json"},
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
      print("Error fetching branches: $e");
    }
  }
}

// ignore: camel_case_types
class addrelationcontroller extends GetxController {
  List<TechnologyModel> technologylist = [];
  List<ElectricMeter> electricMeterList = [];
  List<allstations> stationlist = [];
  int? techid;
  String? counterid;
  int? stationid;

  @override
  void onInit() {
    new_relations();
    super.onInit();
  }

  @override
  void onClose() {
    // No need to dispose integers
    super.onClose();
  }

  Future<void> new_relations() async {
    try {
      final res = await http.get(
        Uri.parse("http://172.16.144.197:5000/new-relation"),
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        if (jsonData['gauges'] != null) {
          for (var gauge in jsonData['gauges']) {
            electricMeterList.add(ElectricMeter.fromJson(gauge));
          }
        }

        // Parse stations into Branch list
        if (jsonData['stations'] != null) {
          for (var station in jsonData['stations']) {
            stationlist.add(allstations.fromJson(station));
          }
        }

        // Parse techs into TechnologyModel list
        if (jsonData['techs'] != null) {
          for (var tech in jsonData['techs']) {
            technologylist.add(TechnologyModel.fromJson(tech));
          }
        }

        update(); // Assuming you're using GetX or similar for state management

        print("Electric Meters: $electricMeterList");
        print("Stations: $stationlist");
        print("Technologies: $technologylist");
      } else {
        print("Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> addRelations(StationGaugeTechnologyRelation relation) async {
    try {
      final res = await http.post(
        Uri.parse("http://172.16.144.197:5000/new-relation"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(relation.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast('تمت الاضافة بنجاح');
        // Parse with the existing model
        // Assign to local lists

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
