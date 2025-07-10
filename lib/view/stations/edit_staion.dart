import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/model/station_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class EditStationsScreen extends StatelessWidget {
  EditStationsScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final Station station = Get.arguments["Stations"];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            "تعديل محطة",
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
              // Initialize controller with station data only once
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.name.text.isEmpty) {
                  controller.name.text = station.stationName;
                  controller.capacity.text =
                      station.stationWaterCapacity.toString();
                  controller.stationTypeId = station.stationType;
                  controller.branchId = station.branchid;
                  controller.sourceId = station.sourceid;
                }
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card

                  // Station Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المحطة الحالية: ${station.stationName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              Text(
                                'معرف المحطة: ${station.stationId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
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
                                  items: const [
                                    DropdownMenuItem(
                                      value: "مياة",
                                      child: Text("مياة"),
                                    ),
                                    DropdownMenuItem(
                                      value: "صرف",
                                      child: Text("صرف"),
                                    ),
                                  ],
                                  initialValue: station.stationType,
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
                                  label: 'الكفاءة التصميمية',
                                  hintText: 'ادخل كفاءة المحطة',
                                  icon: Icons.water,
                                  allowOnlyDigits: true,
                                  controller: controller.capacity,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

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
                                  initialValue: station.branchid,
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
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  await controller.edit_Stations(
                                    name: controller.name.text,
                                    branchId:
                                        controller.branchId ??
                                        station.branchid!,
                                    sourceId:
                                        controller.sourceId ??
                                        station.sourceid!,
                                    typeId: controller.stationTypeId!,
                                    capacity: int.parse(
                                      controller.capacity.text,
                                    ),
                                    Stations_id: station.stationId!,
                                  );
                                }
                              },
                              icon: const Icon(Icons.edit, size: 20),
                              label: const Text(
                                'تحديث المحطة',
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action Buttons
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
