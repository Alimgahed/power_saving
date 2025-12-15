import 'dart:convert';

import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

// ignore: camel_case_types
class Counter_controller extends GetxController {
  List<ElectricMeter> allcounter = [];
  List<ElectricMeter> filteredCounters = [];
  RxBool looading=false.obs;
  @override
  void onInit() {
    all_counter();
    super.onInit();
  }

 
  // Search/Filter function
  void filterCounters(String query) {
  if (query.isEmpty) {
    filteredCounters.clear();
  } else {
    filteredCounters = allcounter.where((meter) {
      // Convert query to lowercase once for efficiency
      final lowerQuery = query.toLowerCase();

      // Search by meterId, accountNumber, or branch
      final meterIdMatch = meter.meterId.toLowerCase().contains(lowerQuery);
      final accountNumberMatch = meter.accountNumber?.toLowerCase().contains(lowerQuery) ?? false;
      final branchMatch = meter.branch?.toLowerCase().contains(lowerQuery) ?? false;

      return meterIdMatch || accountNumberMatch || branchMatch;
    }).toList();
  }
  update(); // Notify listeners to rebuild UI
}


  // Clear search filter
  void clearFilter() {
    filteredCounters.clear();
    update(); // Notify listeners to rebuild UI
  }

  Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      final res = await postData(
        "http://$ip/new-station",
    (counter.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم اضافة العداد بنجاح");
        // Refresh the list after adding
        await all_counter();
      } else {
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    // ignore: empty_catches
    } catch (e) {
   
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> all_counter() async {
    try {
              looading.value=true;

      final res = await fetchData(
        "http://$ip/gauges"
      );

      if (res.statusCode == 200) {
        looading.value=false;
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        // Clear existing data
        allcounter.clear();
        
        for (var i in responseData) {
          ElectricMeter meter = ElectricMeter.fromJson(i);
          allcounter.add(meter);
        }
        
        conters = allcounter; // Update the global list
        
        // Clear filtered results when refreshing data
        filteredCounters.clear();
        
        update();
      }
    // ignore: empty_catches
    } catch (e) {
                    looading.value=false;

    }
  }
}

