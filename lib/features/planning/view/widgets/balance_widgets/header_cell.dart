import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/styles.dart';

class TableHeader extends StatelessWidget {
  final String text;
  const TableHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
class TableCells extends StatelessWidget {
  final String text;

  const TableCells({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 9,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
