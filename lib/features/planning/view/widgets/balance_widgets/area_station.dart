import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';

class AreaSection extends StatelessWidget {
  final BalanceChartController controller;

  const AreaSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final areaData = controller.balanceData.value?.areaData;
    if (areaData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SectionHeader(),
          const SizedBox(height: 16),
          InfoItem(
            label: 'اسم المنطقة',
            value: areaData.areaName,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InfoItem(
                  label: 'عدد الأماكن',
                  value: '${areaData.places.length} موقع',
                ),
              ),
              Expanded(
                child: InfoItem(
                  label: 'عدد المحطات',
                  value: '${areaData.stations?.length ?? 0} محطة',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(
          Icons.location_on,
          color: AppColors.primary,
          size: 24,
        ),
        SizedBox(width: 8),
        Text(
          'معلومات المنطقة',
          style: AppTextStyles.h2,
        ),
      ],
    );
  }
}
class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
