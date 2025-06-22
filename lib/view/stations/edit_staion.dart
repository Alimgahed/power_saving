import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditStationsScreen extends StatelessWidget {
  EditStationsScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final Station station =
      Get.arguments["Stations"]; // ✅ Correct object retrieval

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC),
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              const Text(
                "تعديل محطة",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Get.offNamed('/Stations');
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<AddStationController>(
            init: AddStationController(),
            builder: (controller) {
              // Initialize only once with station data

              controller.name.text = station.stationName;
              controller.capacity.text =
                  station.stationWaterCapacity.toString();
              controller.stationTypeId = station.stationType;

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
                        items: const [
                          DropdownMenuItem(value: "مياة", child: Text("مياة")),
                          DropdownMenuItem(value: "صرف", child: Text("صرف")),
                        ],
                        initialValue: controller.stationTypeId,
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
                        hintText: 'ادخل كفاءة المحطة',
                        allowOnlyDigits: true,
                        icon: Icons.water,
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
                        initialValue: station.branchid,
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
                        initialValue: station.sourceid,
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
                              await controller.edit_Stations(
                                name: controller.name.text,
                                branchId: station.branchid!,
                                sourceId: station.sourceid!,
                                typeId: controller.stationTypeId!,
                                capacity: int.parse(controller.capacity.text),
                                Stations_id: station.stationId!,
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
