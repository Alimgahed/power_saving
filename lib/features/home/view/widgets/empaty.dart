import 'package:flutter/material.dart';

/// Empty State Widget
/// 
/// Displays when no data is available in a section
class EmptyStateWidget extends StatelessWidget {
  final Color color;
  final String? message;
  final String? description;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.color,
    this.message,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon ?? Icons.inbox_outlined,
              size: 48,
              color: color.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'لا توجد بيانات متاحة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description ?? 'لم يتم العثور على أي بيانات استهلاك مفرط',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}