// lib/features/stations/view/add_station_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/features/stations/controller/add_stations_controller.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddStationScreen extends StatelessWidget {
  AddStationScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "إضافة محطة جديدة",
        backRoute: '/Stations',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<AddStationController>(
          init: AddStationController(),
          builder: (controller) {
            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Station Information Section
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
                              DropdownMenuItem(value: "مياة", child: Text("مياة")),
                              DropdownMenuItem(value: "صرف", child: Text("صرف")),
                            ],
                            onChanged: (val) {
                              controller.stationTypeId = val!;
                            },
                            labelText: 'نوع المحطة',
                            hintText: 'اختر نوع المحطة',
                            prefixIcon: Icons.category,
                            validator: (val) =>
                                val == null ? 'الرجاء اختيار نوع المحطة' : null,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingL),
                        Expanded(
                          child: CustomTextFormField(
                            label: 'الطاقة التصميمية',
                            hintText: 'ادخل الطاقة المحطه',
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
                            items: controller.waterSourceList.map((source) {
                              return DropdownMenuItem<int>(
                                value: source.waterSourceId,
                                child: Text(source.waterSourceName!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.sourceId = value;
                            },
                            labelText: 'مصدر المياه',
                            hintText: 'اختر مصدر المياه',
                            prefixIcon: Icons.water_drop,
                            validator: (val) =>
                                val == null ? 'الرجاء اختيار مصدر المياه' : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.paddingL),

                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ المحطة',
                        icon: Icons.save,
                        isLoading: controller.looading.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.addStation(
                              name: controller.name.text,
                              branchId: controller.branchId!,
                              sourceId: controller.sourceId!,
                              typeId: controller.stationTypeId!,
                              capacity: int.parse(controller.capacity.text),
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
