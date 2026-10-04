import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/bill/model/bills_model.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class AllBills extends GetxController {
  static Map<String, dynamic>? sessionCache;
  // Data storage - separated for performance
  final List<GuageBill> _allBills = [];  // Master data (non-observable)
  final bills = <GuageBill>[].obs;  // Display data (observable)
  

  // Pagination state
  RxInt currentPage = 1.obs;
  RxInt perPage = 20.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxBool hasPrev = false.obs;

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

  void nextPage() {
    if (hasNext.value) {
      currentPage.value++;
      allbills();
    }
  }

  void prevPage() {
    if (hasPrev.value) {
      currentPage.value--;
      allbills();
    }
  }

  Future<void> allbills({bool isBackground = false}) async {
    final bool isDefaultState = currentPage.value == 1 &&
        _searchQuery.value.trim().isEmpty &&
        selectedYear == 'all' &&
        selectedMonth == 'all' &&
        selectedFilter == 'all' &&
        (selectedAccountNumber == 'all' || selectedAccountNumber.isEmpty);

    if (!isBackground && isDefaultState && sessionCache != null) {
      // Restore from cache instantly
      final jsonData = sessionCache!;
      _allBills.clear();
      bills.clear();

      if (jsonData.containsKey('data')) {
        List<dynamic> responseData = jsonData['data'];
        _allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
        
        if (jsonData.containsKey('meta')) {
          final meta = jsonData['meta'];
          currentPage.value = meta['page'] ?? 1;
          perPage.value = meta['per_page'] ?? 20;
          totalItems.value = meta['total'] ?? 0;
          totalPages.value = meta['total_pages'] ?? 1;
          hasNext.value = meta['has_next'] ?? false;
          hasPrev.value = meta['has_prev'] ?? false;
        }
      }

      bills.value = List.from(_allBills);
      searchError.value = '';

      // Trigger silent background refresh
      _fetchLatestBackground();
      return;
    }

    try {
      if (!isBackground) {
        isLoading.value = true;
      }
      errorMessage.value = '';

      Map<String, String> queryParams = {
        'page': currentPage.value.toString(),
        'per_page': perPage.value.toString(),
      };

      if (_searchQuery.value.isNotEmpty) {
        queryParams['search'] = _searchQuery.value.trim();
      }

      if (selectedYear != 'all') {
        queryParams['bill_year'] = selectedYear;
      }
      
      if (selectedMonth != 'all') {
        queryParams['bill_month'] = selectedMonth;
      }
      
      if (selectedFilter != 'all') {
        queryParams['is_paid'] = selectedFilter == 'paid' ? 'true' : 'false';
      }

      if (selectedAccountNumber != 'all' && selectedAccountNumber.isNotEmpty) {
        queryParams['account_number'] = selectedAccountNumber;
      }

      Uri uri = Uri.parse("${ApiConfig.baseUrl}/view-bills").replace(queryParameters: queryParams);
      final res = await fetchData(uri.toString());

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        if (isDefaultState) {
          sessionCache = jsonData;
        }

        _allBills.clear();
        bills.clear();

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          List<dynamic> responseData = jsonData['data'];
          _allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
          
          if (jsonData.containsKey('meta')) {
            final meta = jsonData['meta'];
            currentPage.value = meta['page'] ?? 1;
            perPage.value = meta['per_page'] ?? 20;
            totalItems.value = meta['total'] ?? 0;
            totalPages.value = meta['total_pages'] ?? 1;
            hasNext.value = meta['has_next'] ?? false;
            hasPrev.value = meta['has_prev'] ?? false;
          }
        } else if (jsonData is List) {
          _allBills.addAll(jsonData.map((bill) => GuageBill.fromJson(bill)).toList());
          totalItems.value = _allBills.length;
          totalPages.value = 1;
          hasNext.value = false;
          hasPrev.value = false;
        }

        bills.value = List.from(_allBills);
        
        if (bills.isEmpty && _searchQuery.value.isNotEmpty) {
           searchError.value = 'لا توجد نتائج تطابق "${_searchQuery.value}"';
        } else {
           searchError.value = '';
        }
      } else if (!isBackground) {
        errorMessage.value = 'فشل تحميل الفواتير: ${res.statusCode}';
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
      }
    } finally {
      if (!isBackground) {
        isLoading.value = false;
      }
    }
  }

  Future<void> _fetchLatestBackground() async {
    allbills(isBackground: true);
  }

  // Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    
    if (!isSearching.value) {
      // Clear search state
      searchController.clear();
      searchError.value = '';
      if (_searchQuery.value.isNotEmpty) {
        _searchQuery.value = '';
        currentPage.value = 1;
        allbills();
      }
    }
  }

  // Perform the actual search (called after debounce)
  void _performSearch(String query) {
    currentPage.value = 1;
    allbills();
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
  @override
  Future<void> refresh() async {
    sessionCache = null;
    searchController.clear();
    _searchQuery.value = '';
    searchError.value = '';
    currentPage.value = 1;
    selectedYear = 'all';
    selectedMonth = 'all';
    selectedFilter = 'all';
    selectedAccountNumber = 'all';
    isLoading.value = true;
    await allbills(isBackground: false);
  }
}
