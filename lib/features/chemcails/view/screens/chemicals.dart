import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/chemcails/controller/chemacial.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/features/chemcails/view/widgets/chemical_body.dart';

class Chemicals extends StatelessWidget {
  const Chemicals({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Chemacialcontroller>();

    final appBarWidget = ReusableAppBar(
      title: 'قائمة المواد الكيميائية',
      isSearching: controller.isSearching,
      hintText: 'ابحث عن مصدر أو تقنية أو موسم...',
      searchController: controller.searchController,
      onSearchChanged: controller.onSearchChanged,
      onSearchToggle: controller.toggleSearch,
      onNavigateHome: () => Get.offNamed('/home'),
      customActions: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.offNamed('/AddChemicalScreen');
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("إضافة مرجع جديد"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E40AF),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );

    return AppScaffold(
      title: 'قائمة المواد الكيميائية',
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: ChemicalsBody(controller: controller),
    );
  }
}
