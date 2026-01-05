import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/features/planning/controller/place/places_controller.dart';
import 'package:power_saving/features/planning/view/widgets/place_widget/placeCard.dart';
import 'package:power_saving/main.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlacesController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: ReusableAppBar(
          title: 'قائمة الأماكن',
          isSearching: controller.isSearching,
          onSearchToggle: controller.toggleSearch,
          onNavigateHome: () => Get.offNamed('/home'),
          onSearchChanged: controller.onSearchChanged,
          customActions: const [
            ReusableActionButton(
              label: 'إضافة مكان',
              icon: Icons.add,
              route: '/AddPlaces',
            ),
          ],
        ),
        body: _buildBody(controller),
      ),
    );
  }

  /// ✅ Body (returns RenderBox, not Sliver)
  Widget _buildBody(PlacesController controller) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.places.isEmpty) {
        return const ReusableEmptyView(message: 'لا توجد أماكن متاحة');
      }

      return CustomScrollView(
        slivers: _buildSlivers(controller),
      );
    });
  }

  /// ✅ ALL slivers live here
  List<Widget> _buildSlivers(PlacesController controller) {
    return [
      if (controller.searchError.value.isNotEmpty)
        SliverToBoxAdapter(
          child: EmptyStateWidget(
            message: controller.searchError.value,
            color: Colors.red,
          ),
        ),

      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverToBoxAdapter(
          child: TotalHeader(
            count: controller.places.length.toString(),
            title: 'إجمالي الأماكن',
          ),
        ),
      ),

      _responsivePlacesGrid(controller),

      const SliverToBoxAdapter(
        child: SizedBox(height: 20),
      ),
    ];
  }

  /// ✅ Dynamic SliverGrid with LayoutBuilder (No Width Condition)
  Widget _responsivePlacesGrid(PlacesController controller) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {

          final double aspectRatio = width > 600 ? 0.7 : 0.8;

          final int crossAxisCount = (width / 280).floor(); 

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PlaceCard(
                  place: controller.places[index],
                );
              },
              childCount: controller.places.length,
            ),
          );
        },
      ),
    );
  }
}
