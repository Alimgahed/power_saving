import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

/// Shared form gutters and readable desktop width, with natural vertical scroll.
class FormPage extends StatelessWidget {
  const FormPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(
      MediaQuery.sizeOf(context).width < 600
          ? AppDimensions.paddingM
          : AppDimensions.paddingL,
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: child,
      ),
    ),
  );
}
