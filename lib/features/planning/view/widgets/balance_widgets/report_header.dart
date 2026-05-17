import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.water_drop,
            size: 48,
            color: AppColors.textWhite,
          ),
          const SizedBox(height: 12),
          Text(
            'تقرير منحنى الاتزان المائي',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
        
        ],
      ),
    );
  }
}
