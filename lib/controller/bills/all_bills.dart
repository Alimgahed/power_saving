import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/bills_model.dart';
import 'package:power_saving/network/network.dart';

class AllBills extends GetxController {
  List<GuageBill> bills = [];
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Filter properties
  String selectedFilter = 'all';
  String selectedYear = 'all';
  String selectedMonth = 'all';
  String selectedAccountNumber = 'all';

  @override
  void onInit() {
    super.onInit();
    allbills();
  }

  Future<void> allbills() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      bills = [];

      final res = await fetchData("http://$ip/view-bills");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        // Check if response is a list
        if (jsonData is List) {
          bills = jsonData.map((bill) => GuageBill.fromJson(bill)).toList();
          
          // Sort by year and month descending (newest first)
          bills.sort((a, b) {
            if (a.billYear != b.billYear) {
              return b.billYear.compareTo(a.billYear);
            }
            return b.billMonth.compareTo(a.billMonth);
          });
        }
        update();
      }
    } catch (e) {
      errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Get filtered bills
  List<GuageBill> getFilteredBills() {
    List<GuageBill> filtered = bills;

    if (selectedYear != 'all') {
      filtered = filtered.where((bill) => bill.billYear.toString() == selectedYear).toList();
    }

    if (selectedMonth != 'all') {
      filtered = filtered.where((bill) => bill.billMonth.toString() == selectedMonth).toList();
    }

    if (selectedAccountNumber != 'all') {
      filtered = filtered.where((bill) => bill.accountNumber == selectedAccountNumber).toList();
    }

    return filtered;
  }

  // Get unique years from bills
  List<String> getUniqueYears() {
    Set<String> years = bills.map((bill) => bill.billYear.toString()).toSet();
    List<String> yearsList = years.toList();
    yearsList.sort((a, b) => b.compareTo(a)); // Sort descending
    return yearsList;
  }

  // Get unique months from bills
  List<String> getUniqueMonths() {
    Set<String> months = bills.map((bill) => bill.billMonth.toString()).toSet();
    List<String> monthsList = months.toList();
    monthsList.sort((a, b) => int.parse(a).compareTo(int.parse(b))); // Sort ascending
    return monthsList;
  }

  // Get unique account numbers from bills
  List<String> getUniqueAccountNumbers() {
    Set<String> accounts = bills.map((bill) => bill.accountNumber).toSet();
    List<String> accountsList = accounts.toList();
    accountsList.sort(); // Sort alphabetically
    return accountsList;
  }

  // Filter by year
  void filterByYear(String year) {
    selectedYear = year;
    update();
  }

  // Filter by month
  void filterByMonth(String month) {
    selectedMonth = month;
    update();
  }

  // Filter by account number
  void filterByAccountNumber(String accountNumber) {
    selectedAccountNumber = accountNumber;
    update();
  }

  // Reset all filters
  void resetFilters() {
    selectedYear = 'all';
    selectedMonth = 'all';
    selectedAccountNumber = 'all';
    update();
  }

  // Get month name in Arabic
  String getMonthName(int month) {
    const months = [
      'يناير',    // January
      'فبراير',   // February
      'مارس',     // March
      'أبريل',    // April
      'مايو',     // May
      'يونيو',    // June
      'يوليو',    // July
      'أغسطس',    // August
      'سبتمبر',   // September
      'أكتوبر',   // October
      'نوفمبر',   // November
      'ديسمبر'    // December
    ];
    
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return 'غير معروف';
  }

  // Calculate total power consumption for filtered bills
  num getTotalPowerConsumption() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + bill.powerConsump);
  }

  // Calculate total bill amount for filtered bills
  num getTotalBillAmount() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered.fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get count of paid bills
  int getPaidBillsCount() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered.where((bill) => bill.isPaid == true).length;
  }

  // Get count of unpaid bills
  int getUnpaidBillsCount() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered.where((bill) => bill.isPaid == false || bill.isPaid == null).length;
  }

  // Get total amount of paid bills
  num getPaidBillsTotal() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered
        .where((bill) => bill.isPaid == true)
        .fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get total amount of unpaid bills
  num getUnpaidBillsTotal() {
    List<GuageBill> filtered = getFilteredBills();
    return filtered
        .where((bill) => bill.isPaid == false || bill.isPaid == null)
        .fold(0, (sum, bill) => sum + bill.billTotal);
  }

  // Get average power consumption
  num getAveragePowerConsumption() {
    List<GuageBill> filtered = getFilteredBills();
    if (filtered.isEmpty) return 0;
    return getTotalPowerConsumption() / filtered.length;
  }

  // Get average bill amount
  num getAverageBillAmount() {
    List<GuageBill> filtered = getFilteredBills();
    if (filtered.isEmpty) return 0;
    return getTotalBillAmount() / filtered.length;
  }

  // Search bills by account number
  List<GuageBill> searchByAccountNumber(String query) {
    if (query.isEmpty) return bills;
    return bills
        .where((bill) => bill.accountNumber.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get bills by year
  List<GuageBill> getBillsByYear(int year) {
    return bills.where((bill) => bill.billYear == year).toList();
  }

  // Get bills by month and year
  List<GuageBill> getBillsByMonthAndYear(int month, int year) {
    return bills
        .where((bill) => bill.billMonth == month && bill.billYear == year)
        .toList();
  }

  // Get bills by account number
  List<GuageBill> getBillsByAccountNumber(String accountNumber) {
    return bills.where((bill) => bill.accountNumber == accountNumber).toList();
  }

  // Refresh bills data
  Future<void> refreshBills() async {
    await allbills();
  }
}