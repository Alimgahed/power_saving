
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


