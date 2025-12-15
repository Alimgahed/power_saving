import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/Counter/controller/edit_counter_controller.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditCounterScreen extends StatelessWidget {
  EditCounterScreen({super.key});

  final ElectricMeter? meter =
      Get.arguments != null ? Get.arguments["meter"] : null;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (meter == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Countrts');
      });
    }

    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "تعديل عداد",
        backRoute: '/Countrts',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<EditCounter>(
          init: EditCounter(),
          builder: (controller) {
            /// Init once
            if (controller.Counter_number.text.isEmpty) {
              controller.Counter_number.text = meter!.accountNumber!;
              controller.finalReading.text =
                  meter!.finalReading.toString();
              controller.meterFactor.text =
                  meter!.meterFactor.toString();
              controller.meterId.text = meter!.meterId;
              controller.voltage = meter!.voltageid;
            }

            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===============================
                    /// Counter Details
                    /// ===============================
                    const SectionHeader(
                      title: 'تفاصيل العداد',
                      icon: Icons.electric_meter,
                      color: AppColors.primary,
                    ),

                    CustomTextFormField(
                      label: 'رقم الاشتراك',
                      icon: Icons.numbers,
                      controller: controller.Counter_number,
                      readonly: true,
                    ),

                    CustomTextFormField(
                      label: 'الرقم التسلسلي للعداد',
                      icon: Icons.confirmation_number,
                      allowOnlyDigits: true,
                      controller: controller.meterId,
                    ),

                    CustomDropdownFormField<int>(
                      initialValue: controller.voltage,
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
                      icon: Icons.speed,
                      controller: controller.finalReading,
                      readonly: true,
                      allowOnlyDigits: true,
                      keyboardType: TextInputType.number,
                    ),

                    CustomTextFormField(
                      label: 'معامل العداد',
                      icon: Icons.straighten,
                      controller: controller.meterFactor,
                      allowOnlyDigits: true,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: AppDimensions.paddingL),

                    /// ===============================
                    /// Save Button
                    /// ===============================
                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ التعديلات',
                        icon: Icons.save,
                        isLoading: controller.looadig.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.editCounter(
                              serial: controller.Counter_number.text,
                              counter: ElectricMeter(
                                accountNumber:
                                    controller.Counter_number.text,
                                meterId: controller.meterId.text,
                                voltageid: controller.voltage!,
                                finalReading: double.tryParse(
                                      controller.finalReading.text,
                                    ) ??
                                    0,
                                meterFactor: int.tryParse(
                                      controller.meterFactor.text,
                                    ) ??
                                    1,
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
