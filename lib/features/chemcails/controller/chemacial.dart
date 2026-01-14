import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/gloable/ip_config.dart';
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
        "${ApiConfig.baseUrl}/chemicals"
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
    // ignore: empty_catches
    } catch (e) {
    }
  }
}

// ignore: camel_case_types
