import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';

/// The same rounded menu control on the welcome header and screen toolbars.
class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Color.alphaBlend(AppColors.primary.withValues(alpha: 0.1), Colors.white),
      borderRadius: BorderRadius.circular(12),
    ),
    child: IconButton(
      icon: const Icon(Icons.menu, color: AppColors.primary, size: 28),
      onPressed: onPressed,
      tooltip: 'القائمة الرئيسية',
    ),
  );
}
