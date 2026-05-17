import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/bill/model/bills_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/network/network.dart';

class AllBills extends GetxController {
  // Data storage - separated for performance
  final List<GuageBill> _allBills = [];  // Master data (non-observable)
  final bills = <GuageBill>[].obs;  // Display data (observable)
  
  // Observable states
  final isLoading = false.obs;
  final isSearching = false.obs;
  final searchError = ''.obs;
  final errorMessage = ''.obs;
  
  // Search management
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;
  Worker? _searchWorker;
  
  // Filter properties
  String selectedFilter = 'all';
  String selectedYear = 'all';
  String selectedMonth = 'all';
  String selectedAccountNumber = 'all';

  @override
  void onInit() {
    super.onInit();
    allbills();
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

  Future<void> allbills() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await fetchData("${ApiConfig.baseUrl}/view-bills");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        if (jsonData is List) {
          // Clear and populate master list
          _allBills.clear();
          _allBills.addAll(
            jsonData.map((bill) => GuageBill.fromJson(bill)).toList()
          );
          
          // Sort by year and month descending (newest first)
          _allBills.sort((a, b) {
            if (a.billYear != b.billYear) {
              return b.billYear.compareTo(a.billYear);
            }
            return b.billMonth.compareTo(a.billMonth);
          });

          // Update display list
          bills.value = List.from(_allBills);
        }
      }
    } catch (e) {
      errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    
    if (!isSearching.value) {
      // Clear search state
      searchController.clear();
      _searchQuery.value = '';
      searchError.value = '';
      bills.value = List.from(_allBills);
    }
  }

  // Perform the actual search (called after debounce)
  void _performSearch(String query) {
    if (query.isEmpty) {
      bills.value = List.from(_allBills);
      searchError.value = '';
      return;
    }

    final lowerQuery = query.toLowerCase();
    
    // Apply search on all bills
    final searchResults = _allBills.where((bill) {
      final accountNumber = bill.accountNumber.toLowerCase();
      final monthName = getMonthName(bill.billMonth).toLowerCase();
      final year = bill.billYear.toString();
      final total = bill.billTotal.toString();
      final consumption = bill.powerConsump.toString();
      
      return accountNumber.contains(lowerQuery) ||
             monthName.contains(lowerQuery) ||
             year.contains(lowerQuery) ||
             total.contains(lowerQuery) ||
             consumption.contains(lowerQuery);
    }).toList();

    // Update results
    if (searchResults.isEmpty) {
      searchError.value = 'لا توجد نتائج تطابق "$query"';
      bills.value = [];
    } else {
      searchError.value = '';
      bills.value = searchResults;
    }
  }

  // Get filtered bills (for external use)
  List<GuageBill> getFilteredBills() {
    return bills;
  }

  // Get month name in Arabic
  String getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return 'غير معروف';
  }

  // Calculate total power consumption for displayed bills
  num getTotalPowerConsumption() {
    return bills.fold(0, (sum, bill) => sum + bill.powerConsump);
  }

  // Calculate total bill amount for displayed bills
  num getTotalBillAmount() {
    return bills.fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get count of paid bills
  int getPaidBillsCount() {
    return bills.where((bill) => bill.isPaid == true).length;
  }

  // Get count of unpaid bills
  int getUnpaidBillsCount() {
    return bills.where((bill) => bill.isPaid == false || bill.isPaid == null).length;
  }

  // Get total amount of paid bills
  num getPaidBillsTotal() {
    return bills
        .where((bill) => bill.isPaid == true)
        .fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get total amount of unpaid bills
  num getUnpaidBillsTotal() {
    return bills
        .where((bill) => bill.isPaid == false || bill.isPaid == null)
        .fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get average power consumption
  num getAveragePowerConsumption() {
    if (bills.isEmpty) return 0;
    return getTotalPowerConsumption() / bills.length;
  }

  // Get average bill amount
  num getAverageBillAmount() {
    if (bills.isEmpty) return 0;
    return getTotalBillAmount() / bills.length;
  }

  // Refresh bills data
  Future<void> refresh() async {
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    await allbills();
  }
}