import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddStationScreen extends StatelessWidget {
  AddStationScreen({super.key});
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
            Get.offNamed('/Stations');
          },
        ),
        title: const Text("إضافة محطة جديدة", style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<AddStationController>(
            init: AddStationController(),
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
                        'إدخال بيانات المحطة',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomTextFormField(
                        label: 'اسم المحطة',
                        hintText: 'أدخل اسم المحطة',
                        icon: Icons.location_city,
                        controller: controller.name,
                      ),
                      const SizedBox(height: 16),

                      CustomDropdownFormField<String>(
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
                                val == null ? 'الرجاء اختيار نوع المحطة' : null,
                      ),

                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: 'الكفاءة التصميمية',
                        hintText: 'ادخل كفاءة المحطه',
                        icon: Icons.water,
                        allowOnlyDigits: true,
                        controller: controller.capacity,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      CustomDropdownFormField<int>(
                        items:
                            controller.branchList.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch.branchId,
                                child: Text(branch.branchName!),
                              );
                            }).toList(),
                        onChanged: (value) {
                          controller.branchId = value;
                        },
                        labelText: 'الفرع',
                        hintText: 'اختر الفرع',
                        prefixIcon: Icons.map,
                        validator:
                            (val) => val == null ? 'الرجاء اختيار الفرع' : null,
                      ),
                      const SizedBox(height: 32),

                      CustomDropdownFormField<int>(
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

                      const SizedBox(height: 32),

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
                                capacity: int.parse(controller.capacity.text),
                              );
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ المحطة'),
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
