class AreaOfService {
  final int areaId;
  final String areaName;
  AreaOfService({
    required this.areaId,
    required this.areaName,
 
  });

  // Factory method to create an AreaOfService instance from JSON
  factory AreaOfService.fromJson(Map<String, dynamic> json) {
    return AreaOfService(
      areaId: json['area_id'],
      areaName: json['area_name'],
    );
    
  }}