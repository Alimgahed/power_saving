import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/network/network.dart';
import 'package:power_saving/gloable/ip_config.dart';


class Station {
  final int stationId;
  final String stationName;
  final String stationType;
  final int stationWaterCapacity;
  final String branchName;
  final String waterSourceName;
  final List<TechnologyModel> techs;

  Station({
    required this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    required this.branchName,
    required this.waterSourceName,
    required this.techs,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    var techsFromJson = json['techs'] as List<dynamic>? ?? [];
    List<TechnologyModel> techList =
        techsFromJson.map((e) => TechnologyModel.fromJson(e)).toList();

    return Station(
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      branchName: json['branch_name'],
      waterSourceName: json['water_source_name'],
      techs: techList,
    );
  }
}

class FollowingStationsController extends GetxController {
  RxList<Station> stations = <Station>[].obs;

  Station? selectedStation;
  TechnologyModel? selectedTech;

  // Filter for new tech bills
  RxnString selectedBranch = RxnString();

  @override
  void onInit() {
    super.onInit();
    stationsTechs();
  }

  Future<void> stationsTechs() async {
    final res = await fetchData("${ApiConfig.baseUrl}/station-techs");

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      stations.value = data.map((e) => Station.fromJson(e)).toList();
      update();
    }
  }

  void onStationChanged(Station? station) {
    selectedStation = station;
    selectedTech = null;

    print("Station: ${station?.stationName}");
    print("Techs count: ${station?.techs.length}");

    update();
  }

  void onTechChanged(TechnologyModel? tech) {
    selectedTech = tech;
    update();
  }

  /// Get list of all unique branches
  List<String> getBranches() {
    return stations
        .map((station) => station.branchName)
        .toSet()
        .toList()
      ..sort();
  }

  /// Filter by branch
  void filterByBranch(String? branch) {
    selectedBranch.value = branch;
    update();
  }

  /// Clear all filters
  void clearFilters() {
    selectedBranch.value = null;
    update();
  }
}
