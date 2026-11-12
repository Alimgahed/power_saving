import 'package:power_saving/core/utils/owned_debounce.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/network/network.dart';

class Chemacialcontroller extends GetxController {
  final _requests = RequestGuard();
  final loadError = ''.obs;
  final isRefreshing = false.obs;

  // Observable states
  final loading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;

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
    _requests.close();
    _searchWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  // -------------------------------
  // Search Worker (Debounce)
  // -------------------------------
  void _setupSearchWorker() {
    _searchWorker = ownedDebounce(
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
  Future<void> getchemicals({bool isBackground = false, bool force = false}) async {
    final request = _requests.begin();
    if (!request.isCurrent) return;
    loadError.value = '';
    loading.value = !isBackground;
    isRefreshing.value = !loading.value;
    update();
    try {

      final res = await fetchData("${ApiConfig.baseUrl}/chemicals",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (res.statusCode != 200) throw StateError('تعذر تحميل البيانات');
      final List<dynamic> responseData = jsonDecode(res.body);
      final parsed = responseData.map((e) => AlumChlorineReference.fromJson(e)).toList();

      allChemicals.clear();
      allChemicals.addAll(parsed);
      _performSearch(_searchQuery.value);
    } catch (e) {
      if (!request.isCurrent) return;
      loadError.value = 'تعذر تحديث البيانات. يرجى إعادة المحاولة.';
    } finally {
      if (request.isCurrent) {
        loading.value = false;
        isRefreshing.value = false;
        update();
      }
    }
  }

  Future<void> forceRefresh() async {
    await getchemicals(force: true);
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
