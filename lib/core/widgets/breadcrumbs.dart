import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

class Breadcrumbs extends StatelessWidget {
  final List<String> paths;
  
  const Breadcrumbs({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    List<Widget> breadcrumbWidgets = [];
    
    for (int i = 0; i < paths.length; i++) {
      final isLast = i == paths.length - 1;
      
      breadcrumbWidgets.add(
        InkWell(
          onTap: isLast ? null : () {
            // Simplified navigation logic for breadcrumbs. 
            // In a fully nested setup, this would pop routes.
            if (i == 0) Get.offAllNamed('/home');
          },
          child: Text(
            paths[i],
            style: AppTextStyles.bodyMedium.copyWith(
              color: isLast ? AppColors.primary : AppColors.textMuted,
              fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
      
      if (!isLast) {
        breadcrumbWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.chevron_left, size: 16, color: AppColors.textMuted), // RTL chevron
          ),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: breadcrumbWidgets,
    );
  }
}
