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

  /// SEARCH
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    startdate = TextEditingController();
    enddate = TextEditingController();

    // Listen to text changes with debounce
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    startdate.dispose();
    enddate.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // ================== SEARCH DEBOUNCE ==================
  void _onSearchChanged() {
    _debounceTimer?.cancel();
    
    // Show searching indicator
    if (searchController.text.isNotEmpty) {
      isSearching.value = true;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(searchController.text);
      isSearching.value = false;
    });
  }

  // ================== CLEAR SEARCH ==================
  void clearSearch() {
    searchController.clear();
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

  // ================== OPTIMIZED SEARCH ======================
  void _performSearch(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      filteredBranchs.value = List.from(branchs);
    } else {
      // Multi-field search using precomputed index
      filteredBranchs.value = _index
          .where((e) {
            // Search in branch name, station name, and other relevant fields
            return e.branchLower.contains(q) || 
                   e.stationLower.contains(q);
          })
          .map((e) => e.branch)
          .toList();
    }

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
      );
    }).toList();
  }
}

// ================== SEARCH INDEX CLASS ==================
class _BranchIndex {
  final ReportBranch branch;
  final String branchLower;
  final String stationLower;

  _BranchIndex({
    required this.branch,
    required this.branchLower,
    required this.stationLower,
  });
}