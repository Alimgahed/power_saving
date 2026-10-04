
class TopStationEntry {
  final int stationId;
  final String stationName;
  final String branchName;
  final double totalValue;
  final double percent;

  TopStationEntry({
    required this.stationId,
    required this.stationName,
    required this.branchName,
    required this.totalValue,
    required this.percent,
  });

  factory TopStationEntry.fromJson(Map<String, dynamic> json, String valueKey, {double divider = 1}) {
    double p = (json['percent'] as num?)?.toDouble() ?? 0.0;
    if (p.isNaN || p.isInfinite) p = 0.0;
    
    return TopStationEntry(
      stationId: json['station_id'] ?? 0,
      stationName: json['station_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      totalValue: ((json[valueKey] as num?)?.toDouble() ?? 0.0) / divider,
      percent: p,
    );
  }
}

class Max5Data {
  final List<TopStationEntry> topWater;
  final List<TopStationEntry> topPower;
  final List<TopStationEntry> topChlorine;

  Max5Data({
    required this.topWater,
    required this.topPower,
    required this.topChlorine,
  });

  factory Max5Data.fromJson(Map<String, dynamic> json) {
    return Max5Data(
      topWater: (json['top_water'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_water'))
          .toList(),
      topPower: (json['top_power'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_power'))
          .toList(),
      topChlorine: (json['top_chlorine'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_chlorine', divider: 1000))
          .toList(),
    );
  }
}

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
      capacityLimit: json['capacity_limit'] ?? 0,
      month: json['month'] ?? 0,
      stationName: json['station_name'] ?? '',
      totalWater: (json['total_water'] as num?)?.toDouble() ?? 0.0,
      waterCapacity: json['water_capacity'] ?? 0,
      year: json['year'] ?? 0,
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
  final num? sanitaion;
  final List<OverWaterStation>? overWaterStations;
  final Max5Data? max5;

  // Raw JSON lists
  final List<dynamic>? _rawOverChlorineConsump;
  final List<dynamic>? _rawOverLiquidAlumConsump;
  final List<dynamic>? _rawOverPowerConsump;
  final List<dynamic>? _rawOverSolidAlumConsump;
  final List<dynamic>? _rawWaterForMissingPower;
  final List<dynamic>? _rawOverPowerFor0Water;

  // Cached parsed lists
  List<OverConsump>? _overChlorineConsump;
  List<OverConsump>? _overLiquidAlumConsump;
  List<OverConsump>? _overPowerConsump;
  List<OverConsump>? _overSolidAlumConsump;
  List<OverConsump>? _waterformissingpower;
  List<OverConsump>? _overpowerfor0water;

  ConsumptionModel({
    required this.sanitaion,
    required this.chlorine,
    required this.liquidAlum,
    required this.money,
    required this.power,
    required this.solidAlum,
    required this.water,
    required this.overWaterStations,
    this.max5,
    List<dynamic>? rawWaterForMissingPower,
    List<dynamic>? rawOverPowerFor0Water,
    List<dynamic>? rawOverChlorineConsump,
    List<dynamic>? rawOverLiquidAlumConsump,
    List<dynamic>? rawOverPowerConsump,
    List<dynamic>? rawOverSolidAlumConsump,
  })  : _rawWaterForMissingPower = rawWaterForMissingPower,
        _rawOverPowerFor0Water = rawOverPowerFor0Water,
        _rawOverChlorineConsump = rawOverChlorineConsump,
        _rawOverLiquidAlumConsump = rawOverLiquidAlumConsump,
        _rawOverPowerConsump = rawOverPowerConsump,
        _rawOverSolidAlumConsump = rawOverSolidAlumConsump;

  // Count getters
  int get overChlorineConsumpCount => _rawOverChlorineConsump?.length ?? 0;
  int get overLiquidAlumConsumpCount => _rawOverLiquidAlumConsump?.length ?? 0;
  int get overPowerConsumpCount => _rawOverPowerConsump?.length ?? 0;
  int get overSolidAlumConsumpCount => _rawOverSolidAlumConsump?.length ?? 0;
  int get waterForMissingPowerCount => _rawWaterForMissingPower?.length ?? 0;
  int get overPowerFor0WaterCount => _rawOverPowerFor0Water?.length ?? 0;

  // Lazy parsed getters
  List<OverConsump> get overChlorineConsump {
    if (_rawOverChlorineConsump == null) return [];
    _overChlorineConsump ??= _rawOverChlorineConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overChlorineConsump!;
  }

  List<OverConsump> get overLiquidAlumConsump {
    if (_rawOverLiquidAlumConsump == null) return [];
    _overLiquidAlumConsump ??= _rawOverLiquidAlumConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overLiquidAlumConsump!;
  }

  List<OverConsump> get overPowerConsump {
    if (_rawOverPowerConsump == null) return [];
    _overPowerConsump ??= _rawOverPowerConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overPowerConsump!;
  }

  List<OverConsump> get overSolidAlumConsump {
    if (_rawOverSolidAlumConsump == null) return [];
    _overSolidAlumConsump ??= _rawOverSolidAlumConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overSolidAlumConsump!;
  }

  List<OverConsump> get Waterformissingpower {
    if (_rawWaterForMissingPower == null) return [];
    _waterformissingpower ??= _rawWaterForMissingPower.map((e) => OverConsump.fromJson(e)).toList();
    return _waterformissingpower!;
  }

  List<OverConsump> get overpowerfor0water {
    if (_rawOverPowerFor0Water == null) return [];
    _overpowerfor0water ??= _rawOverPowerFor0Water.map((e) => OverConsump.fromJson(e)).toList();
    return _overpowerfor0water!;
  }

  factory ConsumptionModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionModel(
      chlorine: json['chlorine'],
      liquidAlum: json['liquid_alum'],
      money: (json['money'] as num?)?.toDouble(),
      power: json['power'],
      solidAlum: json['solid_alum'],
      water: json['water'],
      sanitaion: json['sanitaion'],
      rawWaterForMissingPower: json['water_with_missing_power'] as List?,
      rawOverPowerFor0Water: json['over_power_for_0_water'] as List?,
      rawOverChlorineConsump: json['over_chlorine_consump'] as List?,
      rawOverLiquidAlumConsump: json['over_liquid_alum_consump'] as List?,
      rawOverPowerConsump: json['over_power_consump'] as List?,
      rawOverSolidAlumConsump: json['over_solid_alum_consump'] as List?,
      overWaterStations: json['over_water_stations'] == null
          ? null
          : (json['over_water_stations'] as List)
              .map((e) => OverWaterStation.fromJson(e))
              .toList(),
      max5: json['max_5'] != null
          ? Max5Data.fromJson(json['max_5'] as Map<String, dynamic>)
          : null,
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
      billMonth: json['bill_month'] ?? 0,
      billYear: json['bill_year'] ?? 0,
      chlorineRangeFrom: json['chlorine_range_from'],
      chlorineRangeTo: json['chlorine_range_to'],
      liquidAlumRangeFrom: json['liquid_alum_range_from'],
      liquidAlumRangeTo: json['liquid_alum_range_to'],
      powerPerWater: json['power_per_water'],
      solidAlumRangeFrom: json['solid_alum_range_from'],
      solidAlumRangeTo: json['solid_alum_range_to'],
      stationId: json['station_id'] ?? 0,
      stationName: json['station_name'] ?? '',
      techBillId: json['tech_bill_id'] ?? 0,
      technologyBillPercentage: json['technology_bill_percentage'],
      technologyBillTotal: (json['technology_bill_total'] ?? '').toString(),
      technologyChlorineConsump: json['technology_chlorine_consump'],
      technologyId: json['technology_id'] ?? 0,
      technologyLiquidAlumConsump: json['technology_liquid_alum_consump'],
      technologyName: json['technology_name'] ?? '',
      technologyPowerConsump: json['technology_power_consump'],
      technologySolidAlumConsump: json['technology_solid_alum_consump'],
      technologyWaterAmount: json['technology_water_amount'],
    );
  }
}
