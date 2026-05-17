import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/helpers/extensions.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/header_cell.dart';

class WaterDataTable extends StatelessWidget {
  final BalanceChartController controller;

  const WaterDataTable({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.balanceData.value?.balncedata ?? [];
    if (data.isEmpty) return const SizedBox.shrink(); // Early return for no data

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'جدول البيانات المائية التفصيلي',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: AppColors.borderLight),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1),
              7: FlexColumnWidth(1.2),
              8: FlexColumnWidth(1.2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.1)),
                children: const [
                  TableHeader(text: 'السنة'),
                  TableHeader(text: 'السكان'),
                  TableHeader(text: 'الاحتياج المائي\n(م³/يوم)'),
                  TableHeader(text: 'شهري متوسط\n(م³/يوم)'),
                  TableHeader(text: 'يومي متوسط\n(م³/يوم)'),
                  TableHeader(text: 'ساعي\n(م³/س)'),
                  TableHeader(text: 'مياه إطفاء\n(لتر/ث)'),
                  TableHeader(text: 'الإنتاج الحالي\n(م³/يوم)'),
                  TableHeader(text: 'السعة القصوى\n(م³/يوم)'),
                ],
              ),
              ...data.map(
                (row) => TableRow(
                  children: [
                    TableCells(text: row.year.toString()),
                    TableCells(text: formatNumber(row.population.toDouble())),
                    TableCells(text: formatNumber(row.waterNeed.toDouble())),
                    TableCells(text: formatNumber(row.qDemandedMonthlyAvg.toDouble())),
                    TableCells(text: formatNumber(row.qDemandedDailyAvg.toDouble())),
                    TableCells(text: formatNumber(row.qDemandedHourly.toDouble())),
                    TableCells(text: formatNumber(row.qFire.toDouble())),
                    TableCells(text: formatNumber(row.currentProduction.toDouble())),
                    TableCells(text: formatNumber(row.maxProduction.toDouble())),
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
