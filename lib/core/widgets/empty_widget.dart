import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/styles.dart';

class ReusableEmptyView extends StatelessWidget {
  final String message;
  final TextStyle? style;

  const ReusableEmptyView({
    super.key,
    required this.message,
    this.style = AppTextStyles.h3, // Default style if not passed
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: style));
  }
}
