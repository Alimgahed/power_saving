// ignore: camel_case_types
import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/features/relations/model/relations.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class addrelationcontroller extends GetxController {
  RxBool looading=false.obs;
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
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-relation",
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

      } 
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<void> addRelations(StationGaugeTechnologyRelation relation) async {
    try {
            looading.value=true;

      final res = await postData(
        "${ApiConfig.baseUrl}/new-relation",
        (relation.toJson()),
      );

      if (res.statusCode == 200) {
              looading.value=false;

        showSuccessToast('تمت الاضافة بنجاح');
        // Parse with the existing model
        // Assign to local lists

        // Debug prints
      } else {
                      looading.value=false;

        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
                    looading.value=false;

      print("Error fetching branches: $e");
    }
  }
}
