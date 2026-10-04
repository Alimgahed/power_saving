import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';

import '../../../../core/constant/styles.dart';
import '../../model/tech_model.dart';

class TechnologyBody extends StatelessWidget {
  final TechnlogyController controller;

  const TechnologyBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TechnlogyController>(
      builder: (controller) {
        // Loading State
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'جاري تحميل التقنيات...',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          );
        }

        // Empty State (All data is empty)
        if (controller.all_technology.isEmpty) {
          return const ReusableEmptyView(
            message: 'لا توجد تقنيات متاحة حالياً. الرجاء إضافة تقنية جديدة.',
            style: AppTextStyles.bodyMedium,
          );
        }

        // Get filtered technologies
        List<TechnologyModel> filteredTech = controller.getFilteredTechnologies();

        // Empty Filter/Search Result
        if (filteredTech.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXL),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.search_off,
                    size: 48,
                    color: Colors.orange.shade300,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                const Text(
                  'لا توجد نتائج',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
                const Text(
                  'لا توجد تقنيات تطابق البحث',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          );
        }

        // Calculate type statistics based on all available tech
        Map<String, int> typeStats = {};
        for (var tech in controller.all_technology) {
          typeStats[tech.main_type] = (typeStats[tech.main_type] ?? 0) + 1;
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.forceRefresh();
          },
          child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // Filter Info Badge
                    if (controller.selectedFilter != 'all')
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.filter_list, size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 6),
                              Text(
                                'تصفية: ${controller.selectedFilter} (${filteredTech.length})',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => controller.filterByType('all'),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Total Header & Statistics
                    Wrap(
                      spacing: AppDimensions.paddingM,
                      runSpacing: AppDimensions.paddingM,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          child: TotalHeader(
                            count: filteredTech.length.toString(),
                            title: controller.selectedFilter == 'all'
                                ? 'إجمالي التقنيات'
                                : 'تقنيات ${controller.selectedFilter}',
                          ),
                        ),
                        ...typeStats.entries.map((entry) {
                          Color cardColor = entry.key == 'معالجة'
                              ? Colors.purple
                              : entry.key == 'ضخ'
                                  ? Colors.blue
                                  : Colors.green;

                          IconData cardIcon = entry.key == 'معالجة'
                              ? Icons.cleaning_services
                              : entry.key == 'ضخ'
                                  ? Icons.water_drop
                                  : Icons.settings;

                          return Container(
                            width: 140,
                            padding: const EdgeInsets.all(AppDimensions.paddingM),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: cardColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        cardIcon,
                                        color: cardColor,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: AppTextStyles.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDimensions.paddingXS),
                                Text(
                                  '${entry.value} تقنية',
                                  style: AppTextStyles.h3.copyWith(color: cardColor),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Technologies Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  double spacing = AppDimensions.paddingM;
                  // Dynamic column calculation
                  int columns = (constraints.crossAxisExtent / 320).floor();
                  if (columns < 1) columns = 1;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      mainAxisExtent: 260, // Adjusted fixed height for card
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _TechnologyCard(tech: filteredTech[index]);
                      },
                      childCount: filteredTech.length,
                    ),
                  );
                },
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.paddingXXL),
            ),
          ],
        ),
        );
      },
    );
  }
}

class _TechnologyCard extends StatelessWidget {
  final TechnologyModel tech;

  const _TechnologyCard({required this.tech});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration:  BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                topRight: Radius.circular(AppDimensions.radiusL),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    tech.technologyName,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'التصنيف الرئيسي',
                        style: AppTextStyles.bodySmall,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          tech.main_type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  // Power Info
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingS),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.electric_bolt,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: AppDimensions.paddingXS),
                        const Text(
                          'معدل استهلاك الكهرباء',
                          style: AppTextStyles.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          "${tech.powerPerWater}",
                          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Get.offNamed('/Edittech', arguments: {"Tech": tech});
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('تعديل البيانات'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
