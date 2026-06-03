import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/technology/controller/edit_tech_controller.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditTechScreen extends StatelessWidget {
  EditTechScreen({super.key});

  final TechnologyModel? tech =
      Get.arguments != null ? Get.arguments["Tech"] : null;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (tech == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Technology');
      });
    }

    const appBarWidget = CustomAppBar(
      title: "تعديل بيانات التقنية",
      backRoute: '/Technology',
    );

    return AppScaffold(
      title: "تعديل بيانات التقنية",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<EditTechController>(
          init: EditTechController(),
          builder: (controller) {
            /// Init values once
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.name.text.isEmpty && tech != null) {
                controller.name.text = tech!.technologyName;
                controller.power.text =
                    tech!.powerPerWater.toString();
                controller.main_type = tech!.main_type;
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===============================
                /// Current Tech Info
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
                          Icons.memory,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التقنية الحالية: ${tech!.technologyName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'معرف التقنية: ${tech!.technologyId}',
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
                          title: 'معلومات التقنية',
                          icon: Icons.memory,
                          color: AppColors.primary,
                        ),

                        CustomTextFormField(
                          controller: controller.name,
                          label: 'اسم التقنية',
                          hintText: 'ادخل اسم التقنية',
                          icon: Icons.memory,
                        ),

                        CustomTextFormField(
                          controller: controller.power,
                          label: 'نسبة الكهرباء',
                          hintText: 'ادخل نسبة الكهرباء',
                          icon: Icons.electric_bolt_outlined,
                          allowOnlyDigits: true,
                          keyboardType: TextInputType.number,
                        ),

                        CustomDropdownFormField<String>(
                          items: const [
                            DropdownMenuItem(value: "ثابت", child: Text("ثابت")),
                            DropdownMenuItem(value: "نقالي", child: Text("نقالي")),
                            DropdownMenuItem(value: "ارتوازي", child: Text("ارتوازي")),
                            DropdownMenuItem(value: "رفع", child: Text("رفع")),
                            DropdownMenuItem(value: "معالجة", child: Text("معالجة")),
                          ],
                          initialValue: tech!.main_type,
                          onChanged: (val) {
                            controller.main_type = val!;
                          },
                          labelText: 'التصنيف الرئيسي',
                          hintText: 'اختر التصنيف الرئيسي',
                          prefixIcon: Icons.category,
                          validator: (val) =>
                              val == null ? 'الرجاء اختيار نوع التقنية' : null,
                        ),

                        const SizedBox(height: AppDimensions.paddingL),

                        /// ===============================
                        /// Save Button
                        /// ===============================
                        Obx(() {
                          return PrimaryButton(
                            label: 'حفظ التعديلات',
                            icon: Icons.save,
                            isLoading: controller.looading.value,
                            onPressed: () async {
                              if (_globalKey.currentState!.validate()) {
                                await controller.edittech(
                                  id: tech!.technologyId!,
                                  tech: TechnologyModel(
                                    technologyId: tech!.technologyId,
                                    technologyName: controller.name.text,
                                    powerPerWater: double.parse(
                                      controller.power.text,
                                    ),
                                    main_type: controller.main_type!,
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
