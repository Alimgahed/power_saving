import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/helpers/extensions.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';

class SummarySection extends StatelessWidget {
  final BalanceChartController controller;

  const SummarySection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.balanceData.value?.balncedata ?? [];
    if (data.isEmpty) return const SizedBox.shrink(); // If there's no data, return an empty container

    final firstYear = data.first;
    final lastYear = data.last;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'الملخص الإحصائي',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'إجمالي السكان (بداية)',
                  value: formatNumber(firstYear.population.toDouble()),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'إجمالي السكان (نهاية)',
                  value: formatNumber(lastYear.population.toDouble()),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'الإنتاج الحالي',
                  value: '${formatNumber(lastYear.currentProduction.toDouble())} م³/يوم',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'السعة القصوى',
                  value: '${formatNumber(lastYear.maxProduction.toDouble())} م³/يوم',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
