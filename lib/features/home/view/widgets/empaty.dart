import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';

/// Empty State Widget
///
/// Displays when no data is available in a section
class EmptyStateWidget extends StatelessWidget {
  final Color color;
  final String? message;
  final String? description;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.color,
    this.message,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.14), color.withOpacity(0.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon ?? Icons.inbox_outlined,
              size: 52,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'لا توجد بيانات متاحة',
            style: const TextStyle(
              fontSize: HomeTypography.emptyTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description ?? 'لم يتم العثور على أي بيانات استهلاك مفرط',
            style: const TextStyle(
              fontSize: HomeTypography.emptyDesc,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
