import 'package:power_saving/core/utils/owned_debounce.dart';
import 'package:power_saving/core/utils/request_guard.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class TechnlogyController extends GetxController {
  final _requests = RequestGuard();
  final loadError = ''.obs;
  final isRefreshing = false.obs;

  RxBool looading = false.obs;
  RxBool isLoading = false.obs;



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

  final TextEditingController name = TextEditingController();
  final TextEditingController chlorine = TextEditingController();
  final TextEditingController liquid = TextEditingController();
  final TextEditingController solid = TextEditingController();
  final TextEditingController power = TextEditingController();

  @override
  void onInit() {
    alltechnology();

    // Setup search listener with debounce
    _searchWorker = ownedDebounce(
      _searchQuery,
      (query) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  @override
  void onClose() {
    _requests.close();
    _searchWorker?.dispose();
    searchController.dispose();
    name.dispose();
    chlorine.dispose();
    liquid.dispose();
    solid.dispose();
    power.dispose();
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

  Future<void> alltechnology({bool isBackground = false, bool force = false}) async {
    final request = _requests.begin();
    if (!request.isCurrent) return;
    loadError.value = '';
    isLoading.value = !isBackground;
    isRefreshing.value = !isLoading.value;
    update();
    try {

      final res = await fetchData("${ApiConfig.baseUrl}/technologies",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (res.statusCode != 200) throw StateError('تعذر تحميل البيانات');
      final List<dynamic> responseData = jsonDecode(res.body);
      final parsed = responseData.map((e) => TechnologyModel.fromJson(e)).toList();

      all_technology.clear();
      all_technology.addAll(parsed);

      _applyFilters();
    } catch (e) {
      if (!request.isCurrent) return;
      loadError.value = 'تعذر تحديث البيانات. يرجى إعادة المحاولة.';
    } finally {
      if (request.isCurrent) {
        isLoading.value = false;
        isRefreshing.value = false;
        update();
      }
    }
  }

  Future<void> forceRefresh() async {
    await alltechnology(force: true);
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
