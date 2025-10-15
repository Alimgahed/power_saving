import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/controller/bills/all_bills.dart';
import 'package:power_saving/model/bills_model.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllBills());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'قائمة الفواتير',
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
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                // Filter Buttons
                GetBuilder<AllBills>(
                  builder: (controller) {
                    return Row(
                      children: [
                        // Year Filter
                        PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.selectedYear == 'all'
                                      ? 'السنة'
                                      : controller.selectedYear,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onSelected: (String value) {
                            controller.filterByYear(value);
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'all',
                                child: Row(
                                  children: [
                                    Icon(Icons.all_inclusive, size: 18),
                                    SizedBox(width: 8),
                                    Text('كل السنوات'),
                                  ],
                                ),
                              ),
                              ...controller.getUniqueYears().map((year) {
                                return PopupMenuItem<String>(
                                  value: year,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18),
                                      const SizedBox(width: 8),
                                      Text(year),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ];
                          },
                        ),
                        const SizedBox(width: 8),
                        // Month Filter
                        PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
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
                          onSelected: (String value) {
                            controller.filterByMonth(value);
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'all',
                                child: Row(
                                  children: [
                                    Icon(Icons.all_inclusive, size: 18),
                                    SizedBox(width: 8),
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
                                      const SizedBox(width: 8),
                                      Text(controller.getMonthName(int.parse(month))),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ];
                          },
                        ),
                        const SizedBox(width: 8),
                        // Account Number Filter
                        PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.selectedAccountNumber == 'all'
                                      ? 'الحساب'
                                      : controller.selectedAccountNumber,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          onSelected: (String value) {
                            controller.filterByAccountNumber(value);
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'all',
                                child: Row(
                                  children: [
                                    Icon(Icons.all_inclusive, size: 18),
                                    SizedBox(width: 8),
                                    Text('كل الحسابات'),
                                  ],
                                ),
                              ),
                              ...controller.getUniqueAccountNumbers().map((account) {
                                return PopupMenuItem<String>(
                                  value: account,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.account_circle, size: 18),
                                      const SizedBox(width: 8),
                                      Text(account),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ];
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 12),
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
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<AllBills>(
        builder: (controller) {
          // Loading State
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: const Color(0xFF1E40AF),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            );
          }
    
          // Get filtered bills
          List<GuageBill> filteredBills = controller.getFilteredBills();
    
          // Empty Filter Result
          if (filteredBills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 24),
                  const Text(
                    'لا توجد نتائج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'لا توجد فواتير مطابقة للفلاتر المحددة',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                       const SizedBox(width: 12),
                    Expanded(child: _buildStatCard  ('إجمالي المبلغ','${NumberFormat('#,###').format(controller.getTotalBillAmount())} ج.م' ,Icons.monetization_on_outlined,Colors.green.shade700,))
                                                    ,const SizedBox(width: 12),

                                        Expanded(child: _buildStatCard  ('اجمالي الاستهلاك','${NumberFormat('#,###').format(controller.getTotalPowerConsumption())} كيلو واط' ,Icons.monetization_on_outlined, Colors.purple.shade700,))
                    ,const SizedBox(width: 12),
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
                     
                 

                    
                  
                  ],
                ),
    
    
                // Total Statistics
              
                const SizedBox(height: 24),
    
                // Active Filters Badge
                if (controller.selectedYear != 'all' ||
                    controller.selectedMonth != 'all' ||
                    controller.selectedAccountNumber != 'all')
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
                        const SizedBox(width: 6),
                        Text(
                          'تصفية نشطة (${filteredBills.length})',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                  spacing: 12,
                  runSpacing: 12,
                  children: filteredBills.map((bill) {
                    return _buildBillCard(bill, controller);
                  }).toList(),
                ),
              ],
            ),
          );
        },
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(GuageBill bill, AllBills controller) {
    Color statusColor = bill.isPaid == true ? Colors.green : Colors.orange;
    IconData statusIcon = bill.isPaid == true ? Icons.check_circle : Icons.pending;

    return Container(
      width: 300,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          bill.accountNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        bill.isPaid == true ? 'مدفوعة' : 'معلقة',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                  'القراءة السابقة',
                  '${bill.prevReading}',
                  Icons.speed,
                  Colors.grey,
                ),
                const Divider(height: 16),
                _buildInfoRow(
                  'القراءة الحالية',
                  '${bill.currentReading}',
                  Icons.speed,
                  Colors.grey,
                ),
                const Divider(height: 16),
                _buildInfoRow(
                  'الاستهلاك',
                  '${NumberFormat('#,###').format(bill.powerConsump)} كيلووات',
                  Icons.electric_bolt,
                  Colors.purple,
                ),
                const Divider(height: 16),
                _buildInfoRow(
                  'إجمالي الفاتورة',
                  ' ${NumberFormat('#,###').format(bill.billTotal)} ج.م',
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
        const SizedBox(width: 12),
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
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Show Bill Details Dialog
  void _showBillDetailsDialog(GuageBill bill, AllBills controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تفاصيل الفاتورة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.getMonthName(bill.billMonth)} ${bill.billYear}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
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
      
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Info Section
                      _buildDialogSection(
                        'معلومات الحساب',
                        Icons.account_circle,
                        Colors.blue,
                        [
                          _buildDialogDetailRow(
                            'رقم الحساب',
                            bill.accountNumber,
                            Icons.badge,
                          ),
                          _buildDialogDetailRow(
                            'شهر الفاتورة',
                            controller.getMonthName(bill.billMonth),
                            Icons.calendar_month,
                          ),
                          _buildDialogDetailRow(
                            'سنة الفاتورة',
                            '${bill.billYear}',
                            Icons.calendar_today,
                          ),
                          _buildDialogDetailRow(
                            'حالة الدفع',
                            bill.isPaid == true ? 'مدفوعة' : 'معلقة',
                            bill.isPaid == true ? Icons.check_circle : Icons.pending,
                            valueColor: bill.isPaid == true ? Colors.green : Colors.orange,
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 20),
      
                      // Readings Section
                      _buildDialogSection(
                        'القراءات والاستهلاك',
                        Icons.speed,
                        Colors.purple,
                        [
                          _buildDialogDetailRow(
                            'القراءة السابقة',
                            '${bill.prevReading}',
                            Icons.history,
                          ),
                          _buildDialogDetailRow(
                            'القراءة الحالية',
                            '${bill.currentReading}',
                            Icons.speed,
                          ),
                          _buildDialogDetailRow(
                            'معامل القراءة',
                            '${bill.readingFactor}',
                            Icons.calculate,
                          ),
                          _buildDialogDetailRow(
                            'استهلاك الكهرباء',
                            '${bill.powerConsump} كيلووات',
                            Icons.electric_bolt,
                            valueColor: Colors.purple,
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 20),
      
                      // Financial Details Section
                      _buildDialogSection(
                        'التفاصيل المالية',
                        Icons.attach_money,
                        Colors.green,
                        [
                          _buildDialogDetailRow(
                            'القسط الثابت',
                            '${bill.fixedInstallment.toStringAsFixed(2)} ج.م',
                            Icons.payment,
                          ),
                          _buildDialogDetailRow(
                            'التسويات',
                            '${bill.settlements.toStringAsFixed(2)} ج.م',
                            Icons.account_balance,
                          ),
                          _buildDialogDetailRow(
                            'نسبة التسوية',
                            '${bill.settlementsratio}',
                            Icons.percent,
                          ),
                          _buildDialogDetailRow(
                            'الطوابع',
                            '${bill.stamp.toStringAsFixed(2)} ج.م',
                            Icons.local_post_office,
                          ),
                          _buildDialogDetailRow(
                            'المدفوعات السابقة',
                            '${bill.prevPayments.toStringAsFixed(2)} ج.م',
                            Icons.history,
                          ),
                          _buildDialogDetailRow(
                            'التقريب',
                            '${bill.rounding.toStringAsFixed(2)} ج.م',
                            Icons.rounded_corner,
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 20),
      
                      // Delay Info (if exists)
                      if (bill.delayMonth != null || bill.delayYear != null)
                        _buildDialogSection(
                          'معلومات التأخير',
                          Icons.schedule,
                          Colors.orange,
                          [
                            if (bill.delayMonth != null)
                              _buildDialogDetailRow(
                                'شهر التأخير',
                                '${bill.delayMonth}',
                                Icons.calendar_month,
                              ),
                            if (bill.delayYear != null)
                              _buildDialogDetailRow(
                                'سنة التأخير',
                                '${bill.delayYear}',
                                Icons.calendar_today,
                              ),
                          ],
                        ),
      
                      if (bill.delayMonth != null || bill.delayYear != null)
                        const SizedBox(height: 20),
      
                      // Notes Section (if exists)
                      if (bill.notes != null && bill.notes!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.note, color: Colors.amber.shade700, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ملاحظات',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                bill.notes!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
      
                      if (bill.notes != null && bill.notes!.isNotEmpty)
                        const SizedBox(height: 20),
      
                      // Total Section
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
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.green.shade700,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'إجمالي الفاتورة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              ' ${NumberFormat('#,###').format(bill.billTotal)}ج.م',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              // Footer Actions
             
            ],
          ),
        ),
      ),
    );
  }

  // Build dialog section
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // Build dialog detail row
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
          const SizedBox(width: 12),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}