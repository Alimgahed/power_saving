import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';
import 'package:power_saving/features/bill/model/bills_model.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllBills());
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Obx(() => _buildBody(controller)),
    );
  }

  PreferredSizeWidget _buildAppBar(AllBills controller) {
    return AppBar(
      title: Obx(() => controller.isSearching.value
          ? TextField(
              controller: controller.searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ابحث برقم الحساب، الشهر، أو السنة...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                controller.onSearchChanged(value);
              },
            )
          : const Text(
              'قائمة الفواتير',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )),
            
      backgroundColor: const Color(0xFF1E40AF),
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Obx(() => Row(
                children: [
                  if (!controller.isSearching.value) ...[
                    // Search Button
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: controller.toggleSearch,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                 
                    // Add Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.offNamed('/addBill');
            
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        "إضافة فاتورة",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E40AF),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: controller.toggleSearch,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      Get.offNamed('/home');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody(AllBills controller) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.bills.isEmpty) {
      return _buildEmptyState(controller);
    }

    return CustomScrollView(
      slivers: [
        // Search Error Message (if any)
        if (controller.searchError.value.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildSearchError(controller),
          ),
        
        // Statistics Header
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: _buildStatisticsHeader(controller),
          ),
        ),

        // Active Filters Badge
        if (controller.selectedYear != 'all' ||
            controller.selectedMonth != 'all' ||
            controller.selectedAccountNumber != 'all')
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildActiveFilters(controller),
            ),
          ),
        
        // Bills Table
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: Builder(
            builder: (context) {
              return SliverToBoxAdapter(
                child: _buildDataTable(controller, context),
              );
            }
          ),
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  Widget _buildSearchError(AllBills controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange.shade700,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.searchError.value,
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AllBills controller) {
    if (controller.searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'لم يتم العثور على "${controller.searchController.text}"',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.receipt_long,
              size: 48,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد فواتير',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإضافة فاتورة جديدة',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.offNamed('/addBill'),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('إضافة فاتورة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsHeader(AllBills controller) {
    return Column(
      children: [
        // Main header with count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.searchController.text.isEmpty &&
                              controller.selectedYear == 'all' &&
                              controller.selectedMonth == 'all' &&
                              controller.selectedAccountNumber == 'all'
                          ? 'إجمالي الفواتير'
                          : 'نتائج البحث',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.bills.length} فاتورة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Statistics Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'المدفوعة',
                '${controller.getPaidBillsCount()}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'غير المدفوعة',
                '${controller.getUnpaidBillsCount()}',
                Icons.pending,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'إجمالي المبلغ',
                '${NumberFormat('#,###').format(controller.getTotalBillAmount())} ج.م',
                Icons.monetization_on_outlined,
                Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(controller.getTotalPowerConsumption())} كيلو واط',
                Icons.electric_bolt,
                Colors.purple.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveFilters(AllBills controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(
            'تصفية نشطة',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => controller.refresh(),
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(AllBills controller, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columns: const [
              DataColumn(label: Text('رقم الحساب', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الشهر', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('السنة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الاستهلاك', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('إجمالي الفاتورة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('الحالة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              DataColumn(label: Text('إجراءات', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
            rows: controller.bills.map((bill) {
              Color statusColor = bill.isPaid == true ? Colors.green : Colors.orange;
              IconData statusIcon = bill.isPaid == true ? Icons.check_circle : Icons.pending;

              return DataRow(
                cells: [
                  DataCell(Text(bill.accountNumber, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(controller.getMonthName(bill.billMonth))),
                  DataCell(Text(bill.billYear.toString())),
                  DataCell(Text('${NumberFormat('#,###').format(bill.powerConsump)} كيلووات')),
                  DataCell(Text('${NumberFormat('#,###').format(bill.billTotal)} ج.م', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            bill.isPaid == true ? 'مدفوعة' : 'معلقة',
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () {
                        showBillDetailsDialog(bill, controller);
                      },
                      tooltip: 'عرض التفاصيل',
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Separate widget to prevent rebuilding all cards
class _BillCard extends StatelessWidget {
  final GuageBill bill;
  final AllBills controller;

  const _BillCard({
    required this.bill,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = bill.isPaid == true ? Colors.green : Colors.orange;
    IconData statusIcon = bill.isPaid == true ? Icons.check_circle : Icons.pending;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(statusColor, statusIcon),
          _buildContent(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(Color statusColor, IconData statusIcon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        bill.accountNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  bill.isPaid == true ? 'مدفوعة' : 'معلقة',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _InfoCard(
            label: 'الاستهلاك',
            value: '${NumberFormat('#,###').format(bill.powerConsump)} كيلووات',
            icon: Icons.electric_bolt,
            color: Colors.purple,
          ),
          const SizedBox(height: 8),
          _InfoCard(
            label: 'إجمالي الفاتورة',
            value: '${NumberFormat('#,###').format(bill.billTotal)} ج.م',
            icon: Icons.attach_money,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'تفاصيل الفاتورة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Show bill details - you can implement the dialog here
              showBillDetailsDialog(bill, controller);
            },
            icon: const Icon(Icons.visibility, size: 14),
            label: const Text(
              'عرض',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
void showBillDetailsDialog(GuageBill bill, AllBills controller) {
  final nf = NumberFormat('#,###.##');

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 750),
        child: Column(
          children: [

            /// ================= HEADER =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تفاصيل فاتورة العداد',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                          style:
                              const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
            ),

            /// ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    /// -------- المعلومات العامة --------
                    _buildDialogSection(
                      'المعلومات العامة',
                      Icons.info,
                      Colors.teal,
                      [
                        _buildDialogDetailRow(
                            'رقم الحساب',
                            bill.accountNumber,
                            Icons.confirmation_number),

                        _buildDialogDetailRow(
                            'الشهر',
                            controller.getMonthName(bill.billMonth),
                            Icons.calendar_month),

                        _buildDialogDetailRow(
                            'السنة',
                            bill.billYear.toString(),
                            Icons.calendar_today),

                        _buildDialogDetailRow(
                            'حالة الدفع',
                            bill.isPaid == true
                                ? 'مدفوعة'
                                : 'غير مدفوعة',
                            bill.isPaid == true
                                ? Icons.check_circle
                                : Icons.pending,
                            valueColor: bill.isPaid == true
                                ? Colors.green
                                : Colors.red),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// -------- قراءات العداد --------
                    _buildDialogSection(
                      'قراءات العداد',
                      Icons.speed,
                      Colors.orange,
                      [
                        _buildDialogDetailRow(
                            'القراءة السابقة',
                            nf.format(bill.prevReading),
                            Icons.history),

                        _buildDialogDetailRow(
                            'القراءة الحالية',
                            nf.format(bill.currentReading),
                            Icons.timeline),

                        _buildDialogDetailRow(
                            'معامل القراءة',
                            nf.format(bill.readingFactor),
                            Icons.calculate),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// -------- الاستهلاك --------
                    _buildDialogSection(
                      'الاستهلاك',
                      Icons.bolt,
                      Colors.deepOrange,
                      [
                        _buildDialogDetailRow(
                          'استهلاك الكهرباء',
                          '${nf.format(bill.powerConsump)} ك.و.س',
                          Icons.electric_meter,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// -------- الحسابات المالية --------
                    _buildDialogSection(
                      'الحسابات المالية',
                      Icons.payments,
                      Colors.indigo,
                      [
                        _buildDialogDetailRow(
                            'القسط الثابت',
                            nf.format(bill.fixedInstallment),
                            Icons.account_balance),

                        _buildDialogDetailRow(
                            'التسويات',
                            nf.format(bill.settlements),
                            Icons.swap_horiz),

                        _buildDialogDetailRow(
                            'نسبة التسوية',
                            nf.format(bill.settlementsratio),
                            Icons.percent),

                        _buildDialogDetailRow(
                            'الدمغة',
                            nf.format(bill.stamp),
                            Icons.receipt),

                        _buildDialogDetailRow(
                            'مدفوعات سابقة',
                            nf.format(bill.prevPayments),
                            Icons.payments),

                        _buildDialogDetailRow(
                            'التقريب',
                            nf.format(bill.rounding),
                            Icons.rounded_corner),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// -------- التأخيرات --------
                    if (bill.delayMonth != null ||
                        bill.delayYear != null)
                      _buildDialogSection(
                        'التأخيرات',
                        Icons.schedule,
                        Colors.redAccent,
                        [
                          _buildDialogDetailRow(
                              'شهر التأخير',
                              '${bill.delayMonth ?? 0}',
                              Icons.calendar_month),

                          _buildDialogDetailRow(
                              'سنة التأخير',
                              '${bill.delayYear ?? 0}',
                              Icons.calendar_today),
                        ],
                      ),

                    const SizedBox(height: 20),

                    /// -------- الإجمالي النهائي --------
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade50,
                            Colors.green.shade100
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي النهائي',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${nf.format(bill.billTotal)} ج.م',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (bill.notes != null &&
                        bill.notes!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildDialogSection(
                        'ملاحظات',
                        Icons.note,
                        Colors.blueGrey,
                        [
                          Text(bill.notes!),
                        ],
                      ),
                    ],
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


 

  Widget _buildDialogSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 10,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          ...children,
         
        ],
      ),
    );
  }

  Widget _buildDialogDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          SizedBox(width: 10,),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

 