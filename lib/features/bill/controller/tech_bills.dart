import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';

class TechBillscontroller extends GetxController {
  List<TechnologyBill> bills = [];
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Pagination
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 20;
  int totalItems = 0;
  bool hasNext = false;
  bool hasPrev = false;

  // Filter properties
  String selectedYear = 'all';
  String selectedMonth = 'all';
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Setup debounce worker for smooth searching
    debounce(searchQuery, (_) {
      currentPage = 1;
      allbills();
    }, time: const Duration(milliseconds: 500));

    allbills();
  }

  Future<void> allbills() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      bills = [];

      Map<String, String> queryParams = {
        'page': currentPage.toString(),
        'per_page': perPage.toString(),
      };

      if (selectedYear != 'all') queryParams['bill_year'] = selectedYear;
      if (selectedMonth != 'all') queryParams['bill_month'] = selectedMonth;
      if (searchQuery.value.isNotEmpty) queryParams['search'] = searchQuery.value;

      final uri = Uri.parse("${ApiConfig.baseUrl}/view-tech-bills").replace(queryParameters: queryParams);
      final res = await fetchData(uri.toString());

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        if (jsonData is Map && jsonData.containsKey('data')) {
          bills = (jsonData['data'] as List).map((bill) => TechnologyBill.fromJson(bill)).toList();
          
          if (jsonData.containsKey('meta')) {
            final meta = jsonData['meta'];
            currentPage = meta['page'] ?? 1;
            totalPages = meta['total_pages'] ?? 1;
            totalItems = meta['total'] ?? bills.length;
            hasNext = meta['has_next'] ?? false;
            hasPrev = meta['has_prev'] ?? false;
          }
        }
        update();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Pagination methods
  void nextPage() {
    if (hasNext) {
      currentPage++;
      allbills();
    }
  }

  void previousPage() {
    if (hasPrev) {
      currentPage--;
      allbills();
    }
  }

  // Get filtered bills (now directly returns bills since filtering is server-side)
  List<TechnologyBill> getFilteredBills() {
    return bills;
  }

  // Get unique years (hardcoded since server handles filtering)
  List<String> getUniqueYears() {
    int currentYear = DateTime.now().year;
    List<String> years = [];
    for (int i = currentYear; i >= 2020; i--) {
      years.add(i.toString());
    }
    return years;
  }

  // Get unique months
  List<String> getUniqueMonths() {
    return List.generate(12, (index) => (index + 1).toString());
  }

  // Filter by year
  void filterByYear(String year) {
    selectedYear = year;
    currentPage = 1;
    allbills();
  }

  // Filter by month
  void filterByMonth(String month) {
    selectedMonth = month;
    currentPage = 1;
    allbills();
  }

  // Reset all filters
  void resetFilters() {
    selectedYear = 'all';
    selectedMonth = 'all';
    searchQuery.value = '';
    currentPage = 1;
    allbills();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    // UI update is handled by the debounce worker!
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

  // Calculate total power consumption for filtered bills
  num getTotalPowerConsumption() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + bill.technologyPowerConsump);
  }

  // Calculate total bill amount for filtered bills
  num getTotalBillAmount() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + (num.tryParse(bill.technologyBillTotal) ?? 0));
  }

  // Calculate total water amount
  num getTotalWaterAmount() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + (bill.technologyWaterAmount ?? 0));
  }

  // Calculate total chlorine consumption
  num getTotalChlorineConsumption() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + (bill.technologyChlorineConsump ?? 0));
  }

  // Calculate total solid alum consumption
  num getTotalSolidAlumConsumption() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + (bill.technologySolidAlumConsump ?? 0));
  }

  // Calculate total liquid alum consumption
  num getTotalLiquidAlumConsumption() {
    List<TechnologyBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + (bill.technologyLiquidAlumConsump ?? 0));
  }

  // Get average power consumption
  num getAveragePowerConsumption() {
    List<TechnologyBill> filtered = getFilteredBills();
    if (filtered.isEmpty) return 0;
    return getTotalPowerConsumption() / filtered.length;
  }

  // Get average bill amount
  num getAverageBillAmount() {
    List<TechnologyBill> filtered = getFilteredBills();
    if (filtered.isEmpty) return 0;
    return getTotalBillAmount() / filtered.length;
  }

  // Get bills by year
  List<TechnologyBill> getBillsByYear(int year) {
    return bills.where((bill) => bill.billYear == year).toList();
  }

  // Get bills by month and year
  List<TechnologyBill> getBillsByMonthAndYear(int month, int year) {
    return bills
        .where((bill) => bill.billMonth == month && bill.billYear == year)
        .toList();
  }

  // Get bills by station name
  List<TechnologyBill> getBillsByStationName(String stationName) {
    return bills.where((bill) => bill.stationName == stationName).toList();
  }

  // Get bills by technology name
  List<TechnologyBill> getBillsByTechnologyName(String technologyName) {
    return bills.where((bill) => bill.technologyName == technologyName).toList();
  }

  // Refresh bills data
  Future<void> refreshBills() async {
    await allbills();
  }
}