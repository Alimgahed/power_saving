import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart' show fetchData, postData;

class addchemical extends GetxController {
  RxBool loading = false.obs;
  List<WaterSource> waterSourceList = [];
  List<TechnologyModel> tech = [];
  int? waterSourceId;
  int? technologyId;
  String? season;
  late TextEditingController chlorineFromController;
  late TextEditingController chlorineToController;
  late TextEditingController liquidAlumFromController;
  late TextEditingController liquidAlumToController;
  late TextEditingController solidAlumFromController;
  late TextEditingController solidAlumToController;

  @override
  void onInit() {
    super.onInit();
    getchemicals();
    // Initialize all controllers
    chlorineFromController = TextEditingController();
    chlorineToController = TextEditingController();
    liquidAlumFromController = TextEditingController();
    liquidAlumToController = TextEditingController();
    solidAlumFromController = TextEditingController();
    solidAlumToController = TextEditingController();
  }

  @override
  void onClose() {
    // Dispose of all controllers
    chlorineFromController.dispose();
    chlorineToController.dispose();
    liquidAlumFromController.dispose();
    liquidAlumToController.dispose();
    solidAlumFromController.dispose();
    solidAlumToController.dispose();

    super.onClose();
  }

  Future<void> addchemicals({required AlumChlorineReference reference}) async {
    try {
      loading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-chemical",
        (reference.toJson()),
      );

      if (res.statusCode == 200) {
        loading.value = false;
        showSuccessToast("تم الاضافة  بنجاح");
        Get.offNamed('/Chemicals');

      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
        loading.value = false;
      }
    // ignore: empty_catches
    } catch (e) {
      loading.value = false;
     
    }
  }

  Future<void> editchemicals({
    required AlumChlorineReference reference,
    required int id,
  }) async {
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-chemical/$id",
         (reference.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم التعديل  بنجاح");
        Get.offNamed('/Chemicals');
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    // ignore: empty_catches
    } catch (e) {
    
     
    }
  }

  void getchemicals() async {
    try {
      final res = await fetchData(
       "${ApiConfig.baseUrl}/new-chemical"
      );
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        jsonData["water_sources"].forEach((source) {
          waterSourceList.add(WaterSource.fromJson(source));
        });
        jsonData["techs"].forEach((tech) {
          this.tech.add(TechnologyModel.fromJson(tech));
        });
     
     

        update(); // Notify listeners
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }
}
