class Place {
  final int? placeId;
  final String placeName;
  final int placeTypeId;
  final int branchId;
  final int areaId;
  final String? placeTypeName;
  final String? areaName;
  final String? branchName;
  final List<PopulationsModel>? populations;
  // Add other relationships if needed, such as `Branch`, `AreaOfService`

  // Constructor
  Place({
    this.populations,
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
      populations: (json['populations'] as List<dynamic>?)
          ?.map((e) => PopulationsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'populations': populations?.map((e) => e.toJson()).toList(),
    };
  }
}
class PopulationsModel {
  int placeId;
  String placeName;
  int population;
  int populationYear;

  // Constructor
  PopulationsModel({
    required this.placeId,
    required this.placeName,
    required this.population,
    required this.populationYear,
  });

  // Factory constructor to create a Place instance from a JSON object
  factory PopulationsModel.fromJson(Map<String, dynamic> json) {
    return PopulationsModel(
      placeId: json['place_id'],
      placeName: json['place_name'],
      population: json['population'],
      populationYear: json['population_year'],
    );
  }

  // Method to convert a Place instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'population': population,
      'population_year': populationYear,
    };
  }

  // Optionally, you can create a method to print the data in a human-readable format
  @override
  String toString() {
    return 'Place{id: $placeId, name: $placeName, population: $population, populationYear: $populationYear}';
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



  // Convert an AreaOfService instance to JSON
  
