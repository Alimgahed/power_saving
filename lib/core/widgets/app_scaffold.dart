import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/widgets/responsive_wrapper.dart';
import 'package:power_saving/features/home/view/widgets/enterprise_sidebar.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'dart:ui' as ui;

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? mobileAppBar;
  final Widget? desktopHeader;

  AppScaffold({
    super.key,
    required this.body,
    this.title = 'إدارة الطاقة والمياه',
    this.floatingActionButton,
    this.actions,
    this.mobileAppBar,
    this.desktopHeader,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: ResponsiveWrapper(
        mobile: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          appBar: mobileAppBar ?? AppBar(
            title: Text(title, style: AppTextStyles.appBarTitle),
            actions: actions,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          drawer: HomeDrawer(),
          body: SafeArea(child: body),
          floatingActionButton: floatingActionButton,
        ),
        desktop: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Row(
              children: [
                EnterpriseSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      // Desktop Header
                      desktopHeader ?? Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                        ),
                        child: Row(
                          children: [
                            Text(title, style: AppTextStyles.h3),
                            const Spacer(),
                            if (actions != null) ...actions!,
                          ],
                        ),
                      ),
                      // Content
                      Expanded(
                        child: body,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
