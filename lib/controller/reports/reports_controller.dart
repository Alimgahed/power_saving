import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/report.dart';
import 'package:power_saving/network/network.dart';

class ReportsController  extends GetxController{
  double watersum=0;
  double powersum=0;
  double moneysum=0;
 Future <void> sumvalueofreport() async{
for(var i in branchs){
  watersum=i.totalWater+watersum;
    powersum=i.totalPower+powersum;
  moneysum=i.totalBill+moneysum;
  update();
  print(powersum);

}
  }
  String? reportname;
  List<ReportBranch>   branchs=[];
    RxBool isLoading = false.obs;

late TextEditingController startdate;
  late TextEditingController enddate;
   @override
     void onInit() {
      startdate=TextEditingController();
      enddate=TextEditingController();
    super.onInit();
  }
 @override
  void onClose() {
    // Dispose of the controllers when the controller is closed
    startdate.dispose();
    enddate.dispose();

    super.onClose();
  }


   // ignore: non_constant_identifier_names
   Future<void> get_reports({
  required String start,
  required String end,
  required String name,
}) async {
  try {
    // Set loading to true BEFORE clearing data
    isLoading.value = true;
    update(); // Update UI to show loading state
    
    // Clear previous data
    branchs.clear();

    final res = await postData(
      "http://$ip/reports",
      {
        "report_name": name,
        "from_date": start,
        "to_date": end,
      },
    );

    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      
      // Handle different response formats
      List<dynamic> responseData;
      if (jsonData is List) {
        responseData = jsonData;
      } else if (jsonData is Map && jsonData.containsKey('data')) {
        responseData = jsonData['data'] ?? [];
      } else {
        responseData = [];
      }

      // Process the response data
      for (var i in responseData) {
        try {
          final branch = ReportBranch.fromJson(i);
          branchs.add(branch);
        } catch (e) {
          print("Error parsing branch data: $e");
          // Continue processing other items
        }
      }
      
      // Set loading to false and update UI
      isLoading.value = false;
      update();
      
    } else {
      // Handle error response
      isLoading.value = false;
      
      try {
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ في الخادم';
        _showErrorDialog(errorMessage);
      // ignore: empty_catches
      } catch (e) {
      }
      
      update();
    }
  } catch (e) {
    // Handle network or other errors
    isLoading.value = false;
    print("Error in get_reports: $e");
    
    _showErrorDialog('تأكد من الاتصال بالإنترنت وحاول مرة أخرى');
    update();
  }
}

// Helper method to show error dialog
void _showErrorDialog(String message) {
  // Implement your error dialog here
  // For example, using Get.dialog or similar
  Get.snackbar(
    'خطأ',
    message,
    backgroundColor: Colors.red.shade100,
    colorText: Colors.red.shade800,
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.all(16),
    borderRadius: 8,
  );
}

//
}