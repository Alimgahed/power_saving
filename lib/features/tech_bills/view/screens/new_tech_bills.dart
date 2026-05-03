import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/features/tech_bills/controller/new_tech_bills.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class NewTechBillsScreen extends StatelessWidget {
  const NewTechBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RTLScaffold(
      backgroundColor: AppColors.background,
      body: GetBuilder<NewTechBillsController>(
        init: NewTechBillsController(),
        builder: (controller) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔽 Stations Dropdown
                      DropdownButtonFormField<Station>(
                        hint: const Text("اختر المحطة"),
                        value: controller.selectedStation,
                        items: controller.stations
                            .map(
                              (station) => DropdownMenuItem(
                                value: station,
                                child: Text(station.stationName),
                              ),
                            )
                            .toList(),
                        onChanged: controller.onStationChanged,
                      ),

                      const SizedBox(height: 16),

                      /// 🔽 Tech Dropdown
                      if (controller.selectedStation != null &&
                          controller.selectedStation!.techs.isNotEmpty)
                        DropdownButtonFormField<TechnologyModel>(
                          hint: const Text("اختر نوع التكنولوجيا"),
                          value: controller.selectedTech,
                          items: controller.selectedStation!.techs
                              .map(
                                (tech) => DropdownMenuItem(
                                  value: tech,
                                  child: Text(tech.technologyName),
                                ),
                              )
                              .toList(),
                          onChanged: controller.onTechChanged,
                        ),

                      const SizedBox(height: 16),

                      /// 📅 Month & Year
                      CustomTextFormField(
                        label: 'الشهر',
                        hintText: 'ادخل الشهر',
                        controller: controller.monthController,
                        allowOnlyDigits: true,
                      ),
                      CustomTextFormField(
                        label: 'السنة',
                        hintText: 'ادخل السنة',
                        controller: controller.yearController,
                        allowOnlyDigits: true,
                      ),

                      const SizedBox(height: 16),

                      /// 💧 Values
                      CustomTextFormField(
                        label: 'كمية المياه المستهلكة',
                        hintText: 'ادخل كمية المياه المستهلكة',
                        controller: controller.waterProducedController,
                        allowOnlyDigits: true,
                      ),
                      CustomTextFormField(
                        label: 'كمية الكلور المستخدمة',
                        hintText: 'ادخل كمية الكلور المستخدمة',
                        controller: controller.chlorineController,
                        allowOnlyDigits: true,
                      ),
                      CustomTextFormField(
                        label: 'كمية الشبة السائلة',
                        hintText: 'ادخل كمية الشبة السائلة',
                        controller: controller.liquidAlumController,
                        allowOnlyDigits: true,
                      ),
                      CustomTextFormField(
                        label: 'كمية الشبة الصلبة',
                        hintText: 'ادخل كمية الشبة الصلبة',
                        controller: controller.solidAlumController,
                        allowOnlyDigits: true,
                      ),

                      const SizedBox(height: 24),

                      /// ✅ Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            /// 🔒 Basic validation
                            if (controller.selectedStation == null ||
                                controller.selectedTech == null) {
                              showCustomErrorDialog(
                                  errorMessage: "من فضلك اختر المحطة والتكنولوجيا");
                              return;
                            }

                            if (controller.monthController.text.isEmpty ||
                                controller.yearController.text.isEmpty) {
                              showCustomErrorDialog(
                                  errorMessage: "من فضلك ادخل الشهر والسنة");
                              return;
                            }

                            controller.addTechBills(
                              staionid: controller.selectedStation!.stationId,
                              techid: controller.selectedTech!.technologyId!,
                              chlorine: double.tryParse(
                                      controller.chlorineController.text) ??
                                  0,
                              liquid: double.tryParse(
                                      controller.liquidAlumController.text) ??
                                  0,
                              solid: double.tryParse(
                                      controller.solidAlumController.text) ??
                                  0,
                              water: double.tryParse(
                                      controller.waterProducedController.text) ??
                                  0,
                              index: 0,
                            );
                          },
                          child: const Text("حفظ البيانات"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔄 Loading Overlay
              Obx(() {
                if (controller.loading.value) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          );
        },
      ),
    );
  }
}