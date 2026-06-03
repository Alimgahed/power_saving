import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/controller/tech_bills/edit_techbills.dart';
import 'package:power_saving/features/tech_bills/model/tech_bill.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

class EditTechBills extends StatelessWidget {
  const EditTechBills({super.key});

  @override
  Widget build(BuildContext context) {
    const appBarWidget = CustomAppBar(
      title: 'تعديل فاتورة التقنية',
      backRoute: '/home',
    );

    return AppScaffold(
      title: 'تعديل فاتورة التقنية',
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: GetBuilder<EditTechbillsController>(
          init: EditTechbillsController(),
          builder: (controller) {
            // Get the bill from arguments
            final args = Get.arguments;
            TechnologyBill bill = args?['bill'];

            controller.chlorineController.text =
                bill.technologyChlorineConsump.toString();
            controller.liquidAlumController.text =
                bill.technologyLiquidAlumConsump.toString();
            controller.solidAlumController.text =
                bill.technologySolidAlumConsump.toString();
            controller.waterProducedController.text =
                bill.technologyWaterAmount.toString();
            controller.calculatedWaterController.text =
                bill.calculatedWater.toString();
            controller.measuredWaterController.text =
                bill.measuredWater.toString();

            return Obx(() {
              if (controller.looading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Bill Info Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Card Header
                              Container(
                                padding: const EdgeInsets.all(24),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.engineering,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'معلومات الفاتورة',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                bill.stationName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: _buildInfoRow(
                                              'التقنية',
                                              bill.technologyName,
                                              Icons.settings,
                                            ),
                                          ),
                                          Container(
                                            height: 24,
                                            width: 1,
                                            color: Colors.white24,
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          Expanded(
                                            child: _buildInfoRow(
                                              'الفرع',
                                              bill.branch ?? 'غير محدد',
                                              Icons.business,
                                            ),
                                          ),
                                          Container(
                                            height: 24,
                                            width: 1,
                                            color: Colors.white24,
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          Expanded(
                                            child: _buildInfoRow(
                                              'الفترة',
                                              'السنة: ${bill.billYear} - الشهر: ${bill.billMonth}',
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Edit Form Section
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit_note,
                                          size: 24,
                                          color: Colors.blue.shade700,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'تعديل البيانات',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller: controller.chlorineController,
                                            label: 'استهلاك الكلور',
                                            icon: Icons.water,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller:
                                                controller.liquidAlumController,
                                            label: 'استهلاك الشبة السائلة',
                                            icon: Icons.opacity,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller:
                                                controller.solidAlumController,
                                            label: 'استهلاك الشبة الصلبة',
                                            icon: Icons.ac_unit,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller:
                                                controller.waterProducedController,
                                            label: 'كمية المياه المنتجة',
                                            icon: Icons.water_drop,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller:
                                                controller.calculatedWaterController,
                                            label: 'كمية المياه المحسوبة',
                                            icon: Icons.water_drop,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller:
                                                controller.measuredWaterController,
                                            label: 'كمية المياه المقاسة',
                                            icon: Icons.water_drop,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // Action Buttons
                                    Obx(() {
                                      if (controller.looading.value) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                {
                                                  controller.editTechBills(
                                                    measuredWater:
                                                        double.tryParse(
                                                          controller
                                                              .measuredWaterController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    calculatedWater:
                                                        double.tryParse(
                                                          controller
                                                              .calculatedWaterController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    id: bill.techBillId,
                                                    chlorine:
                                                        double.tryParse(
                                                          controller
                                                              .chlorineController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    liquid:
                                                        double.tryParse(
                                                          controller
                                                              .liquidAlumController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    solid:
                                                        double.tryParse(
                                                          controller
                                                              .solidAlumController
                                                              .text,
                                                        ) ??
                                                        0,
                                                    water:
                                                        double.tryParse(
                                                          controller
                                                              .waterProducedController
                                                              .text,
                                                        ) ??
                                                        0,
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.save,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                'حفظ التعديلات',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green.shade600,
                                                foregroundColor: Colors.white,
                                                elevation: 2,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () => Get.back(),
                                              icon: const Icon(
                                                Icons.cancel,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                'إلغاء',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    Colors.grey.shade700,
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 2,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
