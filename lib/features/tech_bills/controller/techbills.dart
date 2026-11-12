import 'dart:async';
import 'dart:convert';
import 'package:power_saving/core/utils/request_guard.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class Techbills extends GetxController {
  final _reads = RequestGuard();
  final _saves = RequestGuard();

  List<Map<int, TextEditingController>> get _draftMaps => [
    chlorineControllers, liquidAlumControllers, solidAlumControllers,
    waterProducedControllers, calculatedWaterControllers, measuredWaterControllers,
  ];

  void _applyBills(List<TechnologyBill> updated) {
    final ids = updated.map((bill) => bill.techBillId).toSet();
    for (final drafts in _draftMaps) {
      for (final id in drafts.keys.where((id) => !ids.contains(id)).toList()) {
        drafts.remove(id)!.dispose();
      }
    }
    formKeys.removeWhere((id, _) => !ids.contains(id));
    techBills.assignAll(updated);
    applyFilters();
  }

  RxBool loading = false.obs;
  final Map<int, GlobalKey<FormState>> formKeys = {};

  GlobalKey<FormState> getFormKey(int billId) {
    return formKeys.putIfAbsent(billId, () => GlobalKey<FormState>());
  }

  RxnInt loadingBillId = RxnInt();
  RxList<TechnologyBill> techBills = <TechnologyBill>[].obs;
  RxList<TechnologyBill> filteredTechBills = <TechnologyBill>[].obs;

  // Search functionality
  RxBool isSearching = false.obs;
  final searchController = TextEditingController();
  RxString searchError = ''.obs;
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

  // Create maps of TextEditingControllers per bill (by stable techBillId)
  final chlorineControllers = <int, TextEditingController>{};
  final liquidAlumControllers = <int, TextEditingController>{};
  final solidAlumControllers = <int, TextEditingController>{};
  final waterProducedControllers = <int, TextEditingController>{};
  final calculatedWaterControllers = <int, TextEditingController>{};
  final measuredWaterControllers = <int, TextEditingController>{};

    TextEditingController getcalculatedWaterControllers(int billId) {
      return calculatedWaterControllers.putIfAbsent(
        billId,
        () => TextEditingController(),
      );
    } 
     TextEditingController getmeasuredWaterControllers(int billId) {
      return measuredWaterControllers.putIfAbsent(
        billId,
        () => TextEditingController(),
      );
    } 
  TextEditingController getChlorineController(int billId) {
    return chlorineControllers.putIfAbsent(
      billId,
      () => TextEditingController(),
    );
  }

  TextEditingController getLiquidAlumController(int billId) {
    return liquidAlumControllers.putIfAbsent(
      billId,
      () => TextEditingController(),
    );
  }

  TextEditingController getSolidAlumController(int billId) {
    return solidAlumControllers.putIfAbsent(
      billId,
      () => TextEditingController(),
    );
  }

  TextEditingController getWaterProducedController(int billId) {
    return waterProducedControllers.putIfAbsent(
      billId,
      () => TextEditingController(),
    );
  }

  @override
  void onClose() {
    _reads.close();
    _saves.close();
    // Dispose all controllers
    searchController.removeListener(_onSearchEdited);
    _debounceTimer?.cancel();
    searchController.dispose();
    stationFilterController.dispose();


    for (var controller in [
      ...chlorineControllers.values,
      ...liquidAlumControllers.values,
      ...solidAlumControllers.values,
      ...waterProducedControllers.values,
      ...calculatedWaterControllers.values,
      ...measuredWaterControllers.values,
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
    searchController.addListener(_onSearchEdited);
  }

  void _onSearchEdited() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), applyFilters);
  }

  // The text controller already contains the user's edit; do not reset selection.
  void onSearchChanged(String value) {
    _onSearchEdited();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      searchError.value = '';
      applyFilters();
    }
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

  Future<void> fetchTechBills({bool isBackground = false}) async {
    final request = _reads.begin();
    if (!request.isCurrent) return;

    try {
      if (!isBackground) loading.value = true;
      final res = await fetchData("${ApiConfig.baseUrl}/tech-bills",
          isCurrent: () => request.isCurrent);
      if (!request.isCurrent) return;
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final updated = <TechnologyBill>[];
        for (var i in jsonData) {
          updated.add(TechnologyBill.fromJson(i));
        }

        _applyBills(updated);
      }
    } catch (e) {
      if (!request.isCurrent) return;
      if (!isBackground) showCustomErrorDialog(errorMessage: e.toString());
      print("Error fetching tech bills: $e");
    } finally {
      if (request.isCurrent) loading.value = false;
    }
  }

  Future<void> refreshData() async {

    searchController.clear();
    stationFilterController.clear();
    selectedBranch.value = null;
    selectedStation.value = null;
    await fetchTechBills(isBackground: false);
  }

  Future<void> addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required double calculatedWater,
    required double measuredWater,
  }) async {
    final request = _saves.begin();
    if (!request.isCurrent) return;
    _reads.invalidate();
    final submittedDrafts = {
      for (final drafts in _draftMaps)
        if (drafts[id] != null) drafts[id]!: drafts[id]!.text,
    };
    try {
      loading.value = true;
      loadingBillId.value = id;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
          "measured_water": measuredWater,
          "calculated_water": calculatedWater,
        },
        isCurrent: () => request.isCurrent,
      );
      if (!request.isCurrent) return;

      if (res.statusCode == 200) {
        loading.value = false;

        fetchTechBills(isBackground: true);
        showSuccessToast("تمت الإضافة بنجاح");

        // Do not recreate a removed draft or erase edits made after submission.
        for (final drafts in _draftMaps) {
          final field = drafts[id];
          if (field != null && submittedDrafts[field] == field.text) {
            field.clear();
          }
        }
      } else {
        loading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      if (!request.isCurrent) return;
      showCustomErrorDialog(errorMessage: e.toString());
      loading.value = false;
      print("Error during bill submission: $e");
    } finally {
      if (request.isCurrent) loadingBillId.value = null;
    }
  }
}