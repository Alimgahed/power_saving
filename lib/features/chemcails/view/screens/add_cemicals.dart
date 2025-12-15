import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/chemcails/controller/add_chemacial.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddChemicalScreen extends StatelessWidget {
  AddChemicalScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(addchemical());

    return RTLScaffold(
      appBar: const CustomAppBar(
        title: "إضافة مرجع كيميائي",
        backRoute: '/Chemicals',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: FormCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===============================
                /// Chemicals Ranges
                /// ===============================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chemicalRange(
                      title: 'الكلور',
                      icon: Icons.water_drop,
                      color: Colors.cyan,
                      from: controller.chlorineFromController,
                      to: controller.chlorineToController,
                    ),
                    const SizedBox(width: 24),
                    _chemicalRange(
                      title: 'الشبة الصلبة',
                      icon: Icons.grain,
                      color: Colors.brown,
                      from: controller.solidAlumFromController,
                      to: controller.solidAlumToController,
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingM),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chemicalRange(
                      title: 'الشبة السائلة',
                      icon: Icons.opacity,
                      color: Colors.orange,
                      from: controller.liquidAlumFromController,
                      to: controller.liquidAlumToController,
                    ),
                    const SizedBox(width: 24),

                    /// ===============================
                    /// Basic Info
                    /// ===============================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'المعلومات الأساسية',
                            icon: Icons.settings,
                            color: AppColors.primary,
                          ),

                          CustomDropdownFormField<int>(
                            items: controller.waterSourceList.map((source) {
                              return DropdownMenuItem<int>(
                                value: source.waterSourceId,
                                child: Text(source.waterSourceName!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.waterSourceId = value;
                            },
                            labelText: 'مصدر المياه',
                            hintText: 'اختر مصدر المياه',
                            prefixIcon: Icons.water_drop,
                            validator: (val) =>
                                val == null ? 'الرجاء اختيار مصدر المياه' : null,
                          ),

                          SizedBox(height: AppDimensions.paddingM),

                          CustomDropdownFormField<String>(
                            items: const [
                              DropdownMenuItem(
                                value: "winter",
                                child: Text("شتاء"),
                              ),
                              DropdownMenuItem(
                                value: "summer",
                                child: Text("صيف"),
                              ),
                            ],
                            onChanged: (val) {
                              controller.season = val!;
                            },
                            labelText: 'الموسم',
                            hintText: 'اختر الموسم',
                            prefixIcon: Icons.calendar_month,
                            validator: (val) =>
                                val == null ? 'هذا الحقل مطلوب' : null,
                          ),
                         SizedBox(height: AppDimensions.paddingM),
                          CustomDropdownFormField<int>(
                            items: controller.tech.map((tech) {
                              return DropdownMenuItem<int>(
                                value: tech.technologyId,
                                child: Text(tech.technologyName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.technologyId = value;
                            },
                            labelText: 'تقنية المعالجة',
                            hintText: 'اختر تقنية المعالجة',
                            prefixIcon: Icons.precision_manufacturing,
                            validator: (val) =>
                                val == null ? 'الرجاء اختيار تقنية' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingL),

                /// ===============================
                /// Save Button
                /// ===============================
                Obx(() {
                  return PrimaryButton(
                    label: 'حفظ المرجع',
                    icon: Icons.save,
                    isLoading: controller.loading.value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!_validateRanges(controller)) return;

                        await controller.addchemicals(
                          reference: AlumChlorineReference(
                            chlorineRangeFrom: double.parse(
                              controller.chlorineFromController.text,
                            ),
                            chlorineRangeTo: double.parse(
                              controller.chlorineToController.text,
                            ),
                            liquidAlumRangeFrom: double.parse(
                              controller.liquidAlumFromController.text,
                            ),
                            liquidAlumRangeTo: double.parse(
                              controller.liquidAlumToController.text,
                            ),
                            solidAlumRangeFrom: double.parse(
                              controller.solidAlumFromController.text,
                            ),
                            solidAlumRangeTo: double.parse(
                              controller.solidAlumToController.text,
                            ),
                            season: controller.season!,
                            technologyId: controller.technologyId!,
                            waterSourceId: controller.waterSourceId!,
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
      ),
    );
  }

  /// ===============================
  /// Chemical Range Widget
  /// ===============================
  Widget _chemicalRange({
    required String title,
    required IconData icon,
    required Color color,
    required TextEditingController from,
    required TextEditingController to,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon, color: color),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: 'من',
                  hintText: 'القيمة الدنيا',
                  icon: icon,
                  controller: from,
                  keyboardType: TextInputType.number,
                  allowOnlyDigits: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextFormField(
                  label: 'إلى',
                  hintText: 'القيمة العليا',
                  icon: icon,
                  controller: to,
                  keyboardType: TextInputType.number,
                  allowOnlyDigits: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// Validation
  /// ===============================
  bool _validateRanges(addchemical controller) {
    if (double.parse(controller.chlorineFromController.text) >
        double.parse(controller.chlorineToController.text)) {
      showCustomErrorDialog(
        errorMessage: 'الكلور (من) يجب أن يكون أقل من (إلى)',
      );
      return false;
    }

    if (double.parse(controller.liquidAlumFromController.text) >
        double.parse(controller.liquidAlumToController.text)) {
      showCustomErrorDialog(
        errorMessage: 'الشبة السائلة (من) يجب أن تكون أقل من (إلى)',
      );
      return false;
    }

    if (double.parse(controller.solidAlumFromController.text) >
        double.parse(controller.solidAlumToController.text)) {
      showCustomErrorDialog(
        errorMessage: 'الشبة الصلبة (من) يجب أن تكون أقل من (إلى)',
      );
      return false;
    }

    return true;
  }
}
