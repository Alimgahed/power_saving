import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/network/network.dart';

class PlacesController extends GetxController {
  RxBool loading = false.obs;  // To track loading state
  RxBool isSearching = false.obs;  // To track if the user is searching
  RxList<PlaceType> placeTypes = <PlaceType>[].obs; // List to hold place types
  RxList<Place> places = <Place>[].obs; // List to hold places
  TextEditingController searchController = TextEditingController();  // Controller for search input

  @override
  void onInit() {
    super.onInit();
    allPlaces();  // Load places when the controller is initialized
  }

  // Fetch Place Types from API
 

  // Fetch all places from API
  void allPlaces() async {
    try {
      loading.value = true;  // Start loading

      final response = await fetchData("http://$ip/places");
      if (response.statusCode == 200) {
        // If the response is successful (status code 200)
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Map the JSON data to a list of Place objects
        places.value = jsonData.map((item) => Place.fromJson(item)).toList();

        loading.value = false;  // Stop loading
        update();  // Update the UI
      } else {
        // Handle error response
        loading.value = false;
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      // Handle error in the try-catch block
      loading.value = false;
      print("Error fetching data: $e");
    }
  }

  // Function to toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      // Reset search when the search bar is closed
      searchController.clear();
      filterPlaces('');  // Show all places
    }
    update();  // Update the UI
  }

  // Function to filter places based on search query
  void filterPlaces(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all places
      allPlaces();  // Fetch all places again if query is empty
    } else {
      // Filter the places based on the search query (by place name, branch name, or area name)
      places.value = places.where((place) {
        return place.placeName.toLowerCase().contains(query.toLowerCase()) ||
               place.branchName!.toLowerCase().contains(query.toLowerCase()) ||
               place.areaName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update(); // Update the UI
  }
}
