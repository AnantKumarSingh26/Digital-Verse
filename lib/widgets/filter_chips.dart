

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:tvshows/utils/enums.dart';
import 'package:tvshows/providers/home_provider.dart'; 

class FilterChips extends StatelessWidget { 
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: FilterCategory.values.map((category) {
              final isSelected = category == homeProvider.selectedCategory;
              final label = category.name.toUpperCase();
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(label),
                  selected: isSelected, 
                  selectedColor: Theme.of(context).colorScheme.primaryContainer, 
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5), 
                  
                  onSelected: (bool selected) {
                    if (selected) {
                      
                      homeProvider.fetchShows(category);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}