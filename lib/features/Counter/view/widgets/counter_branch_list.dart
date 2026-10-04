import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/widgets/main_screen/totl_header.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/features/Counter/model/Counter_model.dart';

class CounterBranchStats extends StatelessWidget {
  final List<ElectricMeter> counters;
  const CounterBranchStats({super.key, required this.counters});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> stats = {};

    for (var c in counters) {
      final name = c.branch ?? 'غير محدد';
      stats[name] = (stats[name] ?? 0) + 1;
    }

    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: [
        SizedBox(
          width: 250,
          child: TotalHeader(
            count: counters.length.toString(),
            title: 'إجمالي العدادات',
          ),
        ),
        ...stats.entries.map((e) {
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
                Text(e.key, style: AppTextStyles.bodySmall),
                const SizedBox(height: AppDimensions.paddingXS),
                Text('${e.value} عداد', style: AppTextStyles.h3),
              ],
            ),
          );
        }),
      ],
    );
  }
}
