import 'package:power_saving/features/stations/model/station_model.dart';

class WaterData {
  final int year;
  final double waterNeed;
  final num population;
  final num qDemandedMonthlyMin;
  final num qDemandedMonthlyAvg;
  final num qDemandedMonthlyMax;
  final num qDemandedDailyMin;
  final num qDemandedDailyAvg;
  final num qDemandedDailyMax;
  final num qDemandedHourly;
  final num qFire;
  final num currentProduction;
  final num maxProduction;
  
  // New area-related fields
  final int? areaId;
  final String? areaName;
  final int? branchId;
  final String? branchName;
  final int? placeId;
  final String? placeName;
  final int? placeTypeId;
  final String? placeTypeName;

  WaterData({
    required this.year,
    required this.waterNeed,
    required this.population,
    required this.qDemandedMonthlyMin,
    required this.qDemandedMonthlyAvg,
    required this.qDemandedMonthlyMax,
    required this.qDemandedDailyMin,
    required this.qDemandedDailyAvg,
    required this.qDemandedDailyMax,
    required this.qDemandedHourly,
    required this.qFire,
    required this.currentProduction,
    required this.maxProduction,
    this.areaId,
    this.areaName,
    this.branchId,
    this.branchName,
    this.placeId,
    this.placeName,
    this.placeTypeId,
    this.placeTypeName,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      year: json['year'],
      waterNeed: json['water_need'],
      population: json['population'],
      qDemandedMonthlyMin: json['Q_demanded_monthly_min'],
      qDemandedMonthlyAvg: json['Q_demanded_monthly_avg'],
      qDemandedMonthlyMax: json['Q_demanded_monthly_max'],
      qDemandedDailyMin: json['Q_demanded_daily_min'],
      qDemandedDailyAvg: json['Q_demanded_daily_avg'],
      qDemandedDailyMax: json['Q_demanded_daily_max'],
      qDemandedHourly: json['Q_demanded_hourly'],
      qFire: json['Q_fire'],
      currentProduction: json['current_production'],
      maxProduction: json['max_production'],
      areaId: json['area_id'],
      areaName: json['area_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
    );
  }

  static List<WaterData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => WaterData.fromJson(json)).toList();
  }
}

class WaterDataResponse {
  final List<WaterData> balncedata; 
  final String chart;
  final AreaData? areaData; // New field for area information

  WaterDataResponse({
    required this.balncedata,
    required this.chart,
    this.areaData,
  });

  factory WaterDataResponse.fromJson(Map<String, dynamic> json) {
    return WaterDataResponse(
      balncedata: WaterData.fromJsonList(json['table']),
      chart: json['chart'],
      areaData: json['area_data'] != null 
          ? AreaData.fromJson(json['area_data']) 
          : null,
    );
  }
}

// New AreaData model
class AreaData {
  final int areaId;
  final String areaName;
  final List<Place> places;
  final List<Station>? stations; // Optional populations list

  AreaData({
    required this.areaId,
    required this.areaName,
    required this.stations,
    required this.places,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      areaId: json['area_id'],
      areaName: json['area_name'],
      stations: json['stations'] != null
          ? (json['stations'] as List)
              .map((station) => Station.fromJson(station))
              .toList()
          : null,
      places: (json['places'] as List)
          .map((place) => Place.fromJson(place))
          .toList(),
    );
  }
}

class Place {
  final int areaId;
  final String areaName;
  final int branchId;
  final String branchName;
  final int placeId;
  final String placeName;
  final int placeTypeId;
  final String placeTypeName;
  final List<Population> populations;

  Place({
    required this.areaId,
    required this.areaName,
    required this.branchId,
    required this.branchName,
    required this.placeId,
    required this.placeName,
    required this.placeTypeId,
    required this.placeTypeName,
    required this.populations,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      areaId: json['area_id'],
      areaName: json['area_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
      populations: (json['populations'] as List)
          .map((pop) => Population.fromJson(pop))
          .toList(),
    );
  }
}

class Population {
  final int placeId;
  final String placeName;
  final int population;
  final int populationYear;

  Population({
    required this.placeId,
    required this.placeName,
    required this.population,
    required this.populationYear,
  });

  factory Population.fromJson(Map<String, dynamic> json) {
    return Population(
      placeId: json['place_id'],
      placeName: json['place_name'],
      population: json['population'],
      populationYear: json['population_year'],
    );
  }
}