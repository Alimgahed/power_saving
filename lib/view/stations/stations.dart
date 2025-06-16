import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/Stations/Stations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(get_all_stations());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة المحطات'),
          backgroundColor: Colors.white,

          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.offNamed('/addstations');
                  },
                  child: Text(
                    "اضاقة محطة جديدة",
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
            ),
          ],
          automaticallyImplyLeading: false, // This is true by default
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<get_all_stations>(
            builder: (controller) {
              return GridView.builder(
                itemCount: controller.allstations.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, // show exactly 3 per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final station = controller.allstations[index];
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
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              station.stationName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Reusable key-value row
                            infoRowWidget('الفرع:', station.branchName!),
                            infoRowWidget('نوع المحطة:', station.stationType),
                            infoRowWidget(
                              'الكفاءة التصميمية:',
                              "${station.stationWaterCapacity}",
                            ),
                            infoRowWidget(
                              'مصدر المياه:',
                              station.waterSourceName!,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Get.offNamed(
                                    '/editStations',
                                    arguments: {"Stations": station},
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.blue),
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
        ),
      ),
    );
  }
}
