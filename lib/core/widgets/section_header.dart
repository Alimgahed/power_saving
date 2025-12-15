import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  
  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = color ?? AppColors.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: headerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon, color: headerColor, size: AppDimensions.iconM),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: headerColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Container(
              height: 1,
              color: headerColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}