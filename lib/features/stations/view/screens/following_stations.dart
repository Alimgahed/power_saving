import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';
import 'package:power_saving/features/stations/controller/following_stations._controller.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';

class FollowingStationsScreen extends StatelessWidget {
  const FollowingStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return RTLScaffold(
      backgroundColor: AppColors.background,
      body: GetBuilder<FollowingStationsController>(
        init: FollowingStationsController(),
        builder: (controller) {
                          
          return
           Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              

              /// 🔽 Stations Dropdown
              DropdownButtonFormField<Station>(
                hint: const Text("اختر المحطة"),
                value: controller.selectedStation,
                items: controller.stations
                    .map(
                      (station) => DropdownMenuItem(
                        value: station,
                        child: Text(station.stationName),
                      ),
                    )
                    .toList(),
                onChanged:
                
                 controller.onStationChanged,
              ),

              const SizedBox(height: 16),

              /// 🔽 Tech Dropdown (يظهر بس لو فيه techs)
              if (controller.selectedStation != null &&
                  controller.selectedStation!.techs.isNotEmpty)
                DropdownButtonFormField<TechnologyModel>(
                  hint: const Text("اختر نوع التكنولوجيا"),
                  value: controller.selectedTech,
                  items: controller.selectedStation!.techs
                      .map(
                        (tech) => DropdownMenuItem(
                          value: tech,
                          child: Text(tech.technologyName),
                        ),
                      )
                      .toList(),
                  onChanged: controller.onTechChanged,
                ),
                PrimaryButton(
                  label: 'عرض التحليل',
                  onPressed: () {
                    Get.toNamed(
                      '/analysis',
                      arguments: {
                        'station': controller.selectedStation?.stationId,
                        'tech': controller.selectedTech?.technologyId,
                      },
                    );
                  },
                ),

              /// ℹ️ Info


            ],
           ),
          );
      
        },
      
    ));
  }
}
