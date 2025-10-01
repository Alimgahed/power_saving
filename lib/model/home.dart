
class OverWaterStation {
  final int capacityLimit;
  final int month;
  final String stationName;
  final double totalWater;
  final int waterCapacity;
  final int year;

  OverWaterStation({
    required this.capacityLimit,
    required this.month,
    required this.stationName,
    required this.totalWater,
    required this.waterCapacity,
    required this.year,
  });

  factory OverWaterStation.fromJson(Map<String, dynamic> json) {
    return OverWaterStation(
      capacityLimit: json['capacity_limit'],
      month: json['month'],
      stationName: json['station_name'],
      totalWater: (json['total_water'] as num).toDouble(),
      waterCapacity: json['water_capacity'],
      year: json['year'],
    );
  }
}
class ConsumptionModel {
  final num? chlorine;
  final num? liquidAlum;
  final double? money;
  final num? power;
  final num? solidAlum;
  final num? water;
  final num?sanitaion;

  final List<OverConsump>? overChlorineConsump;
  final List<OverConsump>? overLiquidAlumConsump;
  final List<OverConsump>? overPowerConsump;
  final List<OverConsump>? overSolidAlumConsump;
  final List<OverWaterStation>? overWaterStations; // 👈 New field

  ConsumptionModel({
    required this.sanitaion,
    required this.chlorine,
    required this.liquidAlum,
    required this.money,
    required this.power,
    required this.solidAlum,
    required this.water,
    required this.overChlorineConsump,
    required this.overLiquidAlumConsump,
    required this.overPowerConsump,
    required this.overSolidAlumConsump,
    required this.overWaterStations, // 👈 New param
  });

  factory ConsumptionModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionModel(
      chlorine: json['chlorine'],
      liquidAlum: json['liquid_alum'],
      money: json['money'],
      power: json['power'],
      solidAlum: json['solid_alum'],
      water: json['water'],
      sanitaion: json['sanitaion'],
      overChlorineConsump: json['over_chlorine_consump'] == null
          ? null
          : (json['over_chlorine_consump'] as List)
              .map((e) => OverConsump.fromJson(e))
              .toList(),
      overLiquidAlumConsump: json['over_liquid_alum_consump'] == null
          ? null
          : (json['over_liquid_alum_consump'] as List)
              .map((e) => OverConsump.fromJson(e))
              .toList(),
      overPowerConsump: json['over_power_consump'] == null
          ? null
          : (json['over_power_consump'] as List)
              .map((e) => OverConsump.fromJson(e))
              .toList(),
      overSolidAlumConsump: json['over_solid_alum_consump'] == null
          ? null
          : (json['over_solid_alum_consump'] as List)
              .map((e) => OverConsump.fromJson(e))
              .toList(),
      overWaterStations: json['over_water_stations'] == null
          ? null
          : (json['over_water_stations'] as List)
              .map((e) => OverWaterStation.fromJson(e))
              .toList(),
    );
  }
}

class OverConsump {
  final int billMonth;
  final int billYear;
  final num? chlorineRangeFrom;
  final num? chlorineRangeTo;
  final num? liquidAlumRangeFrom;
  final num? liquidAlumRangeTo;
  final num? powerPerWater;
  final num? solidAlumRangeFrom;
  final num? solidAlumRangeTo;
  final int stationId;
  final String stationName;
  final int techBillId;
  final num? technologyBillPercentage;
  final String technologyBillTotal;
  final num? technologyChlorineConsump;
  final int technologyId;
  final num? technologyLiquidAlumConsump;
  final String technologyName;
  final num? technologyPowerConsump;
  final num? technologySolidAlumConsump;
  final num? technologyWaterAmount;

  OverConsump({
    required this.billMonth,
    required this.billYear,
    required this.chlorineRangeFrom,
    required this.chlorineRangeTo,
    required this.liquidAlumRangeFrom,
    required this.liquidAlumRangeTo,
    required this.powerPerWater,
    required this.solidAlumRangeFrom,
    required this.solidAlumRangeTo,
    required this.stationId,
    required this.stationName,
    required this.techBillId,
    required this.technologyBillPercentage,
    required this.technologyBillTotal,
    required this.technologyChlorineConsump,
    required this.technologyId,
    required this.technologyLiquidAlumConsump,
    required this.technologyName,
    required this.technologyPowerConsump,
    required this.technologySolidAlumConsump,
    required this.technologyWaterAmount,
  });

  factory OverConsump.fromJson(Map<String, dynamic> json) {
    return OverConsump(
      billMonth: json['bill_month'],
      billYear: json['bill_year'],
      chlorineRangeFrom: json['chlorine_range_from'],
      chlorineRangeTo: json['chlorine_range_to'],
      liquidAlumRangeFrom: json['liquid_alum_range_from'],
      liquidAlumRangeTo: json['liquid_alum_range_to'],
      powerPerWater: json['power_per_water'],
      solidAlumRangeFrom: json['solid_alum_range_from'],
      solidAlumRangeTo: json['solid_alum_range_to'],
      stationId: json['station_id'],
      stationName: json['station_name'],
      techBillId: json['tech_bill_id'],
      technologyBillPercentage: json['technology_bill_percentage'],
      technologyBillTotal: json['technology_bill_total'],
      technologyChlorineConsump: json['technology_chlorine_consump'],
      technologyId: json['technology_id'],
      technologyLiquidAlumConsump: json['technology_liquid_alum_consump'],
      technologyName: json['technology_name'],
      technologyPowerConsump: json['technology_power_consump'],
      technologySolidAlumConsump: json['technology_solid_alum_consump'],
      technologyWaterAmount: json['technology_water_amount'],
    );
  }
}
