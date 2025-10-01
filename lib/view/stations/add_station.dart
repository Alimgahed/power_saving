import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddStationScreen extends StatelessWidget {
  AddStationScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            "إضافة محطة جديدة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  Get.offNamed('/Stations');
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GetBuilder<AddStationController>(
            init: AddStationController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                 

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
                          // Station Information Section
                          _buildSectionHeader(
                            'معلومات المحطة',
                            Icons.location_city,
                            Colors.blue,
                          ),

                          CustomTextFormField(
                            label: 'اسم المحطة',
                            hintText: 'أدخل اسم المحطة',
                            icon: Icons.location_city,
                            controller: controller.name,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdownFormField<String>(
                                  items: [
                                    const DropdownMenuItem(
                                      value: "مياة",
                                      child: Text("مياة"),
                                    ),
                                    const DropdownMenuItem(
                                      value: "صرف",
                                      child: Text("صرف"),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    controller.stationTypeId = val!;
                                  },
                                  labelText: 'نوع المحطة',
                                  hintText: 'اختر نوع المحطة',
                                  prefixIcon: Icons.category,
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'الرجاء اختيار نوع المحطة'
                                              : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'الطاقة التصميمية',
                                  hintText: 'ادخل الطاقة المحطه',
                                  icon: Icons.water,
                                  allowOnlyDigits: true,
                                  controller: controller.capacity,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

                          // Location Information Section
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdownFormField<int>(
                                  items:
                                      controller.branchList.map((branch) {
                                        return DropdownMenuItem<int>(
                                          value: branch.branchId,
                                          child: Text(branch.branchName),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    controller.branchId = value;
                                  },
                                  labelText: 'الفرع',
                                  hintText: 'اختر الفرع',
                                  prefixIcon: Icons.map,
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'الرجاء اختيار الفرع'
                                              : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomDropdownFormField<int>(
                                  items:
                                      controller.waterSourceList.map((source) {
                                        return DropdownMenuItem<int>(
                                          value: source.waterSourceId,
                                          child: Text(source.waterSourceName!),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    controller.sourceId = value;
                                  },
                                  labelText: 'مصدر المياه',
                                  hintText: 'اختر مصدر المياه',
                                  prefixIcon: Icons.water_drop,
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'الرجاء اختيار مصدر المياه'
                                              : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Obx((){
                            return controller.looading.value?
                            Center(child: CircularProgressIndicator(color: Colors.blue,),):
                             SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  await controller.addStation(
                                    name: controller.name.text,
                                    branchId: controller.branchId!,
                                    sourceId: controller.sourceId!,
                                    typeId: controller.stationTypeId!,
                                    capacity: int.parse(
                                      controller.capacity.text,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.save, size: 20),
                              label: const Text(
                                'حفظ المحطة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
