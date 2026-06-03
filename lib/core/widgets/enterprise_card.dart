import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

class EnterpriseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const EnterpriseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.paddingL),
    this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(
              left: padding.horizontal / 2, 
              right: padding.horizontal / 2,
              top: padding.vertical / 2,
              bottom: AppDimensions.paddingM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style: AppTextStyles.h4),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
        ],
        Padding(
          padding: title != null 
              ? EdgeInsets.only(
                  left: padding.horizontal / 2,
                  right: padding.horizontal / 2,
                  bottom: padding.vertical / 2,
                  top: AppDimensions.paddingM,
                ) 
              : padding,
          child: child,
        ),
      ],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              hoverColor: AppColors.primaryLight.withOpacity(0.3),
              child: cardContent,
            )
          : cardContent,
    );
  }
}
