import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/bill/controller/tech_bills.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/constant/colors.dart';

class TechBill extends StatelessWidget {
  const TechBill({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TechBillscontroller());
    return AppScaffold(
      title: 'فواتير التقنيات',
      showDrawer: false,
      mobileAppBar: const CustomAppBar(title: 'فواتير التقنيات', backRoute: '/home'),
      body: GetBuilder<TechBillscontroller>(
        builder: (controller) {
          // Loading State
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل الفواتير...',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          List<TechnologyBill> filteredBills = controller.getFilteredBills();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Header & Search/Filters ───
              _buildTopSection(controller, filteredBills.length),

              // ─── Stats Row ───
              if (controller.bills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(child: _buildStatCard('إجمالي الفواتير', '${filteredBills.length}', Icons.receipt_long, Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('إجمالي المبلغ', '${NumberFormat('#,###').format(controller.getTotalBillAmount())} ج.م', Icons.monetization_on_outlined, Colors.green.shade700)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('استهلاك الكهرباء', '${NumberFormat('#,###').format(controller.getTotalPowerConsumption())} كيلو واط', Icons.electric_bolt, Colors.purple.shade700)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('كمية المياه', '${NumberFormat('#,###').format(controller.getTotalWaterAmount())} م³', Icons.water_drop, Colors.cyan.shade700)),
                    ],
                  ),
                ),

              // ─── Table Content (Scrollable independently) ───
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _buildMainContent(controller, filteredBills, context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Header and Search/Filters
  // ═══════════════════════════════════════════════════════
  Widget _buildTopSection(TechBillscontroller controller, int filteredCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Search and Active Filter Info
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن اسم المحطة، التقنية، السنة...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (controller.selectedYear != 'all' ||
                  controller.selectedMonth != 'all' ||
                  controller.selectedStationName != 'all' ||
                  controller.selectedTechnologyName != 'all' ||
                  controller.searchQuery.value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list, size: 18, color: AppColors.infoDark),
                      const SizedBox(width: 8),
                      Text(
                        'نتائج البحث: $filteredCount فاتورة',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.infoDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: controller.resetFilters,
                        child: const Icon(Icons.close, size: 18, color: AppColors.error),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Dropdown Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'المحطة',
                  currentValue: controller.selectedStationName,
                  options: controller.getUniqueStationNames(),
                  onSelected: controller.filterByStationName,
                  icon: Icons.location_city,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'التقنية',
                  currentValue: controller.selectedTechnologyName,
                  options: controller.getUniqueTechnologyNames(),
                  onSelected: controller.filterByTechnologyName,
                  icon: Icons.memory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'السنة',
                  currentValue: controller.selectedYear,
                  options: controller.getUniqueYears(),
                  onSelected: controller.filterByYear,
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'الشهر',
                  currentValue: controller.selectedMonth,
                  options: controller.getUniqueMonths(),
                  onSelected: controller.filterByMonth,
                  icon: Icons.date_range,
                  isMonth: true,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String currentValue,
    required List<String> options,
    required Function(String) onSelected,
    required IconData icon,
    bool isMonth = false,
    TechBillscontroller? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
          items: [
            DropdownMenuItem(
              value: 'all',
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('كل الـ $label', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                ],
              ),
            ),
            ...options.map((option) {
              String display = option;
              if (isMonth && controller != null) {
                display = controller.getMonthName(int.parse(option));
              }
              return DropdownMenuItem(
                value: option,
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        display,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          onChanged: (value) {
            if (value != null) onSelected(value);
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Main Content (Empty States vs Table)
  // ═══════════════════════════════════════════════════════
  Widget _buildMainContent(TechBillscontroller controller, List<TechnologyBill> filteredBills, BuildContext context) {
    if (controller.bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: AppColors.border),
            const SizedBox(height: 16),
            const Text('لا توجد فواتير', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const Text('ابدأ بإضافة فاتورة جديدة', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    if (filteredBills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: AppColors.warning),
            const SizedBox(height: 16),
            const Text('لا توجد نتائج', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const Text('لا توجد فواتير مطابقة لبحثك أو الفلاتر المحددة', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.resetFilters,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة تعيين الفلاتر والبحث'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Wrap in a Container with white background and nice border
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          // Vertical scrolling for the table rows
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(AppColors.primarySurface),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columnSpacing: 30,
              columns: const [
                DataColumn(label: Text('المحطة', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('التقنية', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('الشهر/السنة', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('كمية المياه', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('استهلاك الكهرباء', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('النسبة', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('إجمالي الفاتورة', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
                DataColumn(label: Text('إجراءات', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark))),
              ],
              rows: filteredBills.map((bill) {
                return DataRow(
                  cells: [
                    DataCell(Text(bill.stationName, style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(bill.technologyName)),
                    DataCell(Text('${controller.getMonthName(bill.billMonth)} ${bill.billYear}')),
                    DataCell(Text(bill.technologyWaterAmount != null ? '${NumberFormat('#,###').format(bill.technologyWaterAmount)} م³' : '-')),
                    DataCell(Text('${NumberFormat('#,###').format(bill.technologyPowerConsump)} كيلو واط')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(6)),
                        child: Text('${bill.technologyBillPercentage.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.warningDark, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(6)),
                        child: Text('${NumberFormat('#,###').format(num.tryParse(bill.technologyBillTotal) ?? 0)} ج.م', style: const TextStyle(color: AppColors.successDark, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: AppColors.info),
                            onPressed: () => showBillDetailsDialog(bill, controller),
                            tooltip: 'عرض التفاصيل',
                          ),
                          if (user?.groupId == 2 || user?.groupId == 1)
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.success),
                              onPressed: () => Get.toNamed('/EditTechBills', arguments: {'bill': bill}),
                              tooltip: 'تعديل',
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

  // ═══════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Dialog
  // ═══════════════════════════════════════════════════════
  void showBillDetailsDialog(TechnologyBill bill, TechBillscontroller controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 750),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppGradients.header,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تفاصيل فاتورة التقنية',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Section: General Info
                      _buildDialogSection(
                        'المعلومات العامة',
                        Icons.info,
                        Colors.teal,
                        [
                          _buildDialogDetailRow('اسم المحطة', bill.stationName, Icons.location_on),
                          _buildDialogDetailRow('اسم التقنية', bill.technologyName, Icons.precision_manufacturing),
                          _buildDialogDetailRow('السنة', bill.billYear.toString(), Icons.calendar_today),
                          _buildDialogDetailRow('الشهر', controller.getMonthName(bill.billMonth), Icons.calendar_view_month),
                        ],
                      ),

                      /// Section: استهلاك التقنية
                      _buildDialogSection(
                        'استهلاك التقنية',
                        Icons.bolt,
                        Colors.orange,
                        [
                          _buildDialogDetailRow('كمية المياه', '${NumberFormat('#,###').format(bill.technologyWaterAmount ?? 0)} م³', Icons.water),
                          _buildDialogDetailRow('استهلاك الكلور', '${NumberFormat('#,###').format(bill.technologyChlorineConsump ?? 0)} جرام', Icons.science),
                          _buildDialogDetailRow('استهلاك الشب السائل', '${NumberFormat('#,###').format(bill.technologyLiquidAlumConsump ?? 0)} جرام', Icons.opacity),
                          _buildDialogDetailRow('استهلاك الشب الصلب', '${NumberFormat('#,###').format(bill.technologySolidAlumConsump ?? 0)} جرام', Icons.ac_unit),
                          _buildDialogDetailRow('استهلاك الكهرباء', '${NumberFormat('#,###').format(bill.technologyPowerConsump)} ك.و.س', Icons.electrical_services),
                        ],
                      ),

                      /// Section: الحدود المسموح بها
                      _buildDialogSection(
                        'الحدود المسموح بها',
                        Icons.straighten,
                        Colors.indigo,
                        [
                          _buildDialogDetailRow('الكلور من - إلى', '${bill.chlorineRangeFrom ?? 0} - ${bill.chlorineRangeTo ?? 0}', Icons.linear_scale),
                          _buildDialogDetailRow('الشب السائل من - إلى', '${bill.liquidAlumRangeFrom ?? 0} - ${bill.liquidAlumRangeTo ?? 0}', Icons.tune),
                          _buildDialogDetailRow('الشب الصلب من - إلى', '${bill.solidAlumRangeFrom ?? 0} - ${bill.solidAlumRangeTo ?? 0}', Icons.tune),
                          _buildDialogDetailRow('الكهرباء لكل م³', '${bill.powerPerWater ?? 0} ك.و.س', Icons.flash_on),
                        ],
                      ),

                      /// Section: ملخص الفاتورة
                      _buildDialogSection(
                        'ملخص الفاتورة',
                        Icons.receipt,
                        Colors.green,
                        [
                          _buildDialogDetailRow(
                            'النسبة المئوية',
                            '${bill.technologyBillPercentage.toStringAsFixed(2)}%',
                            Icons.percent,
                            valueColor: Colors.orange,
                          ),
                          _buildDialogDetailRow(
                            'إجمالي الفاتورة',
                            '${NumberFormat('#,###.##').format(num.tryParse(bill.technologyBillTotal) ?? 0)} ج.م',
                            Icons.account_balance_wallet,
                            valueColor: Colors.green.shade700,
                          ),
                        ],
                      ),

                      // Highlighted Total
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade50, Colors.green.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.account_balance_wallet, color: Colors.green.shade700, size: 24),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'الإجمالي النهائي',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                                ),
                              ],
                            ),
                            Text(
                              '${NumberFormat('#,###').format(num.tryParse(bill.technologyBillTotal) ?? 0)} ج.م',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDialogDetailRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}