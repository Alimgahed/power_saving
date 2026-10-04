import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Chemacialcontroller extends GetxController {
  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

  static List<dynamic>? sessionCache;
  // Master & display data
  final List<AlumChlorineReference> allChemicals = [];
  final chemicals = <AlumChlorineReference>[].obs;

  // Search
  final searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    getchemicals();
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

  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  // -------------------------------
  // API Call - Get Chemicals
  // -------------------------------
  void getchemicals({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        allChemicals.clear();
        allChemicals.addAll(sessionCache!.map((e) => AlumChlorineReference.fromJson(e)));
        chemicals.value = List.from(allChemicals);
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        loading.value = true;
      }
    }

    try {
      if (!isBackground) {
        allChemicals.clear();
        chemicals.clear();
      }

      final res = await fetchData("${ApiConfig.baseUrl}/chemicals");
      
      if (res.statusCode == 200) {
        final List<dynamic> responseData = json.decode(res.body);
        
        sessionCache = responseData;
        
        final List<AlumChlorineReference> parsed = responseData.map((e) => AlumChlorineReference.fromJson(e)).toList();
        
        allChemicals.clear();
        allChemicals.addAll(parsed);
        
        // Re-apply current search filter instead of unconditionally clearing search
        _performSearch(_searchQuery.value);
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    getchemicals(isBackground: true);
  }

  Future<void> forceRefresh() async {
    loading.value = true;
    getchemicals(isBackground: false);
  }

  // -------------------------------
  // Search & Filter Logic
  // -------------------------------
  final RxString selectedFilter = 'all'.obs; // 'all', 'summer', 'winter'

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _performSearch(_searchQuery.value);
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = allChemicals.where((chem) {
      final seasonRaw = chem.season.toLowerCase();

      // 1. Season Filter
      if (selectedFilter.value == 'summer' && seasonRaw != 'summer') {
        return false;
      }
      if (selectedFilter.value == 'winter' && seasonRaw != 'winter') {
        return false;
      }

      // 2. Text Search
      if (query.isEmpty) return true;

      final tech = chem.tech?.toLowerCase() ?? '';
      final source = chem.source?.toLowerCase() ?? '';

      return tech.contains(lowerQuery) ||
             source.contains(lowerQuery) ||
             seasonRaw.contains(lowerQuery);
    }).toList();

    if (filtered.isEmpty && (query.isNotEmpty || selectedFilter.value != 'all')) {
      searchError.value = 'لا توجد نتائج مطابقة';
      chemicals.value = [];
    } else {
      searchError.value = '';
      chemicals.value = filtered;
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (!isSearching.value) {
      searchController.clear();
      _searchQuery.value = '';
      searchError.value = '';
      chemicals.value = List.from(allChemicals);
    }
  }

  // Get statistics
  int get summerCount => 
      allChemicals.where((c) => c.season.toLowerCase() == 'summer').length;
  
  int get winterCount => 
      allChemicals.where((c) => c.season.toLowerCase() == 'winter').length;
}
