import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';
import 'package:power_saving/features/bill/model/bills_model.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllBills>();
    
    final PreferredSizeWidget appBar = ReusableAppBar(
      title: 'قائمة الفواتير',
      isSearching: controller.isSearching,
      searchController: controller.searchController,
      onSearchChanged: (value) => controller.onSearchChanged(value),
      onSearchToggle: () => controller.toggleSearch(),
      onNavigateHome: () => Get.offNamed('/home'),
      hintText: 'ابحث برقم الحساب، المحطة، الفرع...',
    );

    return AppScaffold(
      title: 'قائمة الفواتير',
      mobileAppBar: appBar,
      desktopHeader: appBar,
      body: Obx(() => _buildBody(context, controller)),
    );
  }

  Widget _buildBody(BuildContext context, AllBills controller) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refresh();
      },
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Filters Row
          _buildFiltersSection(controller),
          const SizedBox(height: 24),
          
          // 2. Data Table
          if (controller.bills.isEmpty)
            _buildEmptyState()
          else
            _buildDataTable(context, controller),
            
          // 3. Pagination
          if (controller.totalPages.value > 1) ...[
            const SizedBox(height: 20),
            _buildPaginationControls(controller),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildFiltersSection(AllBills controller) {
    return Row(
      children: [
        // Month Filter
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedMonth,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('كل الـ الشهر', style: TextStyle(fontSize: 14))),
                  ...List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: (index + 1).toString(),
                      child: Text(controller.getMonthName(index + 1), style: const TextStyle(fontSize: 14)),
                    );
                  }),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedMonth = value;
                    controller.currentPage.value = 1;
                    controller.allbills();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Year Filter
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedYear,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('كل الـ السنة', style: TextStyle(fontSize: 14))),
                  ...[2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030].map((year) {
                    return DropdownMenuItem(
                      value: year.toString(),
                      child: Text(year.toString(), style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedYear = value;
                    controller.currentPage.value = 1;
                    controller.allbills();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Add Bill Button
        ElevatedButton.icon(
          onPressed: () => Get.offNamed('/addBill'),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('إضافة فاتورة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, AllBills controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 40),
            child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            horizontalMargin: 24,
            columnSpacing: 30,
            columns: const [
              DataColumn(label: Text('رقم الحساب', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الفرع', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('المحطات', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الشهر/السنة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الاستهلاك', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('إجمالي الفاتورة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الحالة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('إجراءات', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
            rows: controller.bills.map((bill) {
              final nf = NumberFormat('#,###');
              return DataRow(
                cells: [
                  DataCell(Text(bill.accountNumber, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(bill.branchName ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blueAccent))),
                  DataCell(Text(bill.stationNames ?? '-', style: const TextStyle(color: Colors.black87))),
                  DataCell(Text('${controller.getMonthName(bill.billMonth)} ${bill.billYear}')),
                  DataCell(Text('${nf.format(bill.powerConsump)} كيلو واط', style: const TextStyle(color: Colors.black54))),
                  DataCell(
                    Text(
                      '${nf.format(bill.billTotal)} ج.م',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: bill.isPaid == true ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: bill.isPaid == true ? Colors.green.shade200 : Colors.orange.shade200,
                        ),
                      ),
                      child: Text(
                        bill.isPaid == true ? 'مدفوعة' : 'معلقة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: bill.isPaid == true ? Colors.green.shade700 : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                          onPressed: () {
                            // Edit action
                          },
                          tooltip: 'تعديل',
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                          onPressed: () => showBillDetailsDialog(bill, controller),
                          tooltip: 'عرض التفاصيل',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'لا توجد فواتير',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(AllBills controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: controller.hasPrev.value ? controller.prevPage : null,
          icon: const Icon(Icons.arrow_back_ios, size: 14),
          label: const Text('السابق'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 24),
        Text(
          'صفحة ${controller.currentPage.value} من ${controller.totalPages.value}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: controller.hasNext.value ? controller.nextPage : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: const Row(
            children: [
              Text('التالي'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}

void showBillDetailsDialog(GuageBill bill, AllBills controller) {
  final nf = NumberFormat('#,###.##');
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E40AF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تفاصيل الفاتورة', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDialogRow('رقم الحساب', bill.accountNumber),
                    const Divider(),
                    if (bill.branchName != null) ...[
                      _buildDialogRow('الفرع', bill.branchName!),
                      const Divider(),
                    ],
                    if (bill.stationNames != null) ...[
                      _buildDialogRow('المحطات', bill.stationNames!),
                      const Divider(),
                    ],
                    if (bill.voltageType != null) ...[
                      _buildDialogRow('نوع الجهد', bill.voltageType!),
                      const Divider(),
                    ],
                    _buildDialogRow('الشهر / السنة', '${controller.getMonthName(bill.billMonth)} ${bill.billYear}'),
                    const Divider(),
                    _buildDialogRow('الاستهلاك', '${nf.format(bill.powerConsump)} كيلو واط'),
                    const Divider(),
                    _buildDialogRow('إجمالي الفاتورة', '${nf.format(bill.billTotal)} ج.م', isBold: true, color: Colors.green.shade700),
                    const Divider(),
                    _buildDialogRow('القراءة السابقة', nf.format(bill.prevReading)),
                    const Divider(),
                    _buildDialogRow('القراءة الحالية', nf.format(bill.currentReading)),
                    const Divider(),
                    _buildDialogRow('معامل القراءة', nf.format(bill.readingFactor)),
                    const Divider(),
                    _buildDialogRow('حالة الدفع', bill.isPaid == true ? 'مدفوعة' : 'غير مدفوعة', color: bill.isPaid == true ? Colors.green : Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDialogRow(String label, String value, {bool isBold = false, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
