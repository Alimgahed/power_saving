import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class TechnlogyController extends GetxController {
  RxBool looading = false.obs;
  RxBool isLoading = false.obs;
  
  // Static Session Cache
  static List<dynamic>? sessionCache;
  
  // Master data
  List<TechnologyModel> all_technology = [];
  
  // State for view
  List<TechnologyModel> filteredTechnologies = [];
  
  // Search & Filter
  String main_type = "";
  String selectedFilter = 'all';
  final isSearching = false.obs;
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  Worker? _searchWorker;

  late TextEditingController name;
  late TextEditingController chlorine;
  late TextEditingController liquid;
  late TextEditingController solid;
  late TextEditingController power;

  @override
  void onInit() {
    liquid = TextEditingController();
    solid = TextEditingController();
    power = TextEditingController();
    chlorine = TextEditingController();
    name = TextEditingController();
    alltechnology();
    
    // Setup search listener with debounce
    _searchWorker = debounce(
      _searchQuery,
      (query) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    searchController.dispose();
    // Do not dispose other controllers here to prevent issues with Edittech
    super.onClose();
  }

  // --- Search & Filter Logic ---

  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      _searchQuery.value = '';
      _applyFilters();
    }
  }

  void filterByType(String type) {
    selectedFilter = type;
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchQuery.value.toLowerCase();
    
    final results = all_technology.where((tech) {
      // Filter by type
      final matchType = selectedFilter == 'all' || tech.main_type == selectedFilter;
      
      // Filter by text search
      final matchQuery = query.isEmpty ||
          tech.technologyName.toLowerCase().contains(query) ||
          tech.main_type.toLowerCase().contains(query);
          
      return matchType && matchQuery;
    }).toList();
    
    filteredTechnologies = results;
    update();
  }

  // Get filtered technologies (for UI compatibility)
  List<TechnologyModel> getFilteredTechnologies() {
    return filteredTechnologies;
  }

  // --- API Calls ---

  Future<void> alltechnology({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        // 1. Display cached data instantly
        all_technology.clear();
        for (var i in sessionCache!) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
        }
        technologies = all_technology;
        _applyFilters();
        
        // 2. Fetch silently in background
        _fetchLatestBackground();
        return;
      } else {
        isLoading.value = true;
        update();
      }
    }
    
    try {
      final res = await fetchData("${ApiConfig.baseUrl}/technologies");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        // Update static cache
        sessionCache = responseData;

        all_technology.clear();
        for (var i in responseData) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
        }
        
        technologies = all_technology; // Update global
        _applyFilters(); // Initialize filtered list
        
        if (!isBackground) {
          isLoading.value = false;
          update();
        }
      } else {
        if (!isBackground) {
          isLoading.value = false;
          update();
          debugPrint("Failed to fetch technologies: ${res.body}");
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        isLoading.value = false;
        update();
        debugPrint("Error fetching technologies: $e");
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    await alltechnology(isBackground: true);
  }

  Future<void> forceRefresh() async {
    isLoading.value = true;
    update();
    await alltechnology(isBackground: false);
  }

  Future<void> addtech({required TechnologyModel tech}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
      debugPrint("Error adding tech: $e");
    }
  }
}
