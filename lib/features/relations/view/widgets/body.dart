import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';

import 'package:get/get.dart';
import 'package:power_saving/features/relations/view/widgets/relations_card.dart';
class RelationsBody extends StatelessWidget {
  final RelationsController controller;

  const RelationsBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Checking if the loading value is true
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.relations.isEmpty) {
        return const ReusableEmptyView(message: 'لا توجد  بيانات للعرض');
      }

      return CustomScrollView(
        slivers: [
          // Header Section
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            sliver: SliverToBoxAdapter(
              child: TotalHeader(count:  controller.relations.length.toString(), title: 'إجمالي عمليات الربط',
              icon: Icons.link, ),
            ),
          ),
          
          // Spacer
          SliverToBoxAdapter(
            child: const SizedBox(height: AppDimensions.paddingXXL),
          ),
          
        // Error or Empty State Messages
        if (controller.searchError.value.isNotEmpty)
          SliverToBoxAdapter(
            child: const EmptyStateWidget(
              message: 'خطأ في البحث',
              color: Colors.orange,
            ),
          )
        else
          // Relations Grid
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.crossAxisExtent;
                
                // Define aspect ratio based on width
                final double aspectRatio = width > 600 ? 0.9 : 1.1;
                
                // Determine the number of columns based on the width
                final int crossAxisCount = (width / 280).floor().clamp(1, 8);
                
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return RelationsCard( 
                        relation: controller.relations[index],
                        controller: controller,
                      );
                    },
                    childCount: controller.relations.length,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
