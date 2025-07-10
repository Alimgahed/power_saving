class AlumChlorineReference {
  final int? chemicalId;
  final int technologyId;
  final int waterSourceId;
  final String season;
  final String? tech;
  final String? source;

  final double chlorineRangeFrom;
  final double chlorineRangeTo;
  final double? solidAlumRangeFrom;
  final double? solidAlumRangeTo;
  final double? liquidAlumRangeFrom;
  final double? liquidAlumRangeTo;

  AlumChlorineReference({
    this.chemicalId,
    this.tech,
    this.source,
    required this.technologyId,
    required this.waterSourceId,
    required this.season,
    required this.chlorineRangeFrom,
    required this.chlorineRangeTo,
    this.solidAlumRangeFrom,
    this.solidAlumRangeTo,
    this.liquidAlumRangeFrom,
    this.liquidAlumRangeTo,
  });

  factory AlumChlorineReference.fromJson(Map<String, dynamic> json) {
    return AlumChlorineReference(
      chemicalId: json['chemical_id'],
      technologyId: json['technology_id'],
      waterSourceId: json['water_source_id'],
      season: json['season'],
      tech: json['technology_name'],
      source: json['water_source_name'],
      chlorineRangeFrom: json['chlorine_range_from'].toDouble(),
      chlorineRangeTo: json['chlorine_range_to'].toDouble(),
      solidAlumRangeFrom: json['solid_alum_range_from']?.toDouble(),
      solidAlumRangeTo: json['solid_alum_range_to']?.toDouble(),
      liquidAlumRangeFrom: json['liquid_alum_range_from']?.toDouble(),
      liquidAlumRangeTo: json['liquid_alum_range_to']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technology_name': tech,
      'water_source_name': source,
      'chemical_id': chemicalId,
      'technology_id': technologyId,
      'water_source_id': waterSourceId,
      'season': season,
      'chlorine_range_from': chlorineRangeFrom,
      'chlorine_range_to': chlorineRangeTo,
      'solid_alum_range_from': solidAlumRangeFrom,
      'solid_alum_range_to': solidAlumRangeTo,
      'liquid_alum_range_from': liquidAlumRangeFrom,
      'liquid_alum_range_to': liquidAlumRangeTo,
    };
  }
}
