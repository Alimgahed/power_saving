import 'package:flutter/material.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';
import 'package:power_saving/features/relations/view/widgets/relations_card.dart';

class RelationsGrid extends StatelessWidget {
  final RelationsController controller;

  const RelationsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        // Get the width of the available space
        final double width = constraints.crossAxisExtent;
    
        // Define aspect ratio based on width
        final double aspectRatio = width > 600 ? 0.7 : 0.8;
    
        // Determine the number of columns based on the width
        final int crossAxisCount = (width / 200).floor().clamp(1, 4);
    
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Build individual relation cards
              return RelationsCard( 
                relation: controller.relations[index],
                controller: controller,
              );
            },
            childCount: controller.relations.length,
          ),
        );
      },
    );
  }
}