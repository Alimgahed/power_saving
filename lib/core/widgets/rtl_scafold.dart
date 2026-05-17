import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';

class RTLScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const RTLScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppColors.background,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
