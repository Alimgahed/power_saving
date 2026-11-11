class AreaOfService {
  final int areaId;
  final String areaName;
  final bool increasable;

  AreaOfService({
    required this.areaId,
    required this.areaName,
    this.increasable = false,
  });

  // Factory method to create an AreaOfService instance from JSON
  factory AreaOfService.fromJson(Map<String, dynamic> json) {
    return AreaOfService(
      areaId: json['area_id'] ?? 0,
      areaName: json['area_name'] ?? '',
      increasable: json['increasable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'area_name': areaName,
      'increasable': increasable,
    };
  }
}