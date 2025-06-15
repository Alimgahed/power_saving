import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/counter/counter.dart';

class Counterscreen extends StatelessWidget {
  const Counterscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة العدادات'),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Get.offNamed('/addCounter');
                },
                child: const Text(
                  "اضافة عداد جديد",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Get.offNamed('/home');
                },
              ),
            ],
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<Counter_controller>(
        init: Counter_controller(),
        builder: (controller) {
          return GridView.builder(
            itemCount: controller.allcounter.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.73,
            ),
            itemBuilder: (context, index) {
              final meter = controller.allcounter[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meter.voltageType!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "تفاصيل العداد",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('رقم الحساب', meter.accountNumber!),
                     
                        _buildInfoRow(
                          'القراءة النهائية',
                          meter.finalReading.toString(),
                        ),
                        _buildInfoRow(
                          'معامل العداد',
                          meter.meterFactor.toString(),
                        ),
                        _buildInfoRow('معرّف العداد', meter.meterId),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              
                              // Implement navigation to edit screen with meter as argument
                              Get.offNamed('/editMeter', arguments: {"meter": meter});
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget _buildInfoRow(String key, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          key,
          style: const TextStyle(color: Colors.black54),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    ),
  );
}
