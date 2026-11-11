class MLDataQuality {
  final int totalRows;
  final int nAreas;
  final int nMonths;
  final bool reliable;
  final List<String> warnings;

  MLDataQuality({
    required this.totalRows,
    required this.nAreas,
    required this.nMonths,
    required this.reliable,
    required this.warnings,
  });

  factory MLDataQuality.fromJson(Map<String, dynamic> json) {
    List<String> warns = [];
    if (json['warnings'] is List) {
      for (var w in json['warnings']) {
        if (w is Map && w['message'] != null) {
          warns.add(w['message'].toString());
        } else if (w is String) {
          warns.add(w);
        }
      }
    }
    return MLDataQuality(
      totalRows: json['total_rows'] ?? 0,
      nAreas: json['n_areas'] ?? 0,
      nMonths: json['n_months'] ?? 0,
      reliable: json['reliable'] ?? false,
      warnings: warns,
    );
  }
}

class MLSaturationResult {
  final String? areaName;
  final int? peakMonth;
  final double? utilization;
  final int? year;
  final int? month;
  final int? popMax;
  final String? warning;
  final Map<String, dynamic>? scenarios;

  MLSaturationResult({
    this.areaName,
    this.peakMonth,
    this.utilization,
    this.year,
    this.month,
    this.popMax,
    this.warning,
    this.scenarios,
  });

  factory MLSaturationResult.fromJson(Map<String, dynamic> json) {
    return MLSaturationResult(
      areaName: json['area_name']?.toString(),
      peakMonth: json['peak_month'],
      utilization: json['utilization'] != null
          ? (json['utilization'] as num).toDouble()
          : null,
      year: json['year'],
      month: json['month'],
      popMax: json['pop_max'],
      warning: json['warning']?.toString(),
      scenarios: json['scenarios'] is Map<String, dynamic>
          ? json['scenarios'] as Map<String, dynamic>
          : null,
    );
  }
}

class MLForecastResponse {
  final String bestModel;
  final String featureSet;
  final double cvR2Mean;
  final double cvR2Std;
  final double finalR2;
  final double finalMae;
  final double? smearingFactor;
  final int? requestedAreaId;
  final MLSaturationResult? requestedAreaSaturation;
  final Map<String, MLSaturationResult> allAreasSaturation;
  final List<dynamic> atRiskAreas;
  final MLDataQuality? dataQuality;

  MLForecastResponse({
    required this.bestModel,
    required this.featureSet,
    required this.cvR2Mean,
    required this.cvR2Std,
    required this.finalR2,
    required this.finalMae,
    this.smearingFactor,
    this.requestedAreaId,
    this.requestedAreaSaturation,
    required this.allAreasSaturation,
    required this.atRiskAreas,
    this.dataQuality,
  });

  factory MLForecastResponse.fromJson(Map<String, dynamic> json) {
    Map<String, MLSaturationResult> areas = {};
    if (json['all_areas_saturation'] is Map) {
      (json['all_areas_saturation'] as Map).forEach((k, v) {
        if (v is Map<String, dynamic>) {
          areas[k.toString()] = MLSaturationResult.fromJson(v);
        }
      });
    }

    return MLForecastResponse(
      bestModel: json['best_model']?.toString() ?? '',
      featureSet: json['feature_set']?.toString() ?? '',
      cvR2Mean: (json['cv_r2_mean'] as num?)?.toDouble() ?? 0.0,
      cvR2Std: (json['cv_r2_std'] as num?)?.toDouble() ?? 0.0,
      finalR2: (json['final_r2'] as num?)?.toDouble() ?? 0.0,
      finalMae: (json['final_mae'] as num?)?.toDouble() ?? 0.0,
      smearingFactor: (json['smearing_factor'] as num?)?.toDouble(),
      requestedAreaId: json['requested_area_id'],
      requestedAreaSaturation: json['requested_area_saturation'] is Map<String, dynamic>
          ? MLSaturationResult.fromJson(json['requested_area_saturation'])
          : null,
      allAreasSaturation: areas,
      atRiskAreas: json['at_risk_areas'] is List ? json['at_risk_areas'] : [],
      dataQuality: json['data_quality'] is Map<String, dynamic>
          ? MLDataQuality.fromJson(json['data_quality'])
          : null,
    );
  }
}
