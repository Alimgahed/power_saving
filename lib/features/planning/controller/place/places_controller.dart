import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/network/network.dart';

class PlacesController extends GetxController {
  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

  // Data storage - separated for performance
  final List<Place> _allPlaces = [];  // Master data (non-observable)
  final places = <Place>[].obs;  // Display data (observable)

  // Search management
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  Timer? _debounceTimer;
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    allPlaces();
    _setupSearchListener(); // Ensure debounce is set up correctly
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _searchWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Setup search with debounce using Worker (correct implementation)
  void _setupSearchListener() {
    // Worker setup for debounce on search query
    _searchWorker = debounce<String>(
      _searchQuery,  // Observable RxString (not TextEditingController!),
      (query) {
        _performSearch(query);  // Perform search after debounce
      },
      time: const Duration(milliseconds: 300),
    );
  }

  // Called from UI when text changes
  void onSearchChanged(String query) {
    _searchQuery.value = query;  // Update observable to trigger debounce
  }

  // Fetch all places from API
  Future<void> allPlaces() async {
    try {
      loading.value = true;

      final response = await fetchData("${ApiConfig.baseUrl}/places");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        // Clear and populate master list
        _allPlaces.clear();
        _allPlaces.addAll(
          jsonData.map((json) => Place.fromJson(json))
        );

        // Update display list
        places.value = List.from(_allPlaces);

      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحميل البيانات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("Error fetching places: $e");
    } finally {
      loading.value = false;
    }
  }

  // Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (!isSearching.value) {
      // Clear search state
      searchController.clear();
      _searchQuery.value = '';
      searchError.value = '';
      places.value = List.from(_allPlaces);
    }
  }

  // Perform the actual search (called after debounce)
  void _performSearch(String query) {
    if (query.isEmpty) {
      places.value = List.from(_allPlaces);
      searchError.value = '';
      return;
    }

    final lowerQuery = query.toLowerCase();

    // Optimized filtering with single pass
    final filteredPlaces = _allPlaces.where((place) {
      final name = place.placeName.toLowerCase();
      final branch = place.branchName?.toLowerCase() ?? '';
     

      return name.contains(lowerQuery) ||
             branch.contains(lowerQuery) ;
          
    }).toList();

    // Update results
    if (filteredPlaces.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق "$query"';
      places.value = [];
    } else {
      searchError.value = '';
      places.value = filteredPlaces;
    }
  }

  // Alternative: Manual filter (without Worker) - for immediate response
  void filterPlacesImmediate(String query) {
    // Cancel any pending debounce
    _debounceTimer?.cancel();

    // Start new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  @override
  Future<void> refresh() async {
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    await allPlaces();
  }
}
