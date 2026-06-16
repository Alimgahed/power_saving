import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/network/network.dart';

class ReportsController extends GetxController {
  double watersum = 0;
  double powersum = 0;
  double moneysum = 0;

  String? reportname;

  /// ORIGINAL DATA
  List<ReportBranch> branchs = [];

  /// FILTERED DATA (USED BY TABLE)
  RxList<ReportBranch> filteredBranchs = <ReportBranch>[].obs;

  /// Precomputed lowercase index for fast, smooth search
  List<_BranchIndex> _index = [];

  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;

  late TextEditingController startdate;
  late TextEditingController enddate;

  /// SEARCH AND FILTERS
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  Worker? _searchWorker;

  /// DROPDOWN FILTERS
  RxnString selectedFilterBranch = RxnString(null);
  RxnString selectedFilterStation = RxnString(null);
  RxnString selectedFilterMonth = RxnString(null);
  RxnString selectedFilterTech = RxnString(null);

  List<String> get availableBranches => ["الكل", ...branchs.map((e) => e.branchName).where((e) => e.isNotEmpty).toSet()];
  List<String> get availableStations => ["الكل", ...branchs.map((e) => e.stationname ?? "").where((e) => e.isNotEmpty).toSet()];
  List<String> get availableMonths => ["الكل", ...branchs.map((e) => e.month.toString()).toSet()];
  List<String> get availableTechs => ["الكل", ...branchs.map((e) => e.techname ?? "").where((e) => e.isNotEmpty).toSet()];

  @override
  void onInit() {
    super.onInit();
    startdate = TextEditingController();
    enddate = TextEditingController();

    _searchWorker = debounce(
      searchQuery,
      (_) {
        applyFilters();
        isSearching.value = false;
      },
      time: const Duration(milliseconds: 300),
    );

    everAll([
      selectedFilterBranch,
      selectedFilterStation,
      selectedFilterMonth,
      selectedFilterTech,
    ], (_) {
      applyFilters();
    });

    // Listen to text changes
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    startdate.dispose();
    enddate.dispose();
    searchController.dispose();
    _searchWorker?.dispose();
    super.onClose();
  }

  // ================== SEARCH DEBOUNCE ==================
  void _onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      isSearching.value = true;
    }
    searchQuery.value = searchController.text;
  }

  // ================== CLEAR SEARCH ==================
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    selectedFilterBranch.value = null;
    selectedFilterStation.value = null;
    selectedFilterMonth.value = null;
    selectedFilterTech.value = null;
    filteredBranchs.value = List.from(branchs);
    sumvalueofreport(filteredBranchs);
  }

  // ================== SUM VALUES ==================
  void sumvalueofreport(List<ReportBranch> list) {
    watersum = 0;
    powersum = 0;
    moneysum = 0;

    for (var i in list) {
      watersum += i.totalWater;
      powersum += i.totalPower;
      moneysum += i.totalBill;
    }
  }

  // ================== OPTIMIZED SEARCH & FILTER ======================
  void applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();

    var result = branchs.where((b) {
      bool matchesBranch = selectedFilterBranch.value == null || selectedFilterBranch.value == "الكل" || b.branchName == selectedFilterBranch.value;
      bool matchesStation = selectedFilterStation.value == null || selectedFilterStation.value == "الكل" || b.stationname == selectedFilterStation.value;
      bool matchesMonth = selectedFilterMonth.value == null || selectedFilterMonth.value == "الكل" || b.month.toString() == selectedFilterMonth.value;
      bool matchesTech = selectedFilterTech.value == null || selectedFilterTech.value == "الكل" || b.techname == selectedFilterTech.value;

      return matchesBranch && matchesStation && matchesMonth && matchesTech;
    }).toList();

    if (q.isNotEmpty) {
      result = result.where((b) {
        return b.branchName.toLowerCase().contains(q) ||
               (b.stationname ?? '').toLowerCase().contains(q) ||
               b.month.toString().contains(q) ||
               b.year.toString().contains(q) ||
               (b.techname ?? '').toLowerCase().contains(q);
      }).toList();
    }

    filteredBranchs.value = result;

    sumvalueofreport(filteredBranchs);
  }

  // ================== API CALL ====================
  Future<void> getReports({
    required String start,
    required String end,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      update();

      branchs.clear();
      filteredBranchs.clear();
      _index.clear();
      clearSearch(); // Clear any existing search

      final res = await postData(
        "${ApiConfig.baseUrl}/reports",
        {
          "report_name": name,
          "from_date": start,
          "to_date": end,
        },
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        List<dynamic> responseData;
        if (jsonData is List) {
          responseData = jsonData;
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          responseData = jsonData['data'] ?? [];
        } else {
          responseData = [];
        }

        for (var i in responseData) {
          try {
            branchs.add(ReportBranch.fromJson(i));
          } catch (e) {
            debugPrint("Parsing error: $e");
          }
        }

        // Set filtered data
        filteredBranchs.value = List.from(branchs);

        // Build optimized search index
        _buildSearchIndex();

        sumvalueofreport(filteredBranchs);
      }

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      debugPrint("Error fetching reports: $e");
    }
  }

  // ================== BUILD SEARCH INDEX ==================
  void _buildSearchIndex() {
    _index = branchs.map((b) {
      return _BranchIndex(
        branch: b,
        branchLower: b.branchName.toLowerCase(),
        stationLower: (b.stationname ?? '').toLowerCase(),
        monthStr: b.month.toString(),
        yearStr: b.year.toString(),
      );
    }).toList();
  }
}

// ================== SEARCH INDEX CLASS ==================
class _BranchIndex {
  final ReportBranch branch;
  final String branchLower;
  final String stationLower;
  final String monthStr;
  final String yearStr;

  _BranchIndex({
    required this.branch,
    required this.branchLower,
    required this.stationLower,
    required this.monthStr,
    required this.yearStr,
  });
}