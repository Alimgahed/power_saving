import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/technology/technlogy.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddTech extends StatelessWidget {
  AddTech({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,

        actions: [
          Row(
            children: [
              const Text(
                "إضافة تقنية جديدة",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Get.offNamed('/Technology');
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<TechnlogyController>(
            init: TechnlogyController(),
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
                      const Icon(Icons.memory, size: 64, color: Colors.blue),
                      const SizedBox(height: 16),
                      const Text(
                        'إدخال بيانات التقنية',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomTextFormField(
                        controller: controller.name,
                        label: 'اسم التقنية',
                        hintText: 'ادخل اسم التقنية',
                        icon: Icons.memory,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: controller.power,
                        allowOnlyDigits: true,
                        label: 'نسبة الكهرباء',
                        hintText: 'ادخل نسبة الكهرباء',
                        icon: Icons.electric_bolt_outlined,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              controller.addtech(
                                tech: TechnologyModel(
                                  powerPerWater: double.parse(
                                    controller.power.text,
                                  ),
                                  technologyName: controller.name.text,
                                ),
                              );
                            }
                            // controller.addtech(tech: TechnologyModel(  powerPerWater: double.parse(controller.power.text), technologyName: controller.name.text));
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ التقنية'),
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
