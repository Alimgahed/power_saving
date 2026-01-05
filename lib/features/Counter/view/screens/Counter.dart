import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/main_card_widgets.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/bill/controller/bills.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/features/bill/model/bills_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
class Counterscreen extends StatelessWidget {
  Counterscreen({super.key});
    final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(controller),
        body: Obx(() => _buildBody(controller)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar( CounterController controller) {
    return AppBar(
      title: Obx(() => controller.isSearching.value
          ? TextField(
              controller: controller.searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ابحث برقم العداد أو الفرع أو رقم الاشتراك...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: controller.onSearchChanged,
            )
          : const Text(
              'قائمة العدادات',
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
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => Get.offNamed('/addCounter'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        "إضافة عداد جديد",
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
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => Get.offNamed('/Addrelation'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        "إضافة ربط جديد",
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
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () => Get.offNamed('/home'),
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

  Widget _buildBody(CounterController controller) {
    // Loading State
    if (controller.looading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'جاري تحميل العدادات...',
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
    if (controller.allcounter.isEmpty) {
      return ReusableEmptyView( message: 'لا توجد عدادات متاحة حالياً');
    }

    // Get display counters
    final displayCounters = controller.filteredCounters.isNotEmpty ||
            controller.searchController.text.isNotEmpty
        ? controller.filteredCounters
        : controller.allcounter;

    // No Search Results
    if (controller.searchController.text.isNotEmpty &&
        displayCounters.isEmpty) {
      return _buildNoResultsState(controller);
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        slivers: [
          // Search Error Message
          if (controller.searchError.value.isNotEmpty)
            SliverToBoxAdapter(
              child: ReusableEmptyView( message: 'لا توجد عدادات مطابقة'),
            ),

          // Header
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child:                   TotalHeader(count: controller.displayCounters.length.toString(), title: 'إجمالي العدادات'),

            ),
          ),

          // Counters Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.50,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _CounterCard(
                    meter: displayCounters[index],
                    globalKey: _globalKey,
                  );
                },
                childCount: displayCounters.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }


 
  Widget _buildNoResultsState( CounterController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد نتائج للبحث',
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

}

// Separate widget to prevent rebuilding all cards
class _CounterCard extends StatelessWidget {
  final ElectricMeter meter;
  final GlobalKey<FormState> globalKey;

  const _CounterCard({
    required this.meter,
    required this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
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
          CardHeader(name: meter.meterId ,height: 50,),
          _buildContent(),
          SizedBox(height: 12),
          _buildFooter(context),
        ],
      ),
    );
  }

 

  Widget _buildContent() {
    return Column(
      children: [
        InfoCard(
          label: 'اسم المحطة',
          value: meter.station ?? 'لا يوجد',
          icon: Icons.location_on_outlined,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 8),
        InfoCard(
          label: 'اسم الفرع',
          value: meter.branch ?? 'لا يوجد',
          icon: Icons.business,
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        InfoCard(
          label: 'رقم الحساب',
          value: meter.accountNumber ?? 'غير محدد',
          icon: Icons.account_balance,
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        InfoCard(
        
          label: 'جهد العداد', value: meter.voltageType ?? 'غير محدد', icon: Icons.electric_bolt_rounded, color: Colors.orange,
        ),
        const SizedBox(height: 8),
        InfoCard(

           label: 'القراءة النهائية',
          value: meter.finalReading?.toString() ?? '0',
          icon: Icons.speed,
          color: Colors.cyan,
        ),
        const SizedBox(height: 8),
        InfoCard(
          label: 'معامل العداد',
          value: meter.meterFactor?.toString() ?? '0',
          icon: Icons.calculate,
          color: Colors.purple,
        ),
      ],
    );
  }

 

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.offNamed(
                  '/editMeter',
                  arguments: {"meter": meter},
                );
              },
              icon: const Icon(Icons.edit, size: 12),
              label: const Text(
                'تعديل',
                style: TextStyle(fontSize: 11),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async{
                  Get.put(Bills()).onInit();
                                              final bill =  Get.put(
                                                Bills(),
                                              );
                                              await bill.newbill(
                                                meter.accountNumber!,
                                              );

                // Your bill logic here
                // ignore: use_build_context_synchronously
                _handleNewBill(context, bill, globalKey);
              },
              icon: const Icon(Icons.receipt, size: 12),
              label: const Text(
                'فاتورة جديدة',
                style: TextStyle(fontSize: 11),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNewBill(BuildContext context,Bills bill,GlobalKey<FormState> globalKey) {
    
    
    // Keep your existing bill dialog logic here
    // For now, just show a placeholder
  
        
                                              if (bill.gauges.isNotEmpty) {
                                                showDialog(
                                                  // ignore: use_build_context_synchronously
                                                  context: context,
                                                  builder: (context) {
                                                    // Initialize controllers properly based on gauges length

                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets
                                                              .zero, // Remove default padding
                                                      content: GetBuilder<
                                                        Bills
                                                      >(
                                                        init: Bills(),
                                                        builder: (
                                                          billsController,
                                                        ) {
                                                          billsController
                                                                  .briefReadingController =
                                                              TextEditingController(
                                                                text:
                                                                    meter
                                                                        .finalReading
                                                                        .toString(),
                                                              );
                                                          billsController
                                                              .calculatedEnergyCost
                                                              .value = meter
                                                                  .price!
                                                                  .toDouble();
                                                          billsController
                                                              .fixed
                                                              .value = meter
                                                                  .fixedprice!
                                                                  .toDouble();

                                                          billsController
                                                                  .readingFactorController =
                                                              TextEditingController(
                                                                text:
                                                                    meter
                                                                        .meterFactor
                                                                        .toString(),
                                                              );

                                                          return SingleChildScrollView(
                                                            child: Form(
                                                              key: globalKey,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // Header Container - No padding from dialog
                                                                  Container(
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          24,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Colors
                                                                              .blue
                                                                              .shade600,
                                                                          Colors
                                                                              .blue
                                                                              .shade800,
                                                                        ],
                                                                        begin:
                                                                            Alignment.topLeft,
                                                                        end:
                                                                            Alignment.bottomRight,
                                                                      ),
                                                                      borderRadius: const BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                              16,
                                                                            ),
                                                                        topRight:
                                                                            Radius.circular(
                                                                              16,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.white.withOpacity(
                                                                              0.2,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              50,
                                                                            ),
                                                                          ),
                                                                          child: const Icon(
                                                                            Icons.receipt_long,
                                                                            size:
                                                                                32,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        Text(
                                                                          "تسجيل فاتورة جديدة للعداد ${meter.accountNumber}",
                                                                          style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          'أدخل بيانات الفاتورة والقراءات',
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Colors.white.withOpacity(
                                                                              0.9,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // Content with padding
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          24.0,
                                                                        ),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),

                                                                        // Row 1
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'القراءة السابقة',
                                                                                hintText:
                                                                                    'أدخل القراءة السابقة',
                                                                                icon:
                                                                                    Icons.history,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.briefReadingController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'القراءة الحالية',
                                                                                hintText:
                                                                                    'أدخل القراءة الحالية',
                                                                                icon:
                                                                                    Icons.read_more,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.currentReadingController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'معامل العداد',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                hintText:
                                                                                    'معامل العداد',
                                                                                icon:
                                                                                    Icons.linear_scale,
                                                                                controller:
                                                                                    billsController.readingFactorController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'الاستهلاك الكلي',
                                                                                hintText:
                                                                                    'أدخل كمية الاستهلاك',
                                                                                icon:
                                                                                    Icons.flash_on,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.powerConsumpController,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),

                                                                        // Row 2
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'القسط الثابت',
                                                                                hintText:
                                                                                    'أدخل القسط الثابت',
                                                                                icon:
                                                                                    Icons.lock,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.fixedInstallmentController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'التسويات والاقساط',
                                                                                hintText:
                                                                                    'أدخل التسويات والاقساط',
                                                                                icon:
                                                                                    Icons.tune,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.settlementsController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),

                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'كميات التسويات',
                                                                                hintText:
                                                                                    'أدخل التسويات والاقساط',
                                                                                icon:
                                                                                    Icons.tune,
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                controller:
                                                                                    billsController.settlementsControllerratio,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'الرسوم والدمغات',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                hintText:
                                                                                    'أدخل الرسوم والدمغات',
                                                                                icon:
                                                                                    Icons.payment,
                                                                                controller:
                                                                                    billsController.stampController,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),

                                                                        // Row 3
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'فروق التقريب',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                hintText:
                                                                                    'أدخل قيمة فروق التقريب',
                                                                                icon:
                                                                                    Icons.rounded_corner,
                                                                                controller:
                                                                                    billsController.roundingController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'دفعات تخصم',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                hintText:
                                                                                    'أدخل الدفعات المخصومة',
                                                                                icon:
                                                                                    Icons.payments,
                                                                                controller:
                                                                                    billsController.prevPaymentsController,
                                                                              ),
                                                                            ),

                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'الشهر',
                                                                                hintText:
                                                                                    'أدخل الشهر',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                icon:
                                                                                    Icons.date_range,
                                                                                controller:
                                                                                    billsController.billMonthController,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  8,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'السنة',
                                                                                hintText:
                                                                                    'أدخل السنة',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                icon:
                                                                                    Icons.date_range,
                                                                                controller:
                                                                                    billsController.billyearController,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'قيمة المطالبة',
                                                                                allowOnlyDigits:
                                                                                    true,
                                                                                hintText:
                                                                                    'أدخل قيمة المطالبة',
                                                                                icon:
                                                                                    Icons.receipt_long,
                                                                                controller:
                                                                                    billsController.billTotalController,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  10,
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomTextFormField(
                                                                                label:
                                                                                    'الملاحظات',

                                                                                hintText:
                                                                                    'ادخل الملاحظات',
                                                                                icon:
                                                                                    Icons.note_add,
                                                                                useValidator:
                                                                                    false,
                                                                                controller:
                                                                                    billsController.notes,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Row(
                                                                                children: [
                                                                                  Obx(
                                                                                    () => Checkbox(
                                                                                      checkColor:
                                                                                          Colors.white,
                                                                                      activeColor:
                                                                                          Colors.blue,

                                                                                      value:
                                                                                          billsController.isPaid.value,
                                                                                      onChanged: (
                                                                                        val,
                                                                                      ) {
                                                                                        billsController.isPaid.value =
                                                                                            val ??
                                                                                            false;
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  const Text(
                                                                                    'مسدد',
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Row(
                                                                                children: [
                                                                                  Obx(
                                                                                    () => Checkbox(
                                                                                      checkColor:
                                                                                          Colors.white,
                                                                                      activeColor:
                                                                                          Colors.blue,
                                                                                      value:
                                                                                          billsController.isPaid.value ==
                                                                                          false,
                                                                                      onChanged: (
                                                                                        val,
                                                                                      ) {
                                                                                        billsController.isPaid.value = false;
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  const Text(
                                                                                    'مرحل',
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Obx(() {
                                                                          return billsController.isPaid.value ==
                                                                                  false
                                                                              ? Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: CustomTextFormField(
                                                                                      controller:
                                                                                          billsController.delayMonthController,
                                                                                      allowOnlyDigits:
                                                                                          true,
                                                                                      label:
                                                                                          "شهر الترحيل",
                                                                                      icon:
                                                                                          Icons.calendar_today,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:
                                                                                        10,
                                                                                  ),

                                                                                  Expanded(
                                                                                    child: CustomTextFormField(
                                                                                      allowOnlyDigits:
                                                                                          true,
                                                                                      label:
                                                                                          "سنة الترحيل",
                                                                                      controller:
                                                                                          billsController.delayYearController,
                                                                                      icon:
                                                                                          Icons.calendar_today,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                              : SizedBox.shrink();
                                                                        }),

                                                                        // Gauges Section
                                                                        // Column(
                                                                        //   crossAxisAlignment:
                                                                        //       CrossAxisAlignment.start,
                                                                        //   children: [
                                                                        //     if (billsController.showPercent ==
                                                                        //         true) ...[
                                                                        //       const SizedBox(
                                                                        //         height:
                                                                        //             16,
                                                                        //       ),
                                                                        //       const Text(
                                                                        //         "نسب العدادت",
                                                                        //         style: TextStyle(
                                                                        //           fontSize:
                                                                        //               16,
                                                                        //           fontWeight:
                                                                        //               FontWeight.bold,
                                                                        //         ),
                                                                        //       ),
                                                                        //       const SizedBox(
                                                                        //         height:
                                                                        //             8,
                                                                        //       ),
                                                                        //       ...billsController.gauges.asMap().entries.map(
                                                                        //         (
                                                                        //           entry,
                                                                        //         ) {
                                                                        //           int index =
                                                                        //               entry.key;
                                                                        //           var gauge =
                                                                        //               entry.value;

                                                                        //           return Padding(
                                                                        //             padding: const EdgeInsets.only(
                                                                        //               bottom:
                                                                        //                   8.0,
                                                                        //             ),
                                                                        //             child: Row(
                                                                        //               children: [
                                                                        //                 Expanded(
                                                                        //                   flex:
                                                                        //                       2,
                                                                        //                   child: Row(
                                                                        //                     children: [
                                                                        //                       Text(
                                                                        //                         gauge.stationName ??
                                                                        //                             'غير محدد',
                                                                        //                         style: const TextStyle(
                                                                        //                           fontWeight:
                                                                        //                               FontWeight.bold,
                                                                        //                           fontSize:
                                                                        //                               16,
                                                                        //                         ),
                                                                        //                       ),
                                                                        //                       const SizedBox(
                                                                        //                         width:
                                                                        //                             10,
                                                                        //                       ),
                                                                        //                       const Text(
                                                                        //                         "(المحطة)",
                                                                        //                         style: TextStyle(
                                                                        //                           fontSize:
                                                                        //                               16,
                                                                        //                           color:
                                                                        //                               Colors.grey,
                                                                        //                         ),
                                                                        //                       ),
                                                                        //                     ],
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 const SizedBox(
                                                                        //                   width:
                                                                        //                       10,
                                                                        //                 ),
                                                                        //                 Expanded(
                                                                        //                   flex:
                                                                        //                       2,
                                                                        //                   child: Row(
                                                                        //                     children: [
                                                                        //                       Text(
                                                                        //                         gauge.technologyName ??
                                                                        //                             'غير محدد',
                                                                        //                         style: const TextStyle(
                                                                        //                           fontWeight:
                                                                        //                               FontWeight.bold,
                                                                        //                           fontSize:
                                                                        //                               16,
                                                                        //                         ),
                                                                        //                       ),
                                                                        //                       const SizedBox(
                                                                        //                         width:
                                                                        //                             10,
                                                                        //                       ),
                                                                        //                       const Text(
                                                                        //                         "(التكنولوجيا)",
                                                                        //                         style: TextStyle(
                                                                        //                           fontSize:
                                                                        //                               16,
                                                                        //                           color:
                                                                        //                               Colors.grey,
                                                                        //                         ),
                                                                        //                       ),
                                                                        //                     ],
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 const SizedBox(
                                                                        //                   width:
                                                                        //                       10,
                                                                        //                 ),
                                                                        //                 Expanded(
                                                                        //                   flex:
                                                                        //                       3,
                                                                        //                   child: CustomTextFormField(
                                                                        //                     controller:
                                                                        //                         billsController.powerControllers[index],
                                                                        //                     label:
                                                                        //                         "كمية الطاقة",
                                                                        //                     icon:
                                                                        //                         Icons.electric_bolt_sharp,
                                                                        //                     hintText:
                                                                        //                         "أدخل كمية الطاقة",
                                                                        //                     allowOnlyDigits:
                                                                        //                         true,
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 SizedBox(
                                                                        //                   width:
                                                                        //                       10,
                                                                        //                 ),
                                                                        //                 Expanded(
                                                                        //                   flex:
                                                                        //                       3,
                                                                        //                   child: CustomTextFormField(
                                                                        //                     controller:
                                                                        //                         billsController.moneyControllers[index],
                                                                        //                     label:
                                                                        //                         "قيمة المبلغ",
                                                                        //                     icon:
                                                                        //                         Icons.attach_money,
                                                                        //                     hintText:
                                                                        //                         "أدخل قيمة المبلغ",
                                                                        //                     allowOnlyDigits:
                                                                        //                         true,
                                                                        //                   ),
                                                                        //                 ),
                                                                        //               ],
                                                                        //             ),
                                                                        //           );
                                                                        //         },
                                                                        //       ).toList(),
                                                                        //     ],
                                                                        //   ],
                                                                        // ),,
                                                                        const SizedBox(
                                                                          height:
                                                                              24,
                                                                        ),

                                                                        Obx(() {
                                                                          return billsController.isLoading.value
                                                                              ? Center(
                                                                                child: CircularProgressIndicator(
                                                                                  color:
                                                                                      Colors.blue,
                                                                                ),
                                                                              )
                                                                              : Center(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    if (globalKey.currentState!.validate()) {
                                                                                      // Collect and parse ratio values
                                                                                      List<
                                                                                        double
                                                                                      >
                                                                                      percentMoney =
                                                                                          [];
                                                                                      List<
                                                                                        double
                                                                                      >
                                                                                      percentPower =
                                                                                          [];

                                                                                      final String accountNumber =
                                                                                          meter.accountNumber!;
                                                                                      final int billMonth =
                                                                                          billsController.billMonthController.text.isEmpty
                                                                                              ? 0
                                                                                              : int.tryParse(
                                                                                                    billsController.billMonthController.text,
                                                                                                  ) ??
                                                                                                  0;

                                                                                      final int billYear =
                                                                                          billsController.billyearController.text.isEmpty
                                                                                              ? 0
                                                                                              : int.tryParse(
                                                                                                    billsController.billyearController.text,
                                                                                                  ) ??
                                                                                                  0;

                                                                                      final double prevReading =
                                                                                          double.tryParse(
                                                                                            billsController.briefReadingController.text,
                                                                                          ) ??
                                                                                          0;
                                                                                      final double currentReading =
                                                                                          double.tryParse(
                                                                                            billsController.currentReadingController.text,
                                                                                          ) ??
                                                                                          0;

                                                                                      final double readingFactor =
                                                                                          double.tryParse(
                                                                                            billsController.readingFactorController.text,
                                                                                          ) ??
                                                                                          0;
                                                                                      final double powerConsump =
                                                                                          double.tryParse(
                                                                                            billsController.powerConsumpController.text,
                                                                                          ) ??
                                                                                          0;
                                                                                      final double fixedInstallment =
                                                                                          double.tryParse(
                                                                                            billsController.fixedInstallmentController.text,
                                                                                          ) ??
                                                                                          0.0;

                                                                                      final double settlementsControllerratio =
                                                                                          double.tryParse(
                                                                                            billsController.settlementsControllerratio.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      final double settlements =
                                                                                          double.tryParse(
                                                                                            billsController.settlementsController.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      final double stamp =
                                                                                          double.tryParse(
                                                                                            billsController.stampController.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      final double prevPayments =
                                                                                          double.tryParse(
                                                                                            billsController.prevPaymentsController.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      final double rounding =
                                                                                          double.tryParse(
                                                                                            billsController.roundingController.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      final double billTotal =
                                                                                          double.tryParse(
                                                                                            billsController.billTotalController.text,
                                                                                          ) ??
                                                                                          0.0;
                                                                                      if (billsController.powerControllers.isNotEmpty) {
                                                                                        for (var ratioController in billsController.powerControllers) {
                                                                                          double ratio =
                                                                                              double.tryParse(
                                                                                                ratioController.text,
                                                                                              ) ??
                                                                                              0.0;
                                                                                          percentPower.add(
                                                                                            ratio,
                                                                                          );
                                                                                        }
                                                                                        if (billsController.moneyControllers.isNotEmpty) {
                                                                                          for (var ratioController in billsController.moneyControllers) {
                                                                                            double ratio =
                                                                                                double.tryParse(
                                                                                                  ratioController.text,
                                                                                                ) ??
                                                                                                0.0;
                                                                                            percentMoney.add(
                                                                                              ratio,
                                                                                            );
                                                                                          }
                                                                                        }

                                                                                        // Check if sum of ratios is 100
                                                                                      }

                                                                                      final bool isPaid =
                                                                                          billsController.isPaid.value;

                                                                                      if (billMonth <
                                                                                              1 ||
                                                                                          billMonth >
                                                                                              12) {
                                                                                        showCustomErrorDialog(
                                                                                          errorMessage:
                                                                                              "الشهر يجب أن يكون بين 1 و 12",
                                                                                        );
                                                                                        return;
                                                                                      }

                                                                                      if (billYear <
                                                                                              2000 ||
                                                                                          billYear >
                                                                                              DateTime.now().year) {
                                                                                        showCustomErrorDialog(
                                                                                          errorMessage:
                                                                                              "السنة يجب أن تكون بين 2000 و ${DateTime.now().year}",
                                                                                        );
                                                                                        return;
                                                                                      }
                                                                                      int? delayYear;
                                                                                      int? delayMonth;
                                                                                      if (isPaid ==
                                                                                          false) {
                                                                                        delayYear = int.tryParse(
                                                                                          billsController.delayYearController.text,
                                                                                        );
                                                                                        delayMonth = int.tryParse(
                                                                                          billsController.delayMonthController.text,
                                                                                        );
                                                                                      }

                                                                                      // Add ratios to controller
                                                                                      billsController.addnewbill(
                                                                                        number:
                                                                                            accountNumber,
                                                                                        bill: GuageBill(
                                                                                          delayYear:
                                                                                              delayYear,
                                                                                          delayMonth:
                                                                                              delayMonth,
                                                                                          settlementsratio:
                                                                                              settlementsControllerratio,
                                                                                          accountNumber:
                                                                                              accountNumber,
                                                                                          billMonth:
                                                                                              billMonth,
                                                                                          billYear:
                                                                                              billYear,
                                                                                          prevReading:
                                                                                              prevReading,
                                                                                          currentReading:
                                                                                              currentReading,
                                                                                          readingFactor:
                                                                                              readingFactor,
                                                                                          powerConsump:
                                                                                              powerConsump,
                                                                                          fixedInstallment:
                                                                                              fixedInstallment,
                                                                                          settlements:
                                                                                              settlements,
                                                                                          stamp:
                                                                                              stamp,
                                                                                          prevPayments:
                                                                                              prevPayments,
                                                                                          rounding:
                                                                                              rounding,
                                                                                          billTotal:
                                                                                              billTotal,
                                                                                          isPaid:
                                                                                              isPaid,
                                                                                          notes:
                                                                                              billsController.notes.text,
                                                                                          percentMoney:
                                                                                              percentMoney,
                                                                                          percentPower:
                                                                                              percentPower,
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    "تسجيل الفاتورة",
                                                                                  ),
                                                                                ),
                                                                              );
                                                                        }),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ).then((_) {
                                                  Get.find<Bills>().onClose();
                                                });
                                              } else {
                                                showCustomErrorDialog(
                                                  errorMessage:
                                                      "لا يوجد عدادات محطات مرتبطة بهذا الحساب",
                                                );
                                              }           
  }
}