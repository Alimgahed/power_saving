import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/features/relations/view/widgets/body.dart';

class RelationsScreen extends StatelessWidget {
  const RelationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RelationsController());

    final appBarWidget = ReusableAppBar(
      title: 'قائمة الربط',
      isSearching: controller.isSearching,
      hintText: 'ابحث باسم المحطة او رقم الأشتراك',
      searchController: controller.searchController,
      onSearchChanged: controller.onSearchChanged,
      onSearchToggle: controller.toggleSearch,
      onNavigateHome: () => Get.offNamed('/home'),
    );

    return AppScaffold(
      title: 'قائمة الربط',
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: RelationsBody(controller: controller)
    );
  }
}

 
 

  


