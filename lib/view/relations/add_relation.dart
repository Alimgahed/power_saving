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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            "إضافة ربط جديد",
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
              Get.offNamed('/Relations');
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GetBuilder<addrelationcontroller>(
            init: addrelationcontroller(),
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
                            Icons.add_link,
                            size: 32,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'بيانات الربط الجديد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اختر المحطة، العداد، والتكنولوجيا المناسبة',
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
                          _buildSectionHeader('تفاصيل الربط', Icons.link, Colors.blue),

// First Dropdown - Station/Branch
SearchableDropdown(
  tag: 'station_dropdown', // Unique tag
  items: [
    ...controller.stationlist.map((p) {
      return DropdownMenuItem<String>(
        value: p.branchId.toString(), // Convert int to String
        child: Text(p.branchName),
      );
    }).toList(),
  ],
  onChanged: (value) {
    // Convert string back to int when assigning
    controller.stationid = value != null ? int.tryParse(value) : null;
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "يجب ادخال اسم المحطة".tr;
    }
    return null;
  },
  labelText: "المحطة".tr,
  hintText: 'اختر المحطة'.tr,
  prefixIcon: Icons.map,
),

const SizedBox(height: 16),

// Second Dropdown - Electric Meter
SearchableDropdown(
  tag: 'meter_dropdown', // Unique tag
  items: [
    ...controller.electricMeterList.map((p) {
      return DropdownMenuItem<String>(
        value: p.accountNumber, // Already a String
        child: Text(p.accountNumber ?? ""),
      );
    }).toList(),
  ],
  onChanged: (value) {
    // Direct assignment since it's already a string
    controller.counterid = value;
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "يجب ادخال اسم العداد".tr;
    }
    return null;
  },
  labelText: "العداد".tr,
  hintText: 'اختر العداد'.tr,
  prefixIcon: Icons.bolt,
),

const SizedBox(height: 16),

// Third Dropdown - Technology
SearchableDropdown(
  tag: 'technology_dropdown', // Unique tag
  items: [
    ...controller.technologylist.map((p) {
      return DropdownMenuItem<String>( // Changed to String
        value: p.technologyId.toString(), // Convert int to String
        child: Text(p.technologyName ),
      );
    }).toList(),
  ],
  onChanged: (value) {
    // Convert string back to int when assigning
    controller.techid = value != null ? int.tryParse(value) : null;
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "يجب ادخال اسم التكنولوجيا".tr;
    }
    return null;
  },
  labelText: "التكنولوجيا".tr,
  hintText: 'التكنولوجيا'.tr,
  prefixIcon: Icons.memory,
),
                         

                          const SizedBox(height: 24),
Obx((){
  return controller.looading.value?Center(child: CircularProgressIndicator(color: Colors.blue,),):
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
                              icon: const Icon(Icons.save, size: 20),
                              label: const Text(
                                'حفظ الربط',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
