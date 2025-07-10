import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/bills/bills.dart';
import 'package:power_saving/controller/counter/counter.dart';
import 'package:power_saving/model/bills_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Counterscreen extends StatelessWidget {
  Counterscreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'قائمة العدادات',
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
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.offNamed('/addCounter');
                    },
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
                  const SizedBox(width: 12),
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
        body: GetBuilder<Counter_controller>(
          init: Counter_controller(),
          builder: (controller) {
            if (controller.allcounter.isEmpty) {
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
                        Icons.electric_meter,
                        size: 48,
                        color: Colors.blue.shade300,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'لا توجد عدادات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ابدأ بإضافة عداد جديد',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
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
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.electric_meter,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'إجمالي العدادات',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${controller.allcounter.length} عداد',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Grid Section
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.allcounter.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.78,
                        ),
                    itemBuilder: (context, index) {
                      final meter = controller.allcounter[index];
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
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade700,
                                  ],
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
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.electric_meter,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      meter.meterId,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Meter Info Section
                                    _buildMeterInfoSection(meter),
                                    const SizedBox(height: 8),

                                    // Meter Details
                                    _buildMeterDetailsSection(meter),
                                  ],
                                ),
                              ),
                            ),

                            // Footer
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Edit Button
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Get.offNamed(
                                        '/editMeter',
                                        arguments: {"meter": meter},
                                      );
                                    },
                                    icon: const Icon(Icons.edit, size: 14),
                                    label: const Text(
                                      'تعديل',
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
                                        vertical: 6,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  // New Bill Button
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final Bill = Get.put(Bills());
                                      await Bill.newbill(meter.accountNumber!);
                                      if (Bill.gauges.isNotEmpty) {
                                        showDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          builder: (context) {
                                            // Initialize controllers properly based on gauges length

                                            return AlertDialog(
                                              content: GetBuilder<Bills>(
                                                builder: (controller) {
                                                  return SingleChildScrollView(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16,
                                                        ),
                                                    child: Form(
                                                      key: _globalKey,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "تسجيل فاتورة جديدة للعداد ${meter.accountNumber}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
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
                                                                      Icons
                                                                          .history,
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  controller:
                                                                      controller
                                                                          .briefReadingController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: CustomTextFormField(
                                                                  label:
                                                                      'القراءة الحالية',
                                                                  hintText:
                                                                      'أدخل القراءة الحالية',
                                                                  icon:
                                                                      Icons
                                                                          .read_more,
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  controller:
                                                                      controller
                                                                          .currentReadingController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
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
                                                                      Icons
                                                                          .linear_scale,
                                                                  controller:
                                                                      controller
                                                                          .readingFactorController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: CustomTextFormField(
                                                                  label:
                                                                      'الاستهلاك الكلي',
                                                                  hintText:
                                                                      'أدخل كمية الاستهلاك',
                                                                  icon:
                                                                      Icons
                                                                          .flash_on,
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  controller:
                                                                      controller
                                                                          .powerConsumpController,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
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
                                                                      Icons
                                                                          .lock,
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  controller:
                                                                      controller
                                                                          .fixedInstallmentController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: CustomTextFormField(
                                                                  label:
                                                                      'التسويات والاقساط',
                                                                  hintText:
                                                                      'أدخل التسويات والاقساط',
                                                                  icon:
                                                                      Icons
                                                                          .tune,
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  controller:
                                                                      controller
                                                                          .settlementsController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
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
                                                                      Icons
                                                                          .payment,
                                                                  controller:
                                                                      controller
                                                                          .stampController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
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
                                                                      Icons
                                                                          .payments,
                                                                  controller:
                                                                      controller
                                                                          .prevPaymentsController,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
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
                                                                      Icons
                                                                          .rounded_corner,
                                                                  controller:
                                                                      controller
                                                                          .roundingController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: CustomTextFormField(
                                                                  label:
                                                                      'قيمة المطالبة',
                                                                  allowOnlyDigits:
                                                                      true,
                                                                  hintText:
                                                                      'أدخل قيمة المطالبة',
                                                                  icon:
                                                                      Icons
                                                                          .receipt_long,
                                                                  controller:
                                                                      controller
                                                                          .billTotalController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
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
                                                                      Icons
                                                                          .date_range,
                                                                  controller:
                                                                      controller
                                                                          .billMonthController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
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
                                                                      Icons
                                                                          .date_range,
                                                                  controller:
                                                                      controller
                                                                          .billyearController,
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          // Gauges Section
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (controller
                                                                      .showPercent ==
                                                                  true) ...[
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                const Text(
                                                                  "نسب العدادت",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                ...controller.gauges.asMap().entries.map((
                                                                  entry,
                                                                ) {
                                                                  int index =
                                                                      entry.key;
                                                                  var gauge =
                                                                      entry
                                                                          .value;

                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          bottom:
                                                                              8.0,
                                                                        ),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                gauge.stationName ??
                                                                                    'غير محدد',
                                                                                style: const TextStyle(
                                                                                  fontWeight:
                                                                                      FontWeight.bold,
                                                                                  fontSize:
                                                                                      16,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width:
                                                                                    10,
                                                                              ),
                                                                              const Text(
                                                                                "(المحطة)",
                                                                                style: TextStyle(
                                                                                  fontSize:
                                                                                      16,
                                                                                  color:
                                                                                      Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                gauge.technologyName ??
                                                                                    'غير محدد',
                                                                                style: const TextStyle(
                                                                                  fontWeight:
                                                                                      FontWeight.bold,
                                                                                  fontSize:
                                                                                      16,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width:
                                                                                    10,
                                                                              ),
                                                                              const Text(
                                                                                "(التكنولوجيا)",
                                                                                style: TextStyle(
                                                                                  fontSize:
                                                                                      16,
                                                                                  color:
                                                                                      Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child: CustomTextFormField(
                                                                            controller:
                                                                                controller.ratioControllers[index],
                                                                            label:
                                                                                "النسبة",
                                                                            hintText:
                                                                                "أدخل النسبة",
                                                                            allowOnlyDigits:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ],
                                                            ],
                                                          ),

                                                          const SizedBox(
                                                            height: 24,
                                                          ),

                                                          Obx(() {
                                                            return Center(
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  if (_globalKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    // Collect and parse ratio values
                                                                    List<double>
                                                                    ratios = [];
                                                                    if (controller
                                                                        .ratioControllers
                                                                        .isNotEmpty) {
                                                                      for (var ratioController
                                                                          in controller
                                                                              .ratioControllers) {
                                                                        double
                                                                        ratio =
                                                                            double.tryParse(
                                                                              ratioController.text,
                                                                            ) ??
                                                                            0.0;
                                                                        ratios.add(
                                                                          ratio,
                                                                        );
                                                                      }
                                                                      // Check if sum of ratios is 100
                                                                      double
                                                                      sum = ratios
                                                                          .fold(
                                                                            0,
                                                                            (
                                                                              a,
                                                                              b,
                                                                            ) =>
                                                                                a +
                                                                                b,
                                                                          );
                                                                      if (sum !=
                                                                          100) {
                                                                        showCustomErrorDialog(
                                                                          errorMessage:
                                                                              "يجب مجموع النسب يكون 100 %",
                                                                        );
                                                                        return;
                                                                      }
                                                                    }

                                                                    final String
                                                                    accountNumber =
                                                                        meter
                                                                            .accountNumber!;
                                                                    final int
                                                                    billMonth =
                                                                        controller.billMonthController.text.isEmpty
                                                                            ? 0
                                                                            : int.tryParse(
                                                                                  controller.billMonthController.text,
                                                                                ) ??
                                                                                0;

                                                                    final int
                                                                    billYear =
                                                                        controller.billyearController.text.isEmpty
                                                                            ? 0
                                                                            : int.tryParse(
                                                                                  controller.billyearController.text,
                                                                                ) ??
                                                                                0;

                                                                    final int
                                                                    prevReading =
                                                                        int.tryParse(
                                                                          controller
                                                                              .briefReadingController
                                                                              .text,
                                                                        ) ??
                                                                        0;
                                                                    final int
                                                                    currentReading =
                                                                        int.tryParse(
                                                                          controller
                                                                              .currentReadingController
                                                                              .text,
                                                                        ) ??
                                                                        0;

                                                                    final int
                                                                    readingFactor =
                                                                        int.tryParse(
                                                                          controller
                                                                              .readingFactorController
                                                                              .text,
                                                                        ) ??
                                                                        0;
                                                                    final int
                                                                    powerConsump =
                                                                        int.tryParse(
                                                                          controller
                                                                              .powerConsumpController
                                                                              .text,
                                                                        ) ??
                                                                        0;

                                                                    final double
                                                                    fixedInstallment =
                                                                        double.tryParse(
                                                                          controller
                                                                              .fixedInstallmentController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;
                                                                    final double
                                                                    settlements =
                                                                        double.tryParse(
                                                                          controller
                                                                              .settlementsController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;
                                                                    final double
                                                                    stamp =
                                                                        double.tryParse(
                                                                          controller
                                                                              .stampController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;
                                                                    final double
                                                                    prevPayments =
                                                                        double.tryParse(
                                                                          controller
                                                                              .prevPaymentsController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;
                                                                    final double
                                                                    rounding =
                                                                        double.tryParse(
                                                                          controller
                                                                              .roundingController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;
                                                                    final double
                                                                    billTotal =
                                                                        double.tryParse(
                                                                          controller
                                                                              .billTotalController
                                                                              .text,
                                                                        ) ??
                                                                        0.0;

                                                                    final bool
                                                                    isPaid =
                                                                        false;

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

                                                                    // Add ratios to controller

                                                                    controller.addnewbill(
                                                                      number:
                                                                          accountNumber,
                                                                      bill: GuageBill(
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
                                                                        ratios:
                                                                            ratios, // Add this to your model if needed
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    controller
                                                                            .isLoading
                                                                            .value
                                                                        ? const SizedBox(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child: CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                2,
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                        )
                                                                        : const Text(
                                                                          "تسجيل الفاتورة",
                                                                        ),
                                                              ),
                                                            );
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        showCustomErrorDialog(
                                          errorMessage:
                                              "لا يوجد عدادات مرتبطة بهذا الحساب",
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.receipt, size: 14),
                                    label: const Text(
                                      'فاتورة جديدة',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
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
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMeterInfoSection(dynamic meter) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.purple),
              const SizedBox(width: 6),
              const Text(
                'معلومات العداد',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            'رقم الحساب',
            meter.accountNumber ?? 'غير محدد',
            Icons.account_balance,
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoItem(
            'جهد العداد',
            meter.voltageType ?? 'غير محدد',
            Icons.electric_bolt_rounded,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildMeterDetailsSection(dynamic meter) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, size: 16, color: Colors.orange),
              const SizedBox(width: 6),
              const Text(
                'تفاصيل العداد',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'القراءة النهائية',
                  meter.finalReading.toString(),
                  Icons.speed,
                  Colors.cyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDetailItem(
                  'معامل العداد',
                  meter.meterFactor.toString(),
                  Icons.calculate,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
