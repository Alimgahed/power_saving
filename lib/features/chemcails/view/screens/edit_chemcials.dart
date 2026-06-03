import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/controller/add_chemacial.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

// ignore: must_be_immutable
class EditChemcials extends StatelessWidget {
  EditChemcials({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final addchemical controller = Get.put(addchemical());
  final AlumChlorineReference? chemicals =
      Get.arguments != null ? Get.arguments["chemical"] : null;
  int? id;

  // Flag to initialize only once
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (chemicals == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Chemicals');
      });
      return const SizedBox();
    }

    // Initialize controller values once
    if (!_initialized) {
      controller.chlorineFromController.text =
          chemicals!.chlorineRangeFrom.toString();
      controller.chlorineToController.text =
          chemicals!.chlorineRangeTo.toString();
      controller.liquidAlumFromController.text =
          chemicals!.liquidAlumRangeFrom.toString();
      controller.liquidAlumToController.text =
          chemicals!.liquidAlumRangeTo.toString();
      controller.solidAlumFromController.text =
          chemicals!.solidAlumRangeFrom.toString();
      controller.solidAlumToController.text =
          chemicals!.solidAlumRangeTo.toString();

      controller.season = chemicals!.season;
      id = chemicals!.chemicalId;
      controller.waterSourceId = chemicals!.waterSourceId;
      controller.technologyId = chemicals!.technologyId;

      _initialized = true;
    }

    const appBarWidget = CustomAppBar(
      title: "تعديل المرجع الكيميائي",
      backRoute: '/Chemicals',
    );

    return AppScaffold(
      title: "تعديل المرجع الكيميائي",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GetBuilder<addchemical>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 32,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'تعديل بيانات المرجع الكيميائي',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'قم بتحديث القيم والنطاقات حسب الحاجة',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row: Chlorine and Solid Alum
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Chlorine Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'الكلور',
                                      Icons.water_drop,
                                      Colors.cyan,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'من',
                                            hintText: 'القيمة الدنيا',
                                            icon: Icons.water_drop,
                                            controller:
                                                controller.chlorineFromController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'إلى',
                                            hintText: 'القيمة العليا',
                                            icon: Icons.water_drop_outlined,
                                            controller:
                                                controller.chlorineToController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Solid Alum Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'الشبة الصلبة',
                                      Icons.grain,
                                      Colors.brown,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'من',
                                            hintText: 'القيمة الدنيا',
                                            icon: Icons.ac_unit,
                                            controller:
                                                controller.solidAlumFromController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'إلى',
                                            hintText: 'القيمة العليا',
                                            icon: Icons.ac_unit_outlined,
                                            controller:
                                                controller.solidAlumToController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Second Row: Liquid Alum and Additional Settings
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Liquid Alum Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'الشبة السائلة',
                                      Icons.opacity,
                                      Colors.orange,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'من',
                                            hintText: 'القيمة الدنيا',
                                            icon: Icons.liquor,
                                            controller:
                                                controller.liquidAlumFromController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'إلى',
                                            hintText: 'القيمة العليا',
                                            icon: Icons.liquor_outlined,
                                            controller:
                                                controller.liquidAlumToController,
                                            keyboardType: TextInputType.number,
                                            allowOnlyDigits: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Additional Settings Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      'المعلومات الاساسية',
                                      Icons.settings,
                                      Colors.purple,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomDropdownFormField<int>(
                                      initialValue: controller.waterSourceId,
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
                                    const SizedBox(height: 16),
                                    CustomDropdownFormField<String>(
                                      initialValue: controller.season,
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
                                          val == null ? 'هذا الحقل لا يجب ان يكون فارغ' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomDropdownFormField<int>(
                                      initialValue: controller.technologyId,
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (double.parse(
                                      controller.chlorineFromController.text,
                                    ) >
                                    double.parse(
                                      controller.chlorineToController.text,
                                    )) {
                                  showCustomErrorDialog(
                                    errorMessage:
                                        'الكلور من يجب أن يكون أقل من الكلور إلى',
                                  );
                                  return;
                                } else if (double.parse(
                                      controller.liquidAlumFromController.text,
                                    ) >
                                    double.parse(
                                      controller.liquidAlumToController.text,
                                    )) {
                                  showCustomErrorDialog(
                                    errorMessage:
                                        'الشبة السائلة من يجب أن تكون أقل من الشبة السائلة إلى',
                                  );
                                } else if (double.parse(
                                      controller.solidAlumFromController.text,
                                    ) >
                                    double.parse(
                                      controller.solidAlumToController.text,
                                    )) {
                                  showCustomErrorDialog(
                                    errorMessage:
                                        'الشبة الصلبة من يجب أن تكون أقل من الشبة الصلبة إلى',
                                  );
                                } else {
                                  await controller.editchemicals(
                                    reference: AlumChlorineReference(
                                      chemicalId: id,
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
                                    id: id!,
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.save, size: 20),
                            label: const Text(
                              'حفظ التعديلات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: color.withOpacity(0.2))),
        ],
      ),
    );
  }
}
