import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/helpers/extensions.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/header_cell.dart';

class StationsTable extends StatelessWidget {
  final BalanceChartController controller;

  const StationsTable({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final stations = controller.balanceData.value?.areaData?.stations;
    if (stations == null || stations.isEmpty) return const SizedBox.shrink(); // No data case

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
                Icons.water,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'محطات المياه (${stations.length} محطة)',
                style: AppTextStyles.h2,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: AppColors.borderLight),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1)),
                children: const [
                  TableHeader(text: 'اسم المحطة'),
                  TableHeader(text: 'النوع'),
                  TableHeader(text: 'السعة (م³/يوم)'),
                ],
              ),
              ...stations.map(
                (station) => TableRow(
                  children: [
                    TableCells(text: station.stationName),
                    TableCells(text: station.stationType),
                    TableCells(text: formatNumber((station.stationWaterCapacity ?? 0).toDouble())),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
