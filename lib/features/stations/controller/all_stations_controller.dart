import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/network/network.dart';

class get_all_stations extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  List<Station> allstations = [];
  List<Station> filteredStations = [];
  Station? station;
  late TextEditingController searchController;

  @override
  void onInit() {
    searchController = TextEditingController();
    get_stations();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredStations.clear();
    }
    update();
  }

  void filterStations(String query) {
    if (query.isEmpty) {
      filteredStations.clear();
    } else {
      filteredStations = allstations.where((station) {
        String branchName = station.branchName?.toLowerCase() ?? '';
        String stationName = station.stationName.toLowerCase();
        return branchName.contains(query.toLowerCase()) || 
               stationName.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  // ignore: non_constant_identifier_names
  void get_stations() async {
    isLoading.value = true;
    allstations.clear();
    filteredStations.clear();
    
    try {
      final res = await fetchData(
        "http://$ip/stations",
      );
      
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          station = Station.fromJson(i);
          allstations.add(station!);
        }
        
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
      }
    } catch (e) {
      isLoading.value = false;
      update();
    }
  }
}