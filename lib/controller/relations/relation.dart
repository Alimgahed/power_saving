import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/model/tech_model.dart';

class Relation extends GetxController {
  List<TechnologyModel>technologylist=[];
  List<ElectricMeter>electricMeterList=[];
    List<Branch>stationlist=[];
    int?techid;
    String?counterid;
    int?stationid;


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

      // Parse with the existing model
      print(jsonData);
      // Assign to local lists
   
      update();

      // Debug prints
 

    }
  } catch (e) {
    print("Error fetching branches: $e");
  }
}
  Future<void> addRelations() async {
  try {
     final res = await http.post(
      Uri.parse("http://172.16.144.197:5000/new-relation"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
       
      }
      )
    );
    
    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);

      // Parse with the existing model
      print(jsonData);
      // Assign to local lists
   
      update();

      // Debug prints
 

    }
  } catch (e) {
    print("Error fetching branches: $e");
  }
}
}