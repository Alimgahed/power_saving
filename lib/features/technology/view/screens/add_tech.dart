import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/technology/controller/add_tech_controller.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddTechScreen extends StatelessWidget {
  AddTechScreen({super.key});

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const appBarWidget = CustomAppBar(
      title: "إضافة تقنية جديدة",
      backRoute: '/Technology',
    );

    return AppScaffold(
      title: "إضافة تقنية جديدة",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<AddTechController>(
          init: AddTechController(),
          builder: (controller) {
            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===============================
                    /// Technology Info
                    /// ===============================
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
                        DropdownMenuItem(value: "روافع", child: Text("روافع")),
                      ],
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

                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ التقنية',
                        icon: Icons.save,
                        isLoading: controller.looading.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.addtech(
                              tech: TechnologyModel(
                                main_type: controller.main_type,
                                powerPerWater:
                                    double.parse(controller.power.text),
                                technologyName: controller.name.text,
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
