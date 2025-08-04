class PredictionModel {
  final String predictionPlot; // base64 image string
  final num waterCapacity; // max_water_amount
  final num representedPoints; // points_represented * 100
  final num expectedYear; // expected_year

  PredictionModel({
    required this.predictionPlot,
    required this.waterCapacity,
    required this.representedPoints,
    required this.expectedYear,
  });

  // Factory method to parse from JSON
  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      predictionPlot: json['prediction_plot'] ?? '',
      waterCapacity: (json['water_capacity'] ?? 0).toDouble(),
      representedPoints: (json['represented_points'] ?? 0).toDouble(),
      expectedYear: json['expected_year'] ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'prediction_plot': predictionPlot,
      'water_capacity': waterCapacity,
      'represented_points': representedPoints,
      'expected_year': expectedYear,
    };
  }
}
