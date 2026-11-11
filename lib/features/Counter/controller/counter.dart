import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class CounterController extends GetxController {
  // Observable states
  final looading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

  static List<dynamic>? sessionCache;
  // Data storage - separated for performance
  final List<ElectricMeter> _allCounters = []; // Master data (non-observable)
  final allcounter = <ElectricMeter>[].obs; // Display data (observable)
  final filteredCounters = <ElectricMeter>[].obs; // Search results

  // Search management
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  Worker? _searchWorker;

  final selectedBranch = RxnString();

  List<String> get availableBranches {
    final branches = _allCounters.map((c) => c.branch ?? 'غير محدد').toSet().toList();
    branches.sort();
    return ['الكل', ...branches];
  }

  void filterByBranch(String? branch) {
    if (branch == 'الكل') {
      selectedBranch.value = null;
    } else {
      selectedBranch.value = branch;
    }
    _performSearch(_searchQuery.value);
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllCounters();
    _setupSearchListener();
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Setup search with debounce using Worker
  void _setupSearchListener() {
    _searchWorker = debounce(
      _searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 300),
    );
  }

  // Called from UI when text changes
  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  // Perform the actual search (called after debounce)
  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    // Optimized filtering with single pass
    final results = _allCounters.where((meter) {
      final meterId = meter.meterId.toLowerCase();
      final accountNumber = meter.accountNumber?.toLowerCase() ?? '';
      final branch = meter.branch ?? 'غير محدد';
      final branchLower = branch.toLowerCase();

      final matchQuery = query.isEmpty ||
             meterId.contains(lowerQuery) ||
             accountNumber.contains(lowerQuery) ||
             branchLower.contains(lowerQuery);
             
      final matchBranch = selectedBranch.value == null || branch == selectedBranch.value;

      return matchQuery && matchBranch;
    }).toList();

    // Update results
    if (results.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق البحث';
      filteredCounters.value = [];
    } else {
      searchError.value = '';
      filteredCounters.value = results;
    }
  }

  // Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (!isSearching.value) {
      searchController.clear();
      _searchQuery.value = '';
      searchError.value = '';
      filteredCounters.clear();
    }
  }

  // Clear filter and show all counters
  void clearFilter() {
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    filteredCounters.clear();
  }

  // Legacy method for compatibility
  void filterCounters(String query) {
    onSearchChanged(query);
  }

  // Fetch all counters from API
  Future<void> fetchAllCounters({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        _allCounters.clear();
        _allCounters.addAll(sessionCache!.map((json) => ElectricMeter.fromJson(json)));
        allcounter.value = List.from(_allCounters);
        conters = _allCounters;
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        looading.value = true;
      }
    }

    try {
      if (!isBackground) {
        _allCounters.clear();
        allcounter.clear();
      }

      final response = await fetchData("${ApiConfig.baseUrl}/gauges");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        sessionCache = jsonData;

        final List<ElectricMeter> parsed = jsonData.map((json) => ElectricMeter.fromJson(json)).toList();

        _allCounters.clear();
        _allCounters.addAll(parsed);
        
        allcounter.value = List.from(_allCounters);
        conters = _allCounters; // Update global variable
        
        // Apply search filter again to keep current UI state consistent
        _performSearch(_searchQuery.value);
      } else if (!isBackground) {
        Get.snackbar(
          'خطأ',
          'فشل تحميل العدادات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        debugPrint("Error fetching counters: $e");
      }
    } finally {
      if (!isBackground) {
        looading.value = false;
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    fetchAllCounters(isBackground: true);
  }

  // Add new counter
  Future<void> addCounter(ElectricMeter counter) async {
    try {
      final response = await postData(
        "${ApiConfig.baseUrl}/new-station",
        counter.toJson(),
      );

      if (response.statusCode == 200) {
        showSuccessToast("تم إضافة العداد بنجاح");
        await fetchAllCounters();
        Get.back();
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: error);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint("Error adding counter: $e");
    }
  }

  // Refresh data
  @override
  Future<void> refresh() async {
    sessionCache = null;
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    filteredCounters.clear();
    looading.value = true;
    await fetchAllCounters(isBackground: false);
  }

  // Get display list (filtered or all)
  List<ElectricMeter> get displayCounters {
    return filteredCounters.isNotEmpty || searchController.text.isNotEmpty || selectedBranch.value != null
        ? filteredCounters
        : allcounter;
  }
}