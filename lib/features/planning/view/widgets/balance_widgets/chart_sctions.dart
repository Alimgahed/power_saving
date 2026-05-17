import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';

class ChartSection extends StatelessWidget {
  final BalanceChartController controller;

  const ChartSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final chartBase64 = controller.balanceData.value?.chart;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Directly place the header inside the main widget
          Row(
            children: const [
              Icon(
                Icons.show_chart,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'منحنى الاتزان المائي',
                style: AppTextStyles.h2,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Conditionally display the chart or the empty state
          if (chartBase64 != null && chartBase64.isNotEmpty)
            _ChartImage(base64Data: chartBase64)
          else
            const _EmptyChart(),
        ],
      ),
    );
  }
}
class _ChartImage extends StatelessWidget {
  final String base64Data;

  const _ChartImage({
    required this.base64Data,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          base64Decode(base64Data),
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'لا يوجد رسم بياني',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
