import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/controller/bills/tech_bills.dart';
import 'package:power_saving/model/tech_bill.dart';


class TechBill extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Get.put(TechBillscontroller());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'فواتير التقنيات',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        actions: [
          Container(
            child: Row(
              children: [
                // Filter Buttons
                GetBuilder<TechBillscontroller>(
                  builder: (controller) {
                    return Row(
                      children: [
                        // Year Filter
                        _buildFilterButton(
                          controller,
                          'السنة',
                          controller.selectedYear,
                          Icons.calendar_today,
                          controller.getUniqueYears(),
                          (value) => controller.filterByYear(value),
                        ),
                        // Month Filter
                        _buildMonthFilterButton(controller),
                        // Station Filter
                        _buildFilterButton(
                          controller,
                          'المحطة',
                          controller.selectedStationName,
                          Icons.location_on,
                          controller.getUniqueStationNames(),
                          (value) => controller.filterByStationName(value),
                        ),
                        // Technology Filter
                        _buildFilterButton(
                          controller,
                          'التقنية',
                          controller.selectedTechnologyName,
                          Icons.science,
                          controller.getUniqueTechnologyNames(),
                          (value) => controller.filterByTechnologyName(value),
                        ),
                      ],
                    );
                  },
                ),
                // Add Button
              
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
                SizedBox(width: 12,)
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<TechBillscontroller>(
        builder: (controller) {
          // Loading State
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: const Color(0xFF1E40AF),
                    strokeWidth: 3,
                  ),
                  const Text(
                    'جاري تحميل الفواتير...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
    
          // Empty State
          if (controller.bills.isEmpty) {
            return Center(
              child: Column(
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
                  const Text(
                    'لا توجد فواتير',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'ابدأ بإضافة فاتورة جديدة',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            );
          }
    
          // Get filtered bills
          List<TechnologyBill> filteredBills = controller.getFilteredBills();
    
          // Empty Filter Result
          if (filteredBills.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.orange.shade300,
                    ),
                  ),
                  const Text(
                    'لا توجد نتائج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'لا توجد فواتير مطابقة للفلاتر المحددة',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => controller.resetFilters(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('إعادة تعيين الفلاتر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
    
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              
              children: [
                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'إجمالي الفواتير',
                        '${filteredBills.length}',
                        Icons.receipt_long,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: _buildStatCard(
                        'إجمالي المبلغ',
                        '${NumberFormat('#,###').format(controller.getTotalBillAmount())} ج.م',
                        Icons.monetization_on_outlined,
                        Colors.green.shade700,
                      ),
                    ),
                                        SizedBox(width: 10,),

                    Expanded(
                      child: _buildStatCard(
                        'استهلاك الكهرباء',
                        '${NumberFormat('#,###').format(controller.getTotalPowerConsumption())} كيلو واط',
                        Icons.electric_bolt,
                        Colors.purple.shade700,
                      ),
                    ),
                                        SizedBox(width: 10,),

                    Expanded(
                      child: _buildStatCard(
                        'كمية المياه',
                        '${NumberFormat('#,###').format(controller.getTotalWaterAmount())} م³',
                        Icons.water_drop,
                        Colors.cyan.shade700,
                      ),
                    ),
                  ],
                ),
    
    SizedBox(height: 20,),
                // Active Filters Badge
                if (controller.selectedYear != 'all' ||
                    controller.selectedMonth != 'all' ||
                    controller.selectedStationName != 'all' ||
                    controller.selectedTechnologyName != 'all')
                  Container(
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
                        Text(
                          'تصفية نشطة (${filteredBills.length})',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.resetFilters(),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
    
                // Bills Grid
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: filteredBills.map((bill) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildBillCard(bill, controller),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(
    TechBillscontroller  controller,
    String label,
    String currentValue,
    IconData icon,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                currentValue == 'all' ? label : currentValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'all',
            child: Row(
              children: [
                const Icon(Icons.all_inclusive, size: 18),
                Text('كل $label'),
              ],
            ),
          ),
          ...options.map((option) {
            return PopupMenuItem<String>(
              value: option,
              child: Row(
                children: [
                  Icon(icon, size: 18),
                  Flexible(
                    child: Text(
                      option,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ];
      },
    );
  }

  Widget _buildMonthFilterButton(TechBillscontroller  controller) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Colors.white, size: 16),
            Text(
              controller.selectedMonth == 'all'
                  ? 'الشهر'
                  : controller.getMonthName(int.parse(controller.selectedMonth)),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onSelected: (value) => controller.filterByMonth(value),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'all',
            child: Row(
              children: [
                Icon(Icons.all_inclusive, size: 18),
                Text('كل الأشهر'),
              ],
            ),
          ),
          ...controller.getUniqueMonths().map((month) {
            return PopupMenuItem<String>(
              value: month,
              child: Row(
                children: [
                  const Icon(Icons.date_range, size: 18),
                  Text(controller.getMonthName(int.parse(month))),
                ],
              ),
            );
          }).toList(),
        ];
      },
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
          Icon(icon, color: color, size: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(TechnologyBill bill, TechBillscontroller controller) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 16),
                    Expanded(
                      child: Text(
                        bill.stationName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.science, color: Colors.white70, size: 14),
                    Expanded(
                      child: Text(
                        bill.technologyName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  'استهلاك الكهرباء',
                  '${NumberFormat('#,###').format(bill.technologyPowerConsump)} كيلو واط',
                  Icons.electric_bolt,
                  Colors.purple,
                ),
                const Divider(height: 16),
                if (bill.technologyWaterAmount != null)
                  Column(
                    children: [
                      _buildInfoRow(
                        'كمية المياه',
                        '${NumberFormat('#,###').format(bill.technologyWaterAmount)} م³',
                        Icons.water_drop,
                        Colors.cyan,
                      ),
                      const Divider(height: 16),
                    ],
                  ),
                _buildInfoRow(
                  'النسبة المئوية',
                  '${bill.technologyBillPercentage.toStringAsFixed(1)}%',
                  Icons.percent,
                  Colors.orange,
                ),
                const Divider(height: 16),
                _buildInfoRow(
                  'إجمالي الفاتورة',
                  '${NumberFormat('#,###').format(num.parse(bill.technologyBillTotal))} ج.م',
                  Icons.attach_money,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
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
                    _showBillDetailsDialog(bill, controller);
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
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
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
              color: color,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

 void _showBillDetailsDialog(TechnologyBill bill, TechBillscontroller controller) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 750),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                        _buildDialogDetailRow('كمية المياه', '${bill.technologyWaterAmount ?? 0} م³', Icons.water),
                        _buildDialogDetailRow('استهلاك الكلور', '${bill.technologyChlorineConsump ?? 0} كجم', Icons.science),
                        _buildDialogDetailRow('استهلاك الشب السائل', '${bill.technologyLiquidAlumConsump ?? 0} كجم', Icons.opacity),
                        _buildDialogDetailRow('استهلاك الشب الصلب', '${bill.technologySolidAlumConsump ?? 0} كجم', Icons.ac_unit),
                        _buildDialogDetailRow('استهلاك الكهرباء', '${bill.technologyPowerConsump} ك.و.س', Icons.electrical_services),
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
                          '${NumberFormat('#,###.##').format(num.parse(bill.technologyBillTotal))} ج.م',
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
                            '${NumberFormat('#,###').format(num.parse(bill.technologyBillTotal))} ج.م',
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

 }
//  DetailRow(
//                             'إجمالي الفاتورة',
//                             '${NumberFormat('#,###.##').format(num.parse(bill.technologyBillTotal))} ج.م',
//                             Icons.account_balance_wallet,
//                             valueColor: Colors.green.shade700,
//                           ),
//                         ],
//                       ),
      
//                       const SizedBox(height: 20),
      
  //                     Container(
  //                       padding: const EdgeInsets.all(20),
  //                       decoration: BoxDecoration(
  //                         gradient: LinearGradient(
  //                           colors: [Colors.green.shade50, Colors.green.shade100],
  //                           begin: Alignment.topLeft,
  //                           end: Alignment.bottomRight,
  //                         ),
  //                         borderRadius: BorderRadius.circular(16),
  //                         border: Border.all(color: Colors.green.shade200),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Container(
  //                                 padding: const EdgeInsets.all(12),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.green.shade200,
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 child: Icon(
  //                                   Icons.account_balance_wallet,
  //                                   color: Colors.green.shade700,
  //                                   size: 24,
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 16),
  //                               const Text(
  //                                 'إجمالي الفاتورة',
  //                                 style: TextStyle(
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Flexible(
  //                             child: Text(
  //                               '${NumberFormat('#,###').format(num.parse(bill.technologyBillTotal))} ج.م',
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.green.shade700,
  //                               ),
  //                               textAlign: TextAlign.end,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              const SizedBox(width: 12),
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
  // DetailRow(
  //                           'اسم المحطة',
  //                           bill.stationName,
  //                           Icons.location_on,
  //                         ),
  //                         _buildDialogDetailRow(
  //                           'رقم المحطة',
  //                           '${bill.stationId}',
  //                           Icons.tag,
  //                         ),
  //                         _buildDialogDetailRow(
  //                           'اسم التقنية',
  //                           bill.technologyName,
  //                           Icons.science,
  //                         ),
  //                         _buildDialogDetailRow(
  //                           'رقم التقنية',
  //                           '${bill.technologyId}',
  //                           Icons.numbers,
  //                         ),
  //                         _buildDialogDetailRow(
  //                           'شهر الفاتورة',
  //                           controller.getMonthName(bill.billMonth),
  //                           Icons.calendar_month,
  //                         ),
  //                         _buildDialogDetailRow(
  //                           'سنة الفاتورة',
  //                           '${bill.billYear}',
  //                           Icons.calendar_today,
  //                         ),
  //                       ],
  //                     ),
      
  //                     const SizedBox(height: 20),
      
  //                     // Power Consumption Section
  //                     _buildDialogSection(
  //                       'استهلاك الكهرباء والمياه',
  //                       Icons.electric_bolt,
  //                       Colors.purple,
  //                       [
  //                         _buildDialogDetailRow(
  //                           'استهلاك الكهرباء',
  //                           '${NumberFormat('#,###').format(bill.technologyPowerConsump)} كيلو واط',
  //                           Icons.electric_bolt,
  //                           valueColor: Colors.purple,
  //                         ),
  //                         if (bill.technologyWaterAmount != null)
  //                           _buildDialogDetailRow(
  //                             'كمية المياه',
  //                             '${NumberFormat('#,###').format(bill.technologyWaterAmount)} م³',
  //                             Icons.water_drop,
  //                             valueColor: Colors.cyan,
  //                           ),
  //                         if (bill.powerPerWater != null)
  //                           _buildDialogDetailRow(
  //                             'الكهرباء لكل وحدة مياه',
  //                             '${bill.powerPerWater!.toStringAsFixed(3)} كيلو واط/م³',
  //                             Icons.speed,
  //                           ),
  //                       ],
  //                     ),
      
      
                      // Chemical Consumption Section
                      // if (bill.technologyChlorineConsump != null ||
                      //     bill.technologySolidAlumConsump != null ||
                      //     bill.technologyLiquidAlumConsump != null)
                      //   Column(
                      //     children: [
                      //       _buildDialogSection(
                      //         'استهلاك المواد الكيميائية',
                      //         Icons.science_outlined,
                      //         Colors.teal,
                      //         [
                      //           if (bill.technologyChlorineConsump != null)
                      //             _buildDialogDetailRow(
                      //               'استهلاك الكلور',
                      //               '${NumberFormat('#,###.##').format(bill.technologyChlorineConsump)} كجم',
                      //               Icons.water_damage,
                      //               valueColor: Colors.teal,
                      //             ),
                      //           if (bill.chlorineRangeFrom != null && bill.chlorineRangeTo != null)
                      //             _buildDialogDetailRow(
                      //               'نطاق الكلور',
                      //               '${bill.chlorineRangeFrom} - ${bill.chlorineRangeTo}',
                      //               Icons.straighten,
                      //             ),
                      //           if (bill.technologySolidAlumConsump != null)
                      //             _buildDialogDetailRow(
                      //               'استهلاك الشبة الصلبة',
                      //               '${NumberFormat('#,###.##').format(bill.technologySolidAlumConsump)} كجم',
                      //               Icons.view_in_ar,
                      //               valueColor: Colors.brown,
                      //             ),
                      //           if (bill.solidAlumRangeFrom != null && bill.solidAlumRangeTo != null)
                      //             _buildDialogDetailRow(
                      //               'نطاق الشبة الصلبة',
                      //               '${bill.solidAlumRangeFrom} - ${bill.solidAlumRangeTo}',
                      //               Icons.straighten,
                      //             ),
                      //           if (bill.technologyLiquidAlumConsump != null)
                      //             _buildDialogDetailRow(
                      //               'استهلاك الشبة السائلة',
                      //               '${NumberFormat('#,###.##').format(bill.technologyLiquidAlumConsump)} لتر',
                      //               Icons.opacity,
                      //               valueColor: Colors.indigo,
                      //             ),
                      //           if (bill.liquidAlumRangeFrom != null && bill.liquidAlumRangeTo != null)
                      //             _buildDialogDetailRow(
                      //               'نطاق الشبة السائلة',
                      //               '${bill.liquidAlumRangeFrom} - ${bill.liquidAlumRangeTo}',
                      //               Icons.straighten,
                      //             ),
                      //         ],
                      //       ),
                      //       const SizedBox(height: 20),
                      //     ],
                      //   ),
      
                      // // Financial Details Section
                      // _buildDialogSection(
                      //   'التفاصيل المالية',
                      //   Icons.attach_money,
                      //   Colors.green,
                      //   [
                      //     _buildDialogDetailRow(
                      //       'النسبة المئوية',
                      //       '${bill.technologyBillPercentage.toStringAsFixed(2)}%',
                      //       Icons.percent,
                      //       valueColor: Colors.orange,
                      //     ),
                      //     _buildDialogimport 
                         