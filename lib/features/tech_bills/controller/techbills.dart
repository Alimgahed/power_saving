import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/gloable/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Techbills extends GetxController {
  RxBool loading = false.obs;
  final Map<int, GlobalKey<FormState>> formKeys = {};
  
  GlobalKey<FormState> getFormKey(int index) {
    return formKeys.putIfAbsent(index, () => GlobalKey<FormState>());
  }

  RxnInt loadingIndex = RxnInt();
  RxList<TechnologyBill> techBills = <TechnologyBill>[].obs;
  RxList<TechnologyBill> filteredTechBills = <TechnologyBill>[].obs;
  
  // Search functionality
  RxBool isSearching = false.obs;
  final searchController = TextEditingController();
  RxString searchError = ''.obs;
  Worker? _searchWorker;
  Timer? _debounceTimer;
  
  // Filter properties
  RxnString selectedBranch = RxnString();
  RxnString selectedStation = RxnString();
  final stationFilterController = TextEditingController();
  
  // Lists for filter dropdowns
  List<String> get branches {
    return techBills
        .map((bill) => bill.branch ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }
  
  List<String> get stations {
    return techBills
        .map((bill) => bill.stationName)
        .toSet()
        .toList()
      ..sort();
  }

  // Create maps of TextEditingControllers per bill (by index)
  final chlorineControllers = <int, TextEditingController>{};
  final liquidAlumControllers = <int, TextEditingController>{};
  final solidAlumControllers = <int, TextEditingController>{};
  final waterProducedControllers = <int, TextEditingController>{};

  TextEditingController getChlorineController(int index) {
    return chlorineControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getLiquidAlumController(int index) {
    return liquidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getSolidAlumController(int index) {
    return solidAlumControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  TextEditingController getWaterProducedController(int index) {
    return waterProducedControllers.putIfAbsent(
      index,
      () => TextEditingController(),
    );
  }

  @override
  void onClose() {
    // Dispose all controllers
    _searchWorker?.dispose();
    _debounceTimer?.cancel();
    searchController.dispose();
    stationFilterController.dispose();
    
    for (var controller in [
      ...chlorineControllers.values,
      ...liquidAlumControllers.values,
      ...solidAlumControllers.values,
      ...waterProducedControllers.values,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }

  @override
  void onInit() {
    fetchTechBills();
    _setupSearchWorker();
    super.onInit();
  }

  // Setup search worker with debounce
  void _setupSearchWorker() {
    _searchWorker = ever(searchController.obs, (_) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        applyFilters();
      });
    });
  }

  // Search functionality
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      searchError.value = '';
      applyFilters();
    }
  }

  void onSearchChanged(String value) {
    // This will trigger the worker
    searchController.text = value;
  }

  // Filter methods
  void filterByBranch(String? branch) {
    selectedBranch.value = branch;
    applyFilters();
  }

  void filterByStation(String? station) {
    selectedStation.value = station;
    applyFilters();
  }

  void clearFilters() {
    selectedBranch.value = null;
    selectedStation.value = null;
    stationFilterController.clear();
    searchController.clear();
    searchError.value = '';
    applyFilters();
  }

  void applyFilters() {
    final searchQuery = searchController.text.trim().toLowerCase();
    
    filteredTechBills.value = techBills.where((bill) {
      // Text search filter
      bool matchesSearch = searchQuery.isEmpty ||
          bill.stationName.toLowerCase().contains(searchQuery) ||
          bill.technologyName.toLowerCase().contains(searchQuery) ||
          (bill.branch?.toLowerCase().contains(searchQuery) ?? false) ||
          bill.billYear.toString().contains(searchQuery) ||
          bill.billMonth.toString().contains(searchQuery);
      
      // Branch filter
      bool matchesBranch = selectedBranch.value == null ||
          bill.branch == selectedBranch.value;
      
      // Station filter - now searches within station name
      bool matchesStation = selectedStation.value == null ||
          bill.stationName.toLowerCase().contains(selectedStation.value!.toLowerCase());
      
      return matchesSearch && matchesBranch && matchesStation;
    }).toList();

    // Set search error if no results
    if (searchQuery.isNotEmpty && filteredTechBills.isEmpty) {
      searchError.value = 'لم يتم العثور على نتائج تطابق "$searchQuery"';
    } else {
      searchError.value = '';
    }
  }

  // Fetch tech bills data
  void fetchTechBills() async {
    try {
      loading.value = true;
      techBills.clear();
      final res = await fetchData("${ApiConfig.baseUrl}/tech-bills");

      if (res.statusCode == 200) {
        loading.value = false;
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;
        for (var i in responseData) {
          TechnologyBill technologyBill = TechnologyBill.fromJson(i);
          techBills.add(technologyBill);
        }
        applyFilters();
        update();
      }
    } catch (e) {
      loading.value = false;
      print("Error fetching tech bills: $e");
    }
  }

  void addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index,
  }) async {
    try {
      loading.value = true;
      loadingIndex.value = index;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      );

      if (res.statusCode == 200) {
        loading.value = false;
        fetchTechBills();
        showSuccessToast("تمت الإضافة بنجاح");

        // Clear input fields after successful submission
        getChlorineController(index).clear();
        getLiquidAlumController(index).clear();
        getSolidAlumController(index).clear();
        getWaterProducedController(index).clear();
      } else {
        loading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      loading.value = false;
      print("Error during bill submission: $e");
    } finally {
      loadingIndex.value = null;
    }
  }
}