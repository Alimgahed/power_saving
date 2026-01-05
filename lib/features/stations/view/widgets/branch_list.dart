import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

import '../../../../core/constant/AppDimensions.dart';

class BranchStats extends StatelessWidget {
  final List stations;
  const BranchStats({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> stats = {};

    for (var s in stations) {
      final name = s.branchName ?? 'غير محدد';
      stats[name] = (stats[name] ?? 0) + 1;
    }

    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: stats.entries.map((e) {
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
              Text('${e.value} محطة', style: AppTextStyles.h3),
            ],
          ),
        );
      }).toList(),
    );
  }
}