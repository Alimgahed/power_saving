import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/stations/controller/edit_stations_controller.dart';
import 'package:power_saving/features/stations/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditStationsScreen extends StatelessWidget {
  EditStationsScreen({super.key});

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final Station? station =
      Get.arguments != null ? Get.arguments["Stations"] : null;

  @override
  Widget build(BuildContext context) {
    if (station == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Stations');
      });
    }

    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "تعديل محطة",
        backRoute: '/Stations',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<EditStationsController>(
          init: EditStationsController(),
          builder: (controller) {
            /// Initialize once
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.name.text.isEmpty && station != null) {
                controller.name.text = station!.stationName;
                controller.capacity.text =
                    station!.stationWaterCapacity.toString();
                controller.stationTypeId = station!.stationType;
                controller.branchId = station!.branchid;
                controller.sourceId = station!.sourceid;
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المحطة الحالية: ${station!.stationName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'معرف المحطة: ${station!.stationId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingL),

                /// ===============================
                /// Edit Form
                /// ===============================
                FormCard(
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'معلومات المحطة',
                          icon: Icons.location_city,
                          color: AppColors.primary,
                        ),

                        CustomTextFormField(
                          label: 'اسم المحطة',
                          hintText: 'أدخل اسم المحطة',
                          icon: Icons.location_city,
                          controller: controller.name,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdownFormField<String>(
                                items: const [
                                  DropdownMenuItem(
                                      value: "مياة", child: Text("مياة")),
                                  DropdownMenuItem(
                                      value: "صرف", child: Text("صرف")),
                                ],
                                initialValue: station!.stationType,
                                onChanged: (val) {
                                  controller.stationTypeId = val!;
                                },
                                labelText: 'نوع المحطة',
                                hintText: 'اختر نوع المحطة',
                                prefixIcon: Icons.category,
                                validator: (val) => val == null
                                    ? 'الرجاء اختيار نوع المحطة'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingL),
                            Expanded(
                              child: CustomTextFormField(
                                label: 'الطاقة التصميمية',
                                hintText: 'ادخل الطاقة التصميمية',
                                icon: Icons.water,
                                allowOnlyDigits: true,
                                controller: controller.capacity,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdownFormField<int>(
                                items: controller.branchList.map((branch) {
                                  return DropdownMenuItem<int>(
                                    value: branch.branchId,
                                    child: Text(branch.branchName),
                                  );
                                }).toList(),
                                initialValue: station!.branchid,
                                onChanged: (value) {
                                  controller.branchId = value;
                                },
                                labelText: 'الفرع',
                                hintText: 'اختر الفرع',
                                prefixIcon: Icons.map,
                                validator: (val) => val == null
                                    ? 'الرجاء اختيار الفرع'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingL),
                            Expanded(
                              child: CustomDropdownFormField<int>(
                                items: controller.waterSourceList.map((source) {
                                  return DropdownMenuItem<int>(
                                    value: source.waterSourceId,
                                    child: Text(source.waterSourceName!),
                                  );
                                }).toList(),
                                initialValue: station!.sourceid,
                                onChanged: (value) {
                                  controller.sourceId = value;
                                },
                                labelText: 'مصدر المياه',
                                hintText: 'اختر مصدر المياه',
                                prefixIcon: Icons.water_drop,
                                validator: (val) => val == null
                                    ? 'الرجاء اختيار مصدر المياه'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.paddingL),

                        /// ===============================
                        /// Update Button
                        /// ===============================
                        Obx(() {
                          return PrimaryButton(
                            label: 'تحديث المحطة',
                            icon: Icons.edit,
                            isLoading: controller.looading.value,
                            onPressed: () async {
                              if (_globalKey.currentState!.validate()) {
                                await controller.edit_Stations(
                                  Stations_id: station!.stationId!,
                                  name: controller.name.text,
                                  typeId: controller.stationTypeId!,
                                  capacity:
                                      int.parse(controller.capacity.text),
                                  branchId: controller.branchId ??
                                      station!.branchid!,
                                  sourceId: controller.sourceId ??
                                      station!.sourceid!,
                                );
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
