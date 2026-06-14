import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/empty_widget.dart';
import 'package:power_saving/core/widgets/main_screen/main_card_widgets.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/features/stations/view/widgets/branch_list.dart';
import '../../../../core/constant/styles.dart';
import '../../controller/all_stations_controller.dart';
class StationsBody extends StatelessWidget {
  final StationsController controller;
  const StationsBody({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(
          child: Text('جاري تحميل المحطات...', style: AppTextStyles.bodyMedium),
        );
      }

      if (controller.allStations.isEmpty) {
        return const ReusableEmptyView(
          message: 'لا توجد محطات مضافة بعد.',
          style: AppTextStyles.bodyMedium,
        );
      }

      if (controller.stations.isEmpty) {
        return const ReusableEmptyView(
          message: 'لا توجد محطات تطابق البحث.',
          style: AppTextStyles.bodyMedium,
        );
      }

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TotalHeader(count: controller.stations.length.toString(), title: 'إجمالي المحطات'),
                  const SizedBox(height: AppDimensions.paddingL),
                  BranchStats(stations: controller.stations),
                  const SizedBox(height: AppDimensions.paddingXL),
                ],
              ),
            ),
          ),
          SliverLayoutBuilder(
            builder: (context, constraints) {
              double spacing = AppDimensions.paddingS;
              int columns = (constraints.crossAxisExtent / 300).ceil();
              if (columns < 1) columns = 1;
              double itemWidth = (constraints.crossAxisExtent - (spacing * (columns - 1))) / columns;
              return SliverToBoxAdapter(
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: controller.stations.map((station) => SizedBox(
                    width: itemWidth,
                    child: _StationCard(station: station),
                  )).toList(),
                ),
              );
            }
          ),
        ],
      );
    });
  }
}



class _StationCard extends StatelessWidget {
  final dynamic station;
  const _StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(color: AppColors.shadowLight, blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          CardHeader(name: station.stationName),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            child: _StationInfoGrid(station: station),
          ),
         ReusableFooter(
  station: station, // Pass your station object here
  buttonLabel: 'تعديل', // Button text
  textLabel: 'تعديل المحطة', // Text before the button
  routeName: '/editStations', // Route to navigate to
  icon: Icons.edit, // Icon for the button
  arguments: {'Stations': station}, // Custom arguments
)

        ],
      ),
    );
  }
}



class _StationInfoGrid extends StatelessWidget {
  final dynamic station;
  const _StationInfoGrid({required this.station});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoCard(
                label: 'الفرع',
                value: station.branchName ?? 'غير محدد',
                icon: Icons.business,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Expanded(
              child: InfoCard(
                label: 'النوع',
                value: station.stationType,
                icon: Icons.settings,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                label: 'المصدر',
                value: station.waterSourceName ?? 'غير محدد',
                icon: Icons.water,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Expanded(
              child: InfoCard(
                label: 'الكفاءة',
                value: station.stationWaterCapacity.toString(),
                icon: Icons.speed,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}





