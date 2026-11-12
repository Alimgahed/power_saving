import 'package:power_saving/core/widgets/request_error_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/features/chemcails/controller/chemacial.dart';
import 'package:power_saving/features/chemcails/view/widgets/chemical_card.dart';

class ChemicalsBody extends StatelessWidget {
  final Chemacialcontroller controller;

  const ChemicalsBody({super.key, required this.controller});

  Widget _buildFilterBadge({
    required String label,
    required int count,
    required String filterValue,
    required Color color,
  }) {
    final isSelected = controller.selectedFilter.value == filterValue;
    return GestureDetector(
      onTap: () => controller.setFilter(filterValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 16, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              '$label ($count)',
              style: TextStyle(
                color: isSelected ? color : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.loadError.value.isNotEmpty) {
        return RequestErrorView(message: controller.loadError.value,
          onRetry: controller.forceRefresh);
      }
      if (controller.allChemicals.isEmpty) {
        if (controller.isRefreshing.value) return const Center(child: CircularProgressIndicator());
        return const ReusableEmptyView(message: 'لا توجد بيانات للعرض');
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.forceRefresh();
        },
        child: CustomScrollView(
          slivers: [
            if (controller.isRefreshing.value)
              const SliverToBoxAdapter(child: Column(children: [
                LinearProgressIndicator(), Text('جاري تحديث البيانات المعروضة...'),
              ])),
            // Header Section
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TotalHeader(
                        count: controller.chemicals.length.toString(),
                        title: controller.selectedFilter.value == 'all'
                            ? 'إجمالي المراجع الكيميائية'
                            : controller.selectedFilter.value == 'summer'
                                ? 'مراجع الصيف'
                                : 'مراجع الشتاء',
                        icon: Icons.science,
                      ),
                    ),
                    _buildFilterBadge(
                      label: 'الكل',
                      count: controller.allChemicals.length,
                      filterValue: 'all',
                      color: Colors.blue,
                    ),
                    _buildFilterBadge(
                      label: 'الصيف',
                      count: controller.summerCount,
                      filterValue: 'summer',
                      color: Colors.orange,
                    ),
                    _buildFilterBadge(
                      label: 'الشتاء',
                      count: controller.winterCount,
                      filterValue: 'winter',
                      color: Colors.cyan,
                    ),
                  ],
                ),
              ),
            ),
            
            // Spacer
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.paddingL),
            ),
            
            // Error or Empty State Messages
            if (controller.searchError.value.isNotEmpty)
              SliverToBoxAdapter(
                child: EmptyStateWidget(
                  message: controller.searchError.value,
                  color: Colors.orange,
                ),
              )
            else
              // Responsive List/Grid (Lazy Loading)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.crossAxisExtent;
                    final bool isMobile = width < 600;

                    if (isMobile) {
                      // Mobile: Use List for dynamic height (no overflow)
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ChemicalCard(
                                chemical: controller.chemicals[index],
                                controller: controller,
                                index: index + 1,
                              ),
                            );
                          },
                          childCount: controller.chemicals.length,
                        ),
                      );
                    } else {
                      // Tablet/Desktop: Use Wrap with calculated width for perfect natural heights (No empty spaces)
                      int columns = (width / 350).floor();
                      if (columns < 2) columns = 2;
                      
                      const double spacing = 16.0;
                      double itemWidth = (width - (spacing * (columns - 1))) / columns;
                      
                      // Subtract a tiny fraction to prevent floating point rounding issues causing wrap
                      itemWidth = itemWidth - 0.1;
                      
                      return SliverToBoxAdapter(
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: controller.chemicals.asMap().entries.map((entry) {
                            int index = entry.key;
                            var chemical = entry.value;
                            
                            return SizedBox(
                              width: itemWidth,
                              child: ChemicalCard(
                                chemical: chemical,
                                controller: controller,
                                index: index + 1,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
              
              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.paddingXXL)),
          ],
        ),
      );
    });
  }
}
