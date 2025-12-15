import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/home/model/home.dart';

/// Consumption Card
/// 
/// Displays individual consumption data in a professional card format
class ConsumptionCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToAnalysis(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
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
    );
  }

  Widget _buildCardHeader() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
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
        children: [
          Text(
            item.stationName,
            maxLines: 3,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'رقم المحطة: ${item.stationId}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DetailItem(
            title: 'التاريخ',
            value: '${item.billMonth} / ${item.billYear}',
            icon: Icons.calendar_today_outlined,
            color: Colors.blue.shade600,
            isHighlight: true,
          ),
          const SizedBox(height: 8),
          _DetailItem(
            title: 'التقنية',
            value: item.technologyName,
            icon: Icons.memory_outlined,
            color: Colors.teal.shade600,
            isHighlight: true,
          ),
          const SizedBox(height: 8),
          _DetailItem(
            title: label,
            value: _getItemValue(),
            icon: icon,
            color: Colors.indigo.shade600,
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            'عرض التحليل',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getItemValue() {
    final formatter = NumberFormat('#,###');
    switch (label) {
      case "الكهرباء":
        return "${formatter.format(item.technologyPowerConsump)} واط";
      case "الكلور":
        return "${formatter.format(item.technologyChlorineConsump)} جرام";
      case "الشبة السائلة":
        return "${formatter.format(item.technologyLiquidAlumConsump)} جرام";
      case "الشبة الصلبة":
        return "${formatter.format(item.technologySolidAlumConsump)} جرام";
      case "الإنارة":
        return "${formatter.format(item.technologyPowerConsump)} واط";
      default:
        return "";
    }
  }

  void _navigateToAnalysis() {
    Get.toNamed(
      '/analysis',
      arguments: {
        'station': item.stationId,
        'tech': item.technologyId,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight ? color.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight
            ? Border.all(color: color.withOpacity(0.2), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? color : Colors.grey.shade800,
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