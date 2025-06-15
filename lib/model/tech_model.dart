class TechnologyModel {
  final double powerPerWater;
   int? technologyId;
  final String technologyName;

  TechnologyModel({
    required this.powerPerWater,
     this.technologyId,
    required this.technologyName,
  });

  factory TechnologyModel.fromJson(Map<String, dynamic> json) {
    return TechnologyModel(
      powerPerWater: json['power_per_water'],
      technologyId: json['technology_id'],
      technologyName: json['technology_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'power_per_water': powerPerWater,
      'technology_id': technologyId,
      'technology_name': technologyName,
    };
  }
}
