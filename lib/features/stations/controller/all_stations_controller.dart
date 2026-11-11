import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class StationsController extends GetxController {
  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

  // Static Session Cache
  static List<dynamic>? sessionCache;

  // Master & display data
  final List<Station> allStations = [];      // non-observable
  final stations = <Station>[].obs;           // observable for UI

  // Search
  final searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    getStations();
    _setupSearchWorker();
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  // -------------------------------
  // Search Worker (Debounce)
  // -------------------------------
  void _setupSearchWorker() {
    _searchWorker = debounce(
      _searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 300),
    );
  }

  // Called from UI on text change
  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  // -------------------------------
  // API Call
  // -------------------------------
  Future<void> getStations({bool isBackground = false}) async {
    try {
      if (!isBackground) {
        if (sessionCache != null) {
          // 1. Display cached data instantly
          final List<Station> parsedCache = sessionCache!.map((e) => Station.fromJson(e)).toList();
          allStations.clear();
          allStations.addAll(parsedCache);
          stations.value = List.from(allStations);
          
          // 2. Fetch in background silently
          _fetchLatestBackground();
          return;
        } else {
          loading.value = true;
        }
      }

      final response = await fetchData("${ApiConfig.baseUrl}/stations");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        // Update Static Cache
        sessionCache = jsonData;

        allStations
          ..clear()
          ..addAll(jsonData.map((e) => Station.fromJson(e)));

        // If a search is active, we should re-apply it instead of just copying allStations.
        if (isSearching.value && searchController.text.isNotEmpty) {
           _performSearch(searchController.text);
        } else {
           stations.value = List.from(allStations);
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
      debugPrint('Stations error: $e');
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    await getStations(isBackground: true);
  }

  Future<void> forceRefresh() async {
    loading.value = true;
    await getStations(isBackground: false);
  }

  // -------------------------------
  // Search Logic
  // -------------------------------
  void _performSearch(String query) {
    if (query.isEmpty) {
      stations.value = List.from(allStations);
      searchError.value = '';
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered = allStations.where((station) {
      final stationName = station.stationName.toLowerCase();
      final branchName = station.branchName?.toLowerCase() ?? '';

      return stationName.contains(lowerQuery) ||
             branchName.contains(lowerQuery);
    }).toList();

    if (filtered.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق "$query"';
      stations.value = [];
    } else {
      searchError.value = '';
      stations.value = filtered;
    }
  }

  // -------------------------------
  // UI Helpers
  // -------------------------------
  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (!isSearching.value) {
      searchController.clear();
      _searchQuery.value = '';
      searchError.value = '';
      stations.value = List.from(allStations);
    }
  }

 
}
