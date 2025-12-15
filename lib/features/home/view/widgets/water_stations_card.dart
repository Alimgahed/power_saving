import 'package:flutter/material.dart';
import 'package:power_saving/features/home/model/home.dart';

/// Water Station Card
/// 
/// Displays detailed information about a water station
class WaterStationCard extends StatelessWidget {
  final OverWaterStation item;
  final Color color;

  const WaterStationCard({
    super.key,
    required this.item,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.water_drop,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.stationName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _WaterDetailItem(
            title: 'التاريخ',
            value: '${item.month} / ${item.year}',
            icon: Icons.calendar_today_outlined,
            color: Colors.blue.shade600,
          ),
          const SizedBox(height: 12),
          _WaterDetailItem(
            title: 'الطاقة التصميمية الشهرية',
            value: '${item.capacityLimit} م³ / شهر',
            icon: Icons.speed_outlined,
            color: Colors.orange.shade600,
          ),
          const SizedBox(height: 12),
          _WaterDetailItem(
            title: 'الطاقة التصميمية',
            value: '${item.waterCapacity} م³/ يوم',
            icon: Icons.engineering_outlined,
            color: Colors.teal.shade600,
          ),
          const SizedBox(height: 12),
          _WaterDetailItem(
            title: 'إجمالي المياه',
            value: _formatWaterAmount(item.totalWater),
            icon: Icons.opacity_outlined,
            color: Colors.indigo.shade600,
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatusIndicator(item: item)),
              const SizedBox(width: 12),
              _ActionButton(color: color),
            ],
          ),
        ],
      ),
    );
  }

  String _formatWaterAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)} مليون م³';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)} ألف م³';
    } else {
      return '${amount.toStringAsFixed(2)} م³';
    }
  }
}

/// Water Detail Item Widget
class _WaterDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  const _WaterDetailItem({
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

/// Status Indicator Widget
class _StatusIndicator extends StatelessWidget {
  final OverWaterStation item;

  const _StatusIndicator({required this.item});

  @override
  Widget build(BuildContext context) {
    final capacity = double.tryParse(item.capacityLimit.toString()) ?? 0;
    final isOverCapacity = capacity > 100;
    final statusColor = isOverCapacity
        ? Colors.red
        : capacity > 80
            ? Colors.orange
            : Colors.green;
    final statusText = isOverCapacity
        ? 'تجاوز السعة'
        : capacity > 80
            ? 'قريب من السعة'
            : 'ضمن السعة';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action Button Widget
class _ActionButton extends StatelessWidget {
  final Color color;

  const _ActionButton({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
      child: Icon(
        Icons.analytics_outlined,
        size: 18,
        color: color,
      ),
    );
  }
}