import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF1E40AF),
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'لوحة التحكم الرئيسية',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        tooltip: 'القائمة',
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}