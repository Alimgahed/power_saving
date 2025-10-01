import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/chemacial.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Chemacialcontroller extends GetxController {
  List<AlumChlorineReference> chemicals = [];

  // TextEditingControllers for fields

  @override
  void onInit() {
    getchemicals();

    super.onInit();
  }

  void getchemicals() async {
    try {
      chemicals.clear();
      chemicals = []; // Clear the list before fetching new data
      final res = await fetchData(
        "http://$ip/chemicals"
      );
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          AlumChlorineReference chemical = AlumChlorineReference.fromJson(i);
          chemicals.add(chemical);
        }
        update();
      }
    } catch (e) {
      print("Error fetching chemicals: $e");
    }
  }
}

// ignore: camel_case_types
class addchemical extends GetxController {
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
      final res = await postData(
        "http://$ip/new-chemical",
        (reference.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم الاضافة  بنجاح");
        Get.offNamed('/Chemicals');
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      print("Error adding station: $e");
     
    }
  }

  Future<void> editchemicals({
    required AlumChlorineReference reference,
    required int id,
  }) async {
    try {
      final res = await postData(
        "http://$ip/edit-chemical/$id",
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
    } catch (e) {
      print("Error adding station: $e");
     
    }
  }

  void getchemicals() async {
    try {
      final res = await fetchData(
       "http://$ip/new-chemical"
      );
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        jsonData["water_sources"].forEach((source) {
          waterSourceList.add(WaterSource.fromJson(source));
        });
        jsonData["techs"].forEach((tech) {
          this.tech.add(TechnologyModel.fromJson(tech));
        });
        print(tech);
        print(waterSourceList);
        update(); // Notify listeners
        // for (var i in responseData) {
        //   AlumChlorineReference chemical = AlumChlorineReference.fromJson(i);
        //   chemicals.add(chemical);
        //   update();
        // }

        update(); // Notify listeners
      }
    } catch (e) {
      print("Error fetching chemicals: $e");
    }
  }
}
