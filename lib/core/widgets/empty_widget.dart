import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

class ReusableEmptyView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final TextStyle? style;


  const ReusableEmptyView({
    super.key,
    
    this.title = 'لا توجد بيانات',
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconXL,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              title,
              style: style ?? AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.paddingL),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
