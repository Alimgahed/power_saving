class Place {
  final int? placeId;
  final String placeName;
  final int placeTypeId;
  final int branchId;
  final int areaId;
  final String? placeTypeName;
  final String? areaName;
  final String? branchName;
  // Add other relationships if needed, such as `Branch`, `AreaOfService`

  // Constructor
  Place({
     this.placeId,
    required this.placeName,
    required this.placeTypeId,
    required this.branchId,
    required this.areaId,
     this.placeTypeName,
     this.areaName,
     this.branchName,
  });

  // Factory method to create a Place instance from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeTypeId: json['place_type_id'],
      branchId: json['branch_id'],
      areaId: json['area_id'],
      placeTypeName: json['place_type_name'],
      areaName: json['area_name'],
      branchName: json['branch_name'],
    );
  }

  // Convert a Place instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'place_type_id': placeTypeId,
      'branch_id': branchId,
      'area_id': areaId,
      'place_type_name': placeTypeName,
      'area_name': areaName,
      'branch_name': branchName,
    };
  }
}

class PlaceType {
  final int personPortionFrom;
  final int personPortionTo;
  final int placeTypeId;
  final String placeTypeName;

  PlaceType({
    required this.personPortionFrom,
    required this.personPortionTo,
    required this.placeTypeId,
    required this.placeTypeName,
  });

  // Factory method to create a Place instance from JSON data
  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(
      personPortionFrom: json['person_portion_from'],
      personPortionTo: json['person_portion_to'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
    );
  }

  // Convert a Place instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'person_portion_from': personPortionFrom,
      'person_portion_to': personPortionTo,
      'place_type_id': placeTypeId,
      'place_type_name': placeTypeName,
    };
  }
}

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
    
  }
}
  // Convert an AreaOfService instance to JSON
  
