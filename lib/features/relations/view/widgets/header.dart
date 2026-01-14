import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key, required this.controller});

  final RelationsController controller;

  @override
  Widget build(BuildContext context) {
    // Precompute values
    final linearGradient = LinearGradient(
      colors: [Colors.blue.shade50, Colors.blue.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final borderRadius = BorderRadius.circular(AppDimensions.radiusL);
    final borderColor = Colors.blue.shade100;

    // Get the total number of relations and display a search result if applicable
    final totalRelations = controller.allRelations.length;
    final displayedRelations = controller.relations.length;
    final isSearching = controller.searchController.text.isNotEmpty;

    // Build the text to show
    final relationsText = isSearching
        ? '$displayedRelations من $totalRelations ربط'
        : '$totalRelations ربط';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              Icons.link,
              color: Colors.blue.shade700,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingL),
          // Column directly inside Row without Expanded (no need for flex)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي الروابط',
                style: AppTextStyles.h2, // Using the predefined text style
              ),
              const SizedBox(height: 4),
              Text(
                relationsText,
                style: AppTextStyles.h1, // Using the predefined text style
              ),
            ],
          ),
        ],
      ),
    );
  }
}
