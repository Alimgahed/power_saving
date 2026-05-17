import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';

class FormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const FormCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }
}
