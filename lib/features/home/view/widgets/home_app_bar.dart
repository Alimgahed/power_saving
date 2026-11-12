import 'package:flutter/material.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

/// Custom AppBar for Home Screen
///
/// Displays the main title and drawer toggle button
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'لوحة التحكم الرئيسية',
      showBackButton: false,

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
