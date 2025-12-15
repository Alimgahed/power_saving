import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backRoute;
  final List<Widget>? actions;
  final bool showBackButton;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.backRoute,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.appBarTitle),
      backgroundColor: AppColors.primary,
      elevation: AppDimensions.elevationNone,
      centerTitle: true,
      actions: [
        if (showBackButton)
          Container(
            margin: const EdgeInsets.only(left: AppDimensions.paddingL),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: AppColors.textWhite),
              onPressed: () {
                if (backRoute != null) {
                  Get.offNamed(backRoute!);
                } else {
                  Get.back();
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.overlayBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}