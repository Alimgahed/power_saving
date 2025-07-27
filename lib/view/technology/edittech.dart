import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/technology/technlogy.dart';
import 'package:power_saving/model/tech_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Edittech extends StatelessWidget {
  Edittech({super.key});

  final TechnologyModel? tech = Get.arguments!=null?Get.arguments["Tech"]:null;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
      if (tech == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Technology');
      });}
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            "تعديل بيانات التقنية",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offNamed('/Technology');
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GetBuilder<edit_tech>(
            init: edit_tech(),
            
            builder: (controller) {
                controller.name.text = tech!.technologyName;
              controller.power.text = tech!.powerPerWater.toString();
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
                          'تعديل بيانات التقنية',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'قم بتحديث المعلومات الخاصة بالتقنية',
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
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'معلومات التقنية',
                            Icons.memory,
                            Colors.blue,
                          ),

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
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 24),
Obx((){
  return 
  controller.looading.value?Center(child: CircularProgressIndicator(color: Colors.blue,),):
    SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  await controller.edittech(
                                    tech: TechnologyModel(
                                      technologyId: tech!.technologyId,
                                      technologyName: controller.name.text,
                                      powerPerWater:
                                          double.parse(controller.power.text),
                                    ),
                                    id: tech!.technologyId!,
                                  );
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text(
                                'حفظ التعديلات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
})
                        
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
