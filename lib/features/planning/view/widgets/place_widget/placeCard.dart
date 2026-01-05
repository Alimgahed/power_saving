import 'package:flutter/material.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/main_screen/main_card_widgets.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(name: place.placeName),
          _buildContent(),
          ReusableFooter(
            station: place, // Pass your station object here
            buttonLabel: 'تعديل', // Button text
            textLabel: 'تعديل المكان', // Text before the button
            routeName: '/editPlaces', // Route to navigate to
            icon: Icons.edit, // Icon for the button
            arguments: {'place': place}, // Custom arguments
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: InfoCard(
                  label: 'نوع المكان',
                  value: place.placeTypeName ?? "",
                  icon: Icons.place,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: InfoCard(
                  label: 'الفرع',
                  value: place.branchName ?? 'غير محدد',
                  icon: Icons.business,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  label: 'الموقع',
                  value: place.areaName ?? 'غير محدد',
                  icon: Icons.location_on,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'التعداد السكاني',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var population in place.populations ?? []) ...[
                Expanded(
                  child: InfoCard(
                    label: '${population.populationYear}',
                    value: population.population.toString(),
                    icon: Icons.location_on,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
