import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/controller/prediaction/prediaction.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Predaction extends StatelessWidget {
  Predaction({super.key});

  final get_all_stations getAllStation = Get.put(get_all_stations());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? stationId;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'تحليل التنبؤ بالمياه',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => Get.offAllNamed('/home'),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GetBuilder<Prediactioncontroller>(
          init: Prediactioncontroller(),
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStationSelector(controller),
                    const SizedBox(height: 20),

                    if (controller.predictionModel == null)
                      const Center(
                        child: Text(
                          "الرجاء اختيار محطة للتنبؤ",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else ...[
                      _buildChartCard(
                        controller.predictionModel!.predictionPlot,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoCard(
                        "السنة المتوقعة",
                        controller.predictionModel!.expectedYear.toString(),
                      ),
                      _buildInfoCard(
                        "الطاقة التصميمية",
                        "${controller.predictionModel!.waterCapacity} متر مكعب",
                      ),
                      _buildInfoCard(
                        "دقة التوقع",
                        "${controller.predictionModel!.representedPoints.toStringAsFixed(1)}%",
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStationSelector(Prediactioncontroller controller) {
    return GetBuilder<get_all_stations>(
      builder: (stationController) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomDropdownFormField<int>(
                items:
                    stationController.allstations.map((station) {
                      return DropdownMenuItem<int>(
                        value: station.stationId,
                        child: Text(station.stationName),
                      );
                    }).toList(),
                onChanged: (value) => stationId = value,
                labelText: 'المحطة',
                hintText: 'اختر المحطة',
                prefixIcon: Icons.map,
                validator: (val) => val == null ? 'الرجاء اختيار المحطة' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.prediactions(stationId!);
                  } else {
                    Get.snackbar(
                      "خطأ",
                      "الرجاء اختيار محطة",
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.black87,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("تنبؤ"),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartCard(String base64Image) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'الرسم البياني للتنبؤ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 350,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(base64Image),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("خطأ في تحميل الصورة"));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1E40AF)),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
