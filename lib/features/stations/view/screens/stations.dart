import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/core/widgets/rtl_scafold.dart';

import 'package:power_saving/features/stations/controller/all_stations_controller.dart';
import 'package:power_saving/features/stations/view/widgets/Stations_body.dart';
import 'package:power_saving/gloable/data.dart';


class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StationsController());

    return RTLScaffold(
      backgroundColor: AppColors.background,
      appBar: ReusableAppBar(
          title: 'قائمة المحطات',
          isSearching: controller.isSearching,
          searchController: controller.searchController,
          onSearchChanged: controller.onSearchChanged,
          onSearchToggle: () {
          
              controller.toggleSearch();
            
          },
          onNavigateHome: () => Get.offNamed('/home'),
          customActions: [
            // if (controller.isSearching.value)
            
            if(user?.groupId==1||user?.groupId==2)
              ReusableActionButton(
                label: 'إضافة محطة',
                icon: Icons.add,
                route: '/addstations',
              
              ),
         
          ],
        ),
      body: StationsBody(controller: controller)
    );
  }
}





