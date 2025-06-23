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
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة العدادات'),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Get.offNamed('/addCounter');
                },
                child: const Text(
                  "اضافة عداد جديد",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Get.offNamed('/home');
                },
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<Counter_controller>(
        init: Counter_controller(),
        builder: (controller) {
          return GridView.builder(
            itemCount: controller.allcounter.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.73,
            ),
            itemBuilder: (context, index) {
              final meter = controller.allcounter[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meter.voltageType!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "تفاصيل العداد",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        infoRowWidget('رقم الحساب', meter.accountNumber!),

                        infoRowWidget(
                          'القراءة النهائية',
                          meter.finalReading.toString(),
                        ),
                        infoRowWidget(
                          'معامل العداد',
                          meter.meterFactor.toString(),
                        ),
                        infoRowWidget('معرّف العداد', meter.meterId),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Implement navigation to edit screen with meter as argument
                                Get.offNamed(
                                  '/editMeter',
                                  arguments: {"meter": meter},
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                // ignore: non_constant_identifier_names
                                final Bill = Get.put(Bills());
                                await Bill.newbill(meter.accountNumber!);

                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (context) {
                                    // Initialize controllers properly based on gauges length

                                    return AlertDialog(
                                      content: GetBuilder<Bills>(
                                        builder: (controller) {
                                          return SingleChildScrollView(
                                            padding: const EdgeInsets.all(16),
                                            child: Form(
                                              key: _globalKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "تسجيل فاتورة جديدة للعداد ${meter.accountNumber}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Row 1
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'القراءة السابقة',
                                                          hintText:
                                                              'أدخل القراءة السابقة',
                                                          icon: Icons.history,
                                                          allowOnlyDigits: true,
                                                          controller:
                                                              controller
                                                                  .briefReadingController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'القراءة الحالية',
                                                          hintText:
                                                              'أدخل القراءة الحالية',
                                                          icon: Icons.read_more,
                                                          allowOnlyDigits: true,
                                                          controller:
                                                              controller
                                                                  .currentReadingController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'معامل العداد',
                                                          allowOnlyDigits: true,
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
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'الاستهلاك الكلي',
                                                          hintText:
                                                              'أدخل كمية الاستهلاك',
                                                          icon: Icons.flash_on,
                                                          allowOnlyDigits: true,
                                                          controller:
                                                              controller
                                                                  .powerConsumpController,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Row 2
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'القسط الثابت',
                                                          hintText:
                                                              'أدخل القسط الثابت',
                                                          icon: Icons.lock,
                                                          allowOnlyDigits: true,
                                                          controller:
                                                              controller
                                                                  .fixedInstallmentController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'التسويات والاقساط',
                                                          hintText:
                                                              'أدخل التسويات والاقساط',
                                                          icon: Icons.tune,
                                                          allowOnlyDigits: true,
                                                          controller:
                                                              controller
                                                                  .settlementsController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'الرسوم والدمغات',
                                                          allowOnlyDigits: true,
                                                          hintText:
                                                              'أدخل الرسوم والدمغات',
                                                          icon: Icons.payment,
                                                          controller:
                                                              controller
                                                                  .stampController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'دفعات تخصم',
                                                          allowOnlyDigits: true,
                                                          hintText:
                                                              'أدخل الدفعات المخصومة',
                                                          icon: Icons.payments,
                                                          controller:
                                                              controller
                                                                  .prevPaymentsController,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Row 3
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'فروق التقريب',
                                                          allowOnlyDigits: true,
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
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label:
                                                              'قيمة المطالبة',
                                                          allowOnlyDigits: true,
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
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'الشهر',
                                                          hintText:
                                                              'أدخل الشهر',
                                                          allowOnlyDigits: true,
                                                          icon:
                                                              Icons.date_range,
                                                          controller:
                                                              controller
                                                                  .billMonthController,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomTextFormField(
                                                          label: 'السنة',
                                                          hintText:
                                                              'أدخل السنة',
                                                          allowOnlyDigits: true,
                                                          icon:
                                                              Icons.date_range,
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
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        ...controller.gauges.asMap().entries.map((
                                                          entry,
                                                        ) {
                                                          int index = entry.key;
                                                          var gauge =
                                                              entry.value;

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 8.0,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
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
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
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
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: CustomTextFormField(
                                                                    controller:
                                                                        controller
                                                                            .ratioControllers[index],
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

                                                  const SizedBox(height: 24),

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
                                                                double ratio =
                                                                    double.tryParse(
                                                                      ratioController
                                                                          .text,
                                                                    ) ??
                                                                    0.0;
                                                                ratios.add(
                                                                  ratio,
                                                                );
                                                              }
                                                              // Check if sum of ratios is 100
                                                              double sum =
                                                                  ratios.fold(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b,
                                                                  );
                                                              if (sum != 100) {
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
                                                                controller
                                                                        .billMonthController
                                                                        .text
                                                                        .isEmpty
                                                                    ? 0
                                                                    : int.tryParse(
                                                                          controller
                                                                              .billMonthController
                                                                              .text,
                                                                        ) ??
                                                                        0;

                                                            final int billYear =
                                                                controller
                                                                        .billyearController
                                                                        .text
                                                                        .isEmpty
                                                                    ? 0
                                                                    : int.tryParse(
                                                                          controller
                                                                              .billyearController
                                                                              .text,
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
                                                            final double stamp =
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

                                                            final bool isPaid =
                                                                false;

                                                            if (billMonth < 1 ||
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
                                                                    DateTime.now()
                                                                        .year) {
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
                                                                stamp: stamp,
                                                                prevPayments:
                                                                    prevPayments,
                                                                rounding:
                                                                    rounding,
                                                                billTotal:
                                                                    billTotal,
                                                                isPaid: isPaid,
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
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color:
                                                                        Colors
                                                                            .blue,
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
                              },
                              child: Text(
                                "تسجيل فاتورة جديدة",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
