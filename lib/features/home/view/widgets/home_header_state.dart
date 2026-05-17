import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/home/controller/home.dart';

/// Header Statistics Display
/// 
/// Shows animated cards with key metrics like cost, water, power, and chemicals.
/// Fully responsive grid wrapping smoothly across Mobile, Tablet, and Desktop.
class HomeHeaderStats extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderStats({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        // Calculate dynamic columns based on available viewport width
        int crossAxisCount = 7;
        if (width < 1200) crossAxisCount = 4;
        if (width < 750) crossAxisCount = 2;
        if (width < 450) crossAxisCount = 1;

        // Calculate dynamic height to fit grid children perfectly without overflow
        final double cardHeight = crossAxisCount == 1 ? 95 : 120;
        final int rows = (7 / crossAxisCount).ceil();
        final double totalGridHeight = (rows * cardHeight) + ((rows - 1) * 12);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E40AF), const Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Obx(() {
            // Re-trigger building when controller animated values update
            final moneyVal = controller.animatedMoney.value ?? 0;
            final waterVal = controller.animatedWater.value ?? 0;
            final saintionVal = controller.saintion.value ?? 0;
            final powerVal = controller.animatedPower.value ?? 0;
            final chlorineVal = controller.animatedChlorine.value ?? 0;
            final liquidAlumVal = controller.animatedLiquidAlum.value ?? 0;
            final solidAlumVal = controller.animatedSolidAlum.value ?? 0;

            return SizedBox(
              height: totalGridHeight,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: crossAxisCount == 1 
                    ? (width / cardHeight) 
                    : (width / crossAxisCount) / cardHeight,
                children: [
                  _buildResponsiveCard('إجمالي التكلفة', moneyVal, ' جنيه', Icons.attach_money, const Color(0xFF10B981)),
                  _buildResponsiveCard('كمية المياة المنتجة', waterVal, ' م³', Icons.opacity, const Color(0xFF3B82F6)),
                  _buildResponsiveCard('كمية المياة المرفوعه', saintionVal, ' م³', Icons.opacity, const Color(0xFF60A5FA)),
                  _buildResponsiveCard('الكهرباء المستهلكة', powerVal, ' واط', Icons.electrical_services, const Color(0xFFF59E0B)),
                  _buildResponsiveCard('كمية الكلور', chlorineVal, ' كجم', Icons.science, const Color(0xFF06B6D4)),
                  _buildResponsiveCard('كمية الشبة السائلة', liquidAlumVal, ' كجم', Icons.water_drop_outlined, const Color(0xFFF97316)),
                  _buildResponsiveCard('كمية الشبة الصلبة', solidAlumVal, ' كجم', Icons.ac_unit, const Color(0xFF8B5CF6)),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String _formatNumber(num value) {
    return NumberFormat('#,###').format(value);
  }

  Widget _buildResponsiveCard(
    String title,
    num targetValue,
    String suffix,
    IconData icon,
    Color accentColor,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue.toDouble()),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutExpo,
      builder: (context, val, child) {
        final formatted = _formatNumber(val);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accentColor, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$formatted$suffix',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}