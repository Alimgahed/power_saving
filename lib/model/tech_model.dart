class TechnologyModel {
  final double powerPerWater;
   int? technologyId;
  final String technologyName;
   final String main_type;

  TechnologyModel({
    required this.powerPerWater,
     this.technologyId,
    required this.main_type,
    required this.technologyName,
  });

  factory TechnologyModel.fromJson(Map<String, dynamic> json) {
    return TechnologyModel(
      main_type: json['technology_main_type'],
      powerPerWater: json['power_per_water'],
      technologyId: json['technology_id'],
      technologyName: json['technology_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technology_main_type':main_type,
      'power_per_water': powerPerWater,
      'technology_id': technologyId,
      'technology_name': technologyName,
    };
  }
}
