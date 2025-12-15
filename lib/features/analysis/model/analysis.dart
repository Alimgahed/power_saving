class AnalysisModel {
  final String clorhine;
  final String soild;
  final String liquid;
  final String power;

  AnalysisModel({
    required this.clorhine,
    required this.soild,
    required this.liquid,
    required this.power,
  });

  // Factory method to create from JSON
  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      clorhine: json['chlorine_plot'] ?? '',
      liquid: json['liquid_alum_plot'] ?? '',
      soild: json['solid_alum_plot'] ?? '',
      power: json['power_plot'] ?? '',
    );
  }

}
