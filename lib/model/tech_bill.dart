class TechnologyBill {
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
  final num technologyBillPercentage;
  final String technologyBillTotal;
  final num? technologyChlorineConsump;
  final int technologyId;
  final num? technologyLiquidAlumConsump;
  final String technologyName;
  final num technologyPowerConsump;
  final num? technologySolidAlumConsump;
  final num? technologyWaterAmount;

  TechnologyBill({
    required this.billMonth,
    required this.billYear,
    this.chlorineRangeFrom,
    this.chlorineRangeTo,
    this.liquidAlumRangeFrom,
    this.liquidAlumRangeTo,
    this.powerPerWater,
    this.solidAlumRangeFrom,
    this.solidAlumRangeTo,
    required this.stationId,
    required this.stationName,
    required this.techBillId,
    required this.technologyBillPercentage,
    required this.technologyBillTotal,
    this.technologyChlorineConsump,
    required this.technologyId,
    this.technologyLiquidAlumConsump,
    required this.technologyName,
    required this.technologyPowerConsump,
    this.technologySolidAlumConsump,
    this.technologyWaterAmount,
  });

  factory TechnologyBill.fromJson(Map<String, dynamic> json) {
    return TechnologyBill(
      billMonth: json['bill_month'],
      billYear: json['bill_year'],
      chlorineRangeFrom: json['chlorine_range_from']??0,
      chlorineRangeTo: json['chlorine_range_to']??0,
      liquidAlumRangeFrom: json['liquid_alum_range_from']??0,
      liquidAlumRangeTo: json['liquid_alum_range_to']??0,
      powerPerWater: json['power_per_water']??0,
      solidAlumRangeFrom: json['solid_alum_range_from']??0,
      solidAlumRangeTo: json['solid_alum_range_to']??0,
      stationId: json['station_id'],
      stationName: json['station_name'],
      techBillId: json['tech_bill_id'],
      technologyBillPercentage: json['technology_bill_percentage']??0,
      technologyBillTotal: json['technology_bill_total']??0,
      technologyChlorineConsump: json['technology_chlorine_consump']??0,
      technologyId: json['technology_id'],
      technologyLiquidAlumConsump: json['technology_liquid_alum_consump']??0,
      technologyName: json['technology_name'],
      technologyPowerConsump: json['technology_power_consump']??0,
      technologySolidAlumConsump: json['technology_solid_alum_consump']??0,
      technologyWaterAmount: json['technology_water_amount']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bill_month': billMonth,
      'bill_year': billYear,
      'chlorine_range_from': chlorineRangeFrom,
      'chlorine_range_to': chlorineRangeTo,
      'liquid_alum_range_from': liquidAlumRangeFrom,
      'liquid_alum_range_to': liquidAlumRangeTo,
      'power_per_water': powerPerWater,
      'solid_alum_range_from': solidAlumRangeFrom,
      'solid_alum_range_to': solidAlumRangeTo,
      'station_id': stationId,
      'station_name': stationName,
      'tech_bill_id': techBillId,
      'technology_bill_percentage': technologyBillPercentage,
      'technology_bill_total': technologyBillTotal,
      'technology_chlorine_consump': technologyChlorineConsump,
      'technology_id': technologyId,
      'technology_liquid_alum_consump': technologyLiquidAlumConsump,
      'technology_name': technologyName,
      'technology_power_consump': technologyPowerConsump,
      'technology_solid_alum_consump': technologySolidAlumConsump,
      'technology_water_amount': technologyWaterAmount,
    };
  }
}
