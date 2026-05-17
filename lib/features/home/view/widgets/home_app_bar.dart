import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';

/// Custom AppBar for Home Screen
///
/// Displays the main title and drawer toggle button
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppBar({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppGradients.header),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textWhite,
      shadowColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'لوحة التحكم الرئيسية',
        style: TextStyle(
          fontSize: HomeTypography.appBarTitle,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textWhite, size: 28),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        tooltip: 'القائمة',
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
