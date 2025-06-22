class StationGaugeTechnologyRelation {
  final String accountNumber;
  final bool relationStatus;
  final int? stationGaugeTechnologyId;
  final int stationId;
  final String? stationName;
  final int technologyId;
  final String? branchName;
  final String? technologyName;

  StationGaugeTechnologyRelation({
    required this.accountNumber,
    required this.relationStatus,
    this.stationGaugeTechnologyId,
    required this.stationId,
    this.stationName,
    this.branchName,
    required this.technologyId,
    this.technologyName,
  });

  factory StationGaugeTechnologyRelation.fromJson(Map<String, dynamic> json) {
    return StationGaugeTechnologyRelation(
      accountNumber: json['account_number'],
      branchName: json['branch_name'],
      relationStatus: json['relation_status'],
      stationGaugeTechnologyId: json['station_guage_technology_id'],
      stationId: json['station_id'],
      stationName: json['station_name'],
      technologyId: json['technology_id'],
      technologyName: json['technology_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'relation_status': relationStatus,
      'station_guage_technology_id': stationGaugeTechnologyId,
      'station_id': stationId,
      'branch_name': branchName,
      'station_name': stationName,
      'technology_id': technologyId,
      'technology_name': technologyName,
    };
  }
}
