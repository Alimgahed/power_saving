import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/features/technology/view/widgets/technology_body.dart';
import 'package:power_saving/global/data.dart';

class Technology extends StatelessWidget {
  const Technology({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TechnlogyController>();

    final appBarWidget = ReusableAppBar(
      title: 'قائمة تقنيات الترشيح',
      isSearching: controller.isSearching,
      searchController: controller.searchController,
      onSearchChanged: controller.onSearchChanged,
      onSearchToggle: () {
        controller.toggleSearch();
      },
      onNavigateHome: () => Get.offNamed('/home'),
      customActions: [
        if (user?.groupId == 1 || user?.groupId == 2)
          ReusableActionButton(
            label: 'إضافة تقنية',
            icon: Icons.add,
            route: '/addTech',
          ),
      ],
    );

    return AppScaffold(
      title: 'قائمة تقنيات الترشيح',
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: TechnologyBody(controller: controller),
    );
  }
}