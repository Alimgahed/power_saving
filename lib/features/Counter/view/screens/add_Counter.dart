import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/Counter/controller/add_counter_controller.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddElectricMeterScreen extends StatelessWidget {
  AddElectricMeterScreen({super.key});

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const appBarWidget = CustomAppBar(
      title: "إضافة عداد جديد",
      backRoute: '/Countrts',
    );

    return AppScaffold(
      title: "إضافة عداد جديد",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<addcounter>(
          init: addcounter(),
          builder: (controller) {
            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===============================
                    /// Meter Details
                    /// ===============================
                    const SectionHeader(
                      title: 'تفاصيل العداد',
                      icon: Icons.electric_meter,
                      color: AppColors.primary,
                    ),

                    CustomTextFormField(
                      label: 'رقم الاشتراك',
                      hintText: 'أدخل رقم الاشتراك',
                      icon: Icons.numbers,
                      controller: controller.Counter_number,
                    ),

                    CustomTextFormField(
                      label: 'الرقم التسلسلي للعداد',
                      hintText: 'أدخل الرقم التسلسلي للعداد',
                      icon: Icons.confirmation_number,
                      allowOnlyDigits: true,
                      controller: controller.meterId,
                    ),

                    CustomDropdownFormField<int>(
                      items: controller.allVoltage.map((type) {
                        return DropdownMenuItem<int>(
                          value: type.voltageId,
                          child: Text(type.voltageType),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.voltage = value;
                      },
                      labelText: 'جهد العداد',
                      hintText: 'اختر نوع الجهد',
                      prefixIcon: Icons.flash_on,
                      validator: (val) =>
                          val == null ? 'الرجاء اختيار الجهد' : null,
                    ),

                    CustomTextFormField(
                      label: 'القراءة النهائية',
                      hintText: 'أدخل القراءة النهائية',
                      icon: Icons.speed,
                      allowOnlyDigits: true,
                      controller: controller.finalReading,
                      keyboardType: TextInputType.number,
                    ),

                    CustomTextFormField(
                      label: 'معامل العداد',
                      hintText: 'أدخل معامل العداد',
                      icon: Icons.straighten,
                      allowOnlyDigits: true,
                      controller: controller.meterFactor,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: AppDimensions.paddingL),

                    /// ===============================
                    /// Save Button
                    /// ===============================
                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ العداد',
                        icon: Icons.save,
                        isLoading: controller.looading.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.addCounter(
                              counter: ElectricMeter(
                                accountNumber:
                                    controller.Counter_number.text,
                                meterId: controller.meterId.text,
                                voltageid: controller.voltage!,
                                finalReading: double.tryParse(
                                  controller.finalReading.text,
                                ),
                                meterFactor: int.tryParse(
                                  controller.meterFactor.text,
                                ),
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
