import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/relations/model/relations.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class RelationsController extends GetxController {
  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;
  final isProcessing = false.obs;

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
  Future<void> getRelations() async {
    try {
      loading.value = true;

      final response = await fetchData("${ApiConfig.baseUrl}/stg-relations");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        allRelations
          ..clear()
          ..addAll(
            jsonData.map((e) => StationGaugeTechnologyRelation.fromJson(e)),
          );

        relations.value = List.from(allRelations);
      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحميل قائمة الربط',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Relations error: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  // -------------------------------
  // API Call - Edit Relation
  // -------------------------------
  Future<void> editRelation(int id, String successMessage) async {
    try {
      isProcessing.value = true;

      final response = await fetchData("${ApiConfig.baseUrl}/edit-relation/$id");

      if (response.statusCode == 200) {
        // Refresh data from server to get updated status
        await getRelations();
        
        // Reapply search filter if active
        if (_searchQuery.value.isNotEmpty) {
          _performSearch(_searchQuery.value);
        }

        showSuccessToast(successMessage);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
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
  void _performSearch(String query) {
    if (query.isEmpty) {
      relations.value = List.from(allRelations);
      searchError.value = '';
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filtered = allRelations.where((relation) {
      final stationName = relation.stationName?.toLowerCase() ?? '';
      final accountNumber = relation.accountNumber.toLowerCase();

      return stationName.contains(lowerQuery) ||
             accountNumber.contains(lowerQuery);
    }).toList();

    if (filtered.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق "$query"';
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