import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';
import 'package:power_saving/features/home/model/home.dart';

/// Consumption Card
/// 
/// Displays individual consumption data in a professional, interactive card format
class ConsumptionCard extends StatefulWidget {
  final OverConsump item;
  final String label;
  final IconData icon;
  final Color color;

  const ConsumptionCard({
    super.key,
    required this.item,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  State<ConsumptionCard> createState() => _ConsumptionCardState();
}

class _ConsumptionCardState extends State<ConsumptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _navigateToAnalysis(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? (Matrix4.identity()..scale(1.025)) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withOpacity(0.4)
                  : AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_isHovered ? 0.12 : 0.04),
                spreadRadius: 0,
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCardHeader(),
              _buildCardBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.08),
            widget.color.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.item.stationName,
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: HomeTypography.consumptionTitle,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'رقم المحطة: ${widget.item.stationId}',
            style: const TextStyle(
              fontSize: HomeTypography.consumptionSub,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DetailItem(
            title: 'التاريخ',
            value: '${widget.item.billMonth} / ${widget.item.billYear}',
            icon: Icons.calendar_today_outlined,
            color: AppColors.primary,
            isHighlight: true,
          ),
          const SizedBox(height: 6),
          _DetailItem(
            title: 'التقنية',
            value: widget.item.technologyName,
            icon: Icons.memory_outlined,
            color: AppColors.teal,
            isHighlight: true,
          ),
          const SizedBox(height: 6),
          _DetailItem(
            title: widget.label,
            value: _getItemValue(),
            icon: widget.icon,
            color: widget.color,
            isHighlight: true,
          ),
          const SizedBox(height: 10),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(_isHovered ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.color.withOpacity(_isHovered ? 0.35 : 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 18, color: widget.color),
          const SizedBox(width: 8),
          Text(
            'عرض التحليل',
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.bold,
              fontSize: HomeTypography.consumptionAction,
            ),
          ),
        ],
      ),
    );
  }

  String _getItemValue() {
    final formatter = NumberFormat('#,###');
    switch (widget.label) {
      case "الكهرباء":
        return "${formatter.format(widget.item.technologyPowerConsump)} واط";
      case "الكلور":
        return "${formatter.format(widget.item.technologyChlorineConsump)} جرام";
      case "الشبة السائلة":
        return "${formatter.format(widget.item.technologyLiquidAlumConsump)} جرام";
      case "الشبة الصلبة":
        return "${formatter.format(widget.item.technologySolidAlumConsump)} جرام";
      case "الإنارة":
        return "${formatter.format(widget.item.technologyPowerConsump)} واط";
      default:
        return "";
    }
  }

  void _navigateToAnalysis() {
    Get.toNamed(
      '/analysis',
      arguments: {
        "data": widget.item,
        'station': widget.item.stationId,
        'tech': widget.item.technologyId,
      },
    );
  }
}

/// Detail Item Widget
class _DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  const _DetailItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight
            ? color.withOpacity(0.06)
            : AppColors.cardBackgroundMuted,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight
            ? Border.all(color: color.withOpacity(0.12), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: HomeTypography.consumptionLabel,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: HomeTypography.consumptionValue,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
