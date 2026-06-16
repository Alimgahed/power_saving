import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'dart:ui' as ui;

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? mobileAppBar;
  final Widget? desktopHeader;
  final bool showDrawer;

  AppScaffold({
    super.key,
    required this.body,
    this.title = 'إدارة الطاقة والمياه',
    this.floatingActionButton,
    this.actions,
    this.mobileAppBar,
    this.desktopHeader,
    this.showDrawer = true,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        appBar: mobileAppBar ?? AppBar(
          title: Text(title, style: AppTextStyles.appBarTitle),
          actions: actions,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        drawer: showDrawer ? HomeDrawer() : null,
        body: SafeArea(child: body),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
