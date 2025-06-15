import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/technology/technlogy.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';
class Edittech extends StatelessWidget {
  Edittech({super.key});
  final TechnologyModel tech = Get.arguments["Tech"]; 
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offNamed('/Technology');
          },
        ),
        title: const Text("تعديل بيانات التقنية", style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<edit_tech>(
            init: edit_tech(),
            builder: (controller) {
              // Initialize the controllers when entering the screen
              controller.name.text = tech.technologyName;
              controller.power.text = tech.powerPerWater.toString();

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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                        label: 'نسبة الكهرباء',
                        hintText: 'ادخل نسبة الكهرباء',
                        icon: Icons.electric_bolt_outlined,
                        allowOnlyDigits: true,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              // Call the edit method with the updated technology model
                              controller.edittech(
                              tech: TechnologyModel(
                                powerPerWater: double.parse(controller.power.text),
                                technologyName: controller.name.text,
                              ), id:tech.technologyId! ,
                            );
                            }
                           
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
