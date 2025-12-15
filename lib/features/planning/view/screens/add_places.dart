import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/features/planning/controller/add_places_controller.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddPlacesScreen extends StatelessWidget {
  AddPlacesScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "إضافة مكان جديد",
        backRoute: '/Places',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<AddPlacesController>(
          init: AddPlacesController(),
          builder: (controller) {
            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place Information Section
                    const SectionHeader(
                      title: 'معلومات المكان',
                      icon: Icons.location_city,
                      color: AppColors.primary,
                    ),
                    CustomTextFormField(
                      label: 'اسم المكان',
                      hintText: 'أدخل اسم المكان',
                      icon: Icons.location_city,
                      controller: controller.name,
                    ),

                    // Location Information Section
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
                            onChanged: (value) {
                              controller.areaId = value;
                            },
                            labelText: 'منطقة الخدمة',
                            hintText: 'اختر منطقة الخدمة',
                            prefixIcon: Icons.water_drop,
                            validator: (val) =>
                                val == null ? 'الرجاء اختيار منطقة الخدمة' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Place Type Section
                    const SectionHeader(
                      title: 'نوع المكان',
                      icon: Icons.category,
                      color: AppColors.primary,
                    ),
                    CustomDropdownFormField<int>(
                      items: controller.placeTypeList.map((placeType) {
                        return DropdownMenuItem<int>(
                          value: placeType.placeTypeId,
                          child: Text(placeType.placeTypeName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.placeTypeId = value;
                      },
                      labelText: 'نوع المكان',
                      hintText: 'اختر نوع المكان',
                      prefixIcon: Icons.location_on,
                      validator: (val) =>
                          val == null ? 'الرجاء اختيار نوع المكان' : null,
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Submit Button
                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ المكان',
                        icon: Icons.save,
                        isLoading: controller.looading.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.addplace(
                              place: Place(
                                placeName: controller.name.text,
                                placeTypeId: controller.placeTypeId!,
                                branchId: controller.branchId!,
                                areaId: controller.areaId!,
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
