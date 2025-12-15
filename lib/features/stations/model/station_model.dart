class Station {
  final String? branchName;
  final int? stationId;
  final String stationName;
  final String stationType;
  final int? stationWaterCapacity;
  final int? branchid;
  final int? sourceid;

  final String? waterSourceName;

  Station({
    this.branchid,
    this.sourceid,
    this.branchName,
    this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    this.waterSourceName,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      sourceid: json['water_source_id'],
      branchid: json['branch_id'],
      branchName: json['branch_name'],
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      waterSourceName: json['water_source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'station_id': stationId,
      'station_name': stationName,
      'station_type': stationType,
      'station_water_capacity': stationWaterCapacity,
      'water_source_name': waterSourceName,
    };
  }
}

class Branch {
  final int branchId;
  final String branchName;

  Branch({required this.branchId, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(branchId: json['branch_id'], branchName: json['branch_name']);
  }

  Map<String, dynamic> toJson() {
    return {'branch_id': branchId, 'branch_name': branchName};
  }
}

class allstations {
  final int branchId;
  final String branchName;

  allstations({required this.branchId, required this.branchName});

  factory allstations.fromJson(Map<String, dynamic> json) {
    return allstations(
      branchId: json['station_id'],
      branchName: json['station_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'station_id': branchId, 'station_name': branchName};
  }
}

class WaterSource {
  final int? waterSourceId;
  final String? waterSourceName;

  WaterSource({required this.waterSourceId, required this.waterSourceName});

  factory WaterSource.fromJson(Map<String, dynamic> json) {
    return WaterSource(
      waterSourceId: json['water_source_id'],
      waterSourceName: json['water_source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water_source_id': waterSourceId,
      'water_source_name': waterSourceName,
    };
  }
}

class AddStationData {
  final List<Branch> branches;
  final List<WaterSource> waterSources;

  AddStationData({required this.branches, required this.waterSources});

  factory AddStationData.fromJson(Map<String, dynamic> json) {
    return AddStationData(
      branches:
          (json['branches'] as List).map((b) => Branch.fromJson(b)).toList(),
      waterSources:
          (json['water_sources'] as List)
              .map((ws) => WaterSource.fromJson(ws))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branches': branches.map((b) => b.toJson()).toList(),
      'water_sources': waterSources.map((ws) => ws.toJson()).toList(),
    };
  }
}
