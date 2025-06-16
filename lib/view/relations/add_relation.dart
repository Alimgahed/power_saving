import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/relations/relation.dart';
import 'package:power_saving/model/relations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddRelation extends StatelessWidget {
  AddRelation({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offNamed('/Relations');
          },
        ),
        title: const Text("إضافة ربط جديد", style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<addrelationcontroller>(
            init: addrelationcontroller(),
            builder: (controller) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_location_alt,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'إدخال بيانات الربط',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomDropdownFormField<int>(
                        items:
                            controller.stationlist.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch.branchId,
                                child: Text(branch.branchName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          controller.stationid = value;
                        },
                        labelText: 'المحطة',
                        hintText: 'اختر المحطة',
                        prefixIcon: Icons.map,
                        validator:
                            (val) =>
                                val == null ? 'الرجاء اختيار المحطة' : null,
                      ),
                      const SizedBox(height: 32),

                      CustomDropdownFormField<String>(
                        items:
                            controller.electricMeterList.map((source) {
                              return DropdownMenuItem<String>(
                                value: source.accountNumber,
                                child: Text(source.accountNumber ?? ""),
                              );
                            }).toList(),
                        onChanged: (value) {
                          controller.counterid = value;
                        },
                        labelText: 'العداد',
                        hintText: 'اختر  العداد',
                        prefixIcon: Icons.water_drop,
                        validator:
                            (val) =>
                                val == null ? 'الرجاء اختيار  العداد' : null,
                      ),

                      const SizedBox(height: 32),

                      CustomDropdownFormField<int>(
                        items:
                            controller.technologylist.map((source) {
                              return DropdownMenuItem<int>(
                                value: source.technologyId,
                                child: Text(source.technologyName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          controller.techid = value;
                        },
                        labelText: 'التكونولوجيا',
                        hintText: 'اختر التكونولوجيا',
                        prefixIcon: Icons.water_drop,
                        validator:
                            (val) =>
                                val == null
                                    ? 'الرجاء اختيار  التكونولوجيا'
                                    : null,
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              await controller.addRelations(
                                StationGaugeTechnologyRelation(
                                  accountNumber: controller.counterid!,
                                  relationStatus: true,
                                  stationId: controller.stationid!,
                                  technologyId: controller.techid!,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ '),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
