import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/helpers/extensions.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/view/widgets/blance_widget.dart/header_cell.dart';

class PlacesTable extends StatelessWidget {
  final BalanceChartController controller;

  const PlacesTable({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final places = controller.balanceData.value?.areaData?.places;
    if (places == null || places.isEmpty) return const SizedBox.shrink(); // Return empty if no data

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_city,
                color: AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'الأماكن والسكان',
                style: AppTextStyles.h2,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: AppColors.borderLight),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1)),
                children: const [
                  TableHeader(text: 'المنطقة'),
                  TableHeader(text: 'الفرع'),
                  TableHeader(text: 'المكان'),
                  TableHeader(text: 'نوع المكان'),
                  TableHeader(text: 'السكان (2006)'),
                  TableHeader(text: 'السكان (2017)'),
                ],
              ),
              ...places.map(
                (place) {
                  final pop2006 = place.populations.firstWhere((p) => p.populationYear == 2006, orElse: () => place.populations.first);
                  final pop2017 = place.populations.firstWhere((p) => p.populationYear == 2017, orElse: () => place.populations.last);
                  return TableRow(
                    children: [
                      TableCells(text: place.areaName),
                      TableCells(text: place.branchName),
                      TableCells(text: place.placeName),
                      TableCells(text: place.placeTypeName),
                      TableCells(text: formatNumber(pop2006.population.toDouble())),
                      TableCells(text: formatNumber(pop2017.population.toDouble())),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
