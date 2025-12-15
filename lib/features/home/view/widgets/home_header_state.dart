import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/home/controller/home.dart';

/// Header Statistics Display
/// 
/// Shows animated cards with key metrics like cost, water, power, and chemicals
class HomeHeaderStats extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderStats({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'إجمالي التكلفة',
                value: '${_formatNumber(controller.animatedMoney.value ?? 0)} جنيه',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'كمية المياة المنتجة',
                value: '${_formatNumber(controller.animatedWater.value ?? 0)} م³',
                icon: Icons.opacity,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'كمية المياة المرفوعه',
                value: '${_formatNumber(controller.saintion.value ?? 0)} م³',
                icon: Icons.opacity,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'الكهرباء المستهلكة',
                value: '${_formatNumber(controller.animatedPower.value ?? 0)} واط',
                icon: Icons.electrical_services,
                color: Colors.amber,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'كمية الكلور',
                value: '${_formatNumber(controller.animatedChlorine.value ?? 0)} كجم',
                icon: Icons.science,
                color: Colors.cyan,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'كمية الشبة السائلة',
                value: '${_formatNumber(controller.animatedLiquidAlum.value ?? 0)} كجم',
                icon: Icons.water_drop_outlined,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _StatCard(
                title: 'كمية الشبة الصلبة',
                value: '${_formatNumber(controller.animatedSolidAlum.value ?? 0)} كجم',
                icon: Icons.ac_unit,
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num value) {
    return NumberFormat('#,###').format(value);
  }
}

/// Individual Stat Card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}