import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/relations/model/relations.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class RelationsController extends GetxController {
  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;
  final isProcessing = false.obs;

  static List<dynamic>? sessionCache;
  // Master & display data
  final List<StationGaugeTechnologyRelation> allRelations = [];  // non-observable
  final relations = <StationGaugeTechnologyRelation>[].obs;       // observable for UI

  // Search
  final searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    getRelations();
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
  // API Call - Get Relations
  // -------------------------------
  Future<void> getRelations({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        allRelations.clear();
        allRelations.addAll(sessionCache!.map((e) => StationGaugeTechnologyRelation.fromJson(e)));
        relations.value = List.from(allRelations);
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        loading.value = true;
      }
    }

    try {
      if (!isBackground) {
        allRelations.clear();
        relations.clear();
      }

      final response = await fetchData("${ApiConfig.baseUrl}/stg-relations");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        sessionCache = jsonData;

        final List<StationGaugeTechnologyRelation> parsed = jsonData.map((e) => StationGaugeTechnologyRelation.fromJson(e)).toList();

        allRelations.clear();
        allRelations.addAll(parsed);
        
        // Apply search filter again to keep current UI state consistent
        _performSearch(_searchQuery.value);
      } else if (!isBackground) {
        Get.snackbar(
          'خطأ',
          'فشل تحميل قائمة الربط',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        debugPrint('Relations error: $e');
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تحميل البيانات',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    getRelations(isBackground: true);
  }

  Future<void> forceRefresh() async {
    loading.value = true;
    getRelations(isBackground: false);
  }

  // -------------------------------
  // API Call - Edit Relation
  // -------------------------------
  Future<void> editRelation(int id, String successMessage) async {
    try {
      isProcessing.value = true;

      final response = await fetchData("${ApiConfig.baseUrl}/edit-relation/$id");

      if (response.statusCode == 200) {
        // Cache invalidation and silent refresh
        sessionCache = null;
        await _fetchLatestBackground();
        
        showSuccessToast(successMessage);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint('Edit relation error: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث الربط',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  // -------------------------------
  // Search Logic
  // -------------------------------
  final RxString selectedFilter = 'all'.obs; // 'all', 'active', 'inactive'

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _performSearch(_searchQuery.value);
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = allRelations.where((relation) {
      // 1. Status Filter
      if (selectedFilter.value == 'active' && relation.relationStatus != true) {
        return false;
      }
      if (selectedFilter.value == 'inactive' && relation.relationStatus == true) {
        return false;
      }

      // 2. Text Search
      if (query.isEmpty) return true;

      final stationName = relation.stationName?.toLowerCase() ?? '';
      final accountNumber = relation.accountNumber.toLowerCase();

      return stationName.contains(lowerQuery) ||
             accountNumber.contains(lowerQuery);
    }).toList();

    if (filtered.isEmpty && (query.isNotEmpty || selectedFilter.value != 'all')) {
      searchError.value = 'لا توجد نتائج متطابقة';
      relations.value = [];
    } else {
      searchError.value = '';
      relations.value = filtered;
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
      relations.value = List.from(allRelations);
    }
  }

  // Get statistics
  int get activeCount => 
      relations.where((r) => r.relationStatus == true).length;
  
  int get inactiveCount => 
      relations.where((r) => r.relationStatus == false).length;
}