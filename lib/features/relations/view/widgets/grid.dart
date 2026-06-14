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
    
        // Determine the number of columns based on the width
        final int crossAxisCount = (width / 200).floor().clamp(1, 4);
        
        const double spacing = 12.0;
        double itemWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    
        return SliverToBoxAdapter(
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: controller.relations.map((relation) {
              return SizedBox(
                width: itemWidth,
                child: RelationsCard( 
                  relation: relation,
                  controller: controller,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}