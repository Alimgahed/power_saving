import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class CounterController extends GetxController {
  // Observable states
  final looading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

  // Data storage - separated for performance
  final List<ElectricMeter> _allCounters = []; // Master data (non-observable)
  final allcounter = <ElectricMeter>[].obs; // Display data (observable)
  final filteredCounters = <ElectricMeter>[].obs; // Search results

  // Search management
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  Worker? _searchWorker;

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
    if (query.isEmpty) {
      filteredCounters.clear();
      searchError.value = '';
      return;
    }

    final lowerQuery = query.toLowerCase();

    // Optimized filtering with single pass
    final results = _allCounters.where((meter) {
      final meterId = meter.meterId.toLowerCase();
      final accountNumber = meter.accountNumber?.toLowerCase() ?? '';
      final branch = meter.branch?.toLowerCase() ?? '';

      return meterId.contains(lowerQuery) ||
             accountNumber.contains(lowerQuery) ||
             branch.contains(lowerQuery);
    }).toList();

    // Update results
    if (results.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق "$query"';
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
  Future<void> fetchAllCounters() async {
    try {
      looading.value = true;

      final response = await fetchData("http://$ip/gauges");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Store in non-observable list
        _allCounters.clear();
        _allCounters.addAll(
          jsonData.map((json) => ElectricMeter.fromJson(json))
        );

        // Update display list
        allcounter.value = List.from(_allCounters);
        conters = _allCounters; // Update global variable

      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحميل العدادات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("Error fetching counters: $e");
    } finally {
      looading.value = false;
    }
  }

  // Add new counter
  Future<void> addCounter(ElectricMeter counter) async {
    try {
      final response = await postData(
        "http://$ip/new-station",
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
      showCustomErrorDialog(errorMessage: 'فشل الاتصال بالسيرفر');
      debugPrint("Error adding counter: $e");
    }
  }

  // Refresh data
  Future<void> refresh() async {
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    filteredCounters.clear();
    await fetchAllCounters();
  }

  // Get display list (filtered or all)
  List<ElectricMeter> get displayCounters {
    return filteredCounters.isNotEmpty || searchController.text.isNotEmpty
        ? filteredCounters
        : allcounter;
  }
}