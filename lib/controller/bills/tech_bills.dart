import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/tech_bill.dart';
import 'package:power_saving/network/network.dart';

class TechBillscontroller extends GetxController {
  List<TechnologyBill> bills = [];
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Filter properties
  String selectedYear = 'all';
  String selectedMonth = 'all';
  String selectedStationName = 'all';
  String selectedTechnologyName = 'all';

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

      final res = await fetchData("http://$ip/view-tech-bills");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        if (jsonData is List) {
          bills = jsonData.map((bill) => TechnologyBill.fromJson(bill)).toList();
          
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
  List<TechnologyBill> getFilteredBills() {
    List<TechnologyBill> filtered = bills;

    if (selectedYear != 'all') {
      filtered = filtered.where((bill) => bill.billYear.toString() == selectedYear).toList();
    }

    if (selectedMonth != 'all') {
      filtered = filtered.where((bill) => bill.billMonth.toString() == selectedMonth).toList();
    }

    if (selectedStationName != 'all') {
      filtered = filtered.where((bill) => bill.stationName == selectedStationName).toList();
    }

    if (selectedTechnologyName != 'all') {
      filtered = filtered.where((bill) => bill.technologyName == selectedTechnologyName).toList();
    }

    return filtered;
  }

  // Get unique years from bills
  List<String> getUniqueYears() {
    Set<String> years = bills.map((bill) => bill.billYear.toString()).toSet();
    List<String> yearsList = years.toList();
    yearsList.sort((a, b) => b.compareTo(a));
    return yearsList;
  }

  // Get unique months from bills
  List<String> getUniqueMonths() {
    Set<String> months = bills.map((bill) => bill.billMonth.toString()).toSet();
    List<String> monthsList = months.toList();
    monthsList.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return monthsList;
  }

  // Get unique station names from bills
  List<String> getUniqueStationNames() {
    Set<String> stations = bills.map((bill) => bill.stationName).toSet();
    List<String> stationsList = stations.toList();
    stationsList.sort();
    return stationsList;
  }

  // Get unique technology names from bills
  List<String> getUniqueTechnologyNames() {
    Set<String> technologies = bills.map((bill) => bill.technologyName).toSet();
    List<String> technologiesList = technologies.toList();
    technologiesList.sort();
    return technologiesList;
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

  // Filter by station name
  void filterByStationName(String stationName) {
    selectedStationName = stationName;
    update();
  }

  // Filter by technology name
  void filterByTechnologyName(String technologyName) {
    selectedTechnologyName = technologyName;
    update();
  }

  // Reset all filters
  void resetFilters() {
    selectedYear = 'all';
    selectedMonth = 'all';
    selectedStationName = 'all';
    selectedTechnologyName = 'all';
    update();
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
    return filtered.fold(0, (sum, bill) => sum + num.parse(bill.technologyBillTotal));
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