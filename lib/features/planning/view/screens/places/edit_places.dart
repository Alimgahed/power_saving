import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/planning/controller/place/edit_places_controller.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditPlacesScreen extends StatelessWidget {
  EditPlacesScreen({super.key});

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final Place? place =
      Get.arguments != null ? Get.arguments["place"] : null;

  @override
  Widget build(BuildContext context) {
    if (place == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Places');
      });
    }

    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "تعديل مكان",
        backRoute: '/Places',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<EditPlacesController>(
          init: EditPlacesController(),
          builder: (controller) {
            /// Init values once
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.name.text.isEmpty && place != null) {
                controller.name.text = place!.placeName;
                controller.placeTypeId = place!.placeTypeId;
                controller.branchId = place!.branchId;
                controller.areaId = place!.areaId;
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===============================
                /// Current Place Info
                /// ===============================
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
                              'المكان الحالي: ${place!.placeName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'معرف المكان: ${place!.placeId}',
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
                          title: 'معلومات المكان',
                          icon: Icons.place,
                          color: AppColors.primary,
                        ),

                        CustomTextFormField(
                          label: 'اسم المكان',
                          hintText: 'أدخل اسم المكان',
                          icon: Icons.location_city,
                          controller: controller.name,
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
                                initialValue: place!.branchId,
                                onChanged: (value) {
                                  controller.branchId = value;
                                },
                                labelText: 'الفرع',
                                hintText: 'اختر الفرع',
                                prefixIcon: Icons.map,
                                validator: (val) =>
                                    val == null ? 'الرجاء اختيار الفرع' : null,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingL),
                            Expanded(
                              child: CustomDropdownFormField<int>(
                                items: controller.areaList.map((area) {
                                  return DropdownMenuItem<int>(
                                    value: area.areaId,
                                    child: Text(area.areaName),
                                  );
                                }).toList(),
                                initialValue: place!.areaId,
                                onChanged: (value) {
                                  controller.areaId = value;
                                },
                                labelText: 'المنطقة',
                                hintText: 'اختر المنطقة',
                                prefixIcon: Icons.water_drop,
                                validator: (val) =>
                                    val == null ? 'الرجاء اختيار المنطقة' : null,
                              ),
                            ),
                          ],
                        ),

SizedBox(height: AppDimensions.paddingL,),
                        CustomDropdownFormField<int>(
                          items: controller.placeTypeList.map((placeType) {
                            return DropdownMenuItem<int>(
                              value: placeType.placeTypeId,
                              child: Text(placeType.placeTypeName),
                            );
                          }).toList(),
                          initialValue: place!.placeTypeId,
                          onChanged: (value) {
                            controller.placeTypeId = value;
                          },
                          labelText: 'نوع المكان',
                          hintText: 'اختر نوع المكان',
                          prefixIcon: Icons.category,
                          validator: (val) =>
                              val == null ? 'الرجاء اختيار نوع المكان' : null,
                        ),

                        const SizedBox(height: AppDimensions.paddingL),

                        /// ===============================
                        /// Update Button
                        /// ===============================
                        Obx(() {
                          return PrimaryButton(
                            label: 'تحديث المكان',
                            icon: Icons.edit,
                            isLoading: controller.looading.value,
                            onPressed: () async {
                              if (_globalKey.currentState!.validate()) {
                                await controller.editplace(
                                  place: Place(
                                    placeId: place!.placeId,
                                    placeName: controller.name.text,
                                    branchId: controller.branchId!,
                                    areaId: controller.areaId!,
                                    placeTypeId: controller.placeTypeId!,
                                  ),
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
