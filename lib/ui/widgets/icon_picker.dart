import 'package:flutter/material.dart';

/// A widget for selecting icons from a predefined set
class IconPicker extends StatelessWidget {
  /// Currently selected icon code (as a string)
  final String? selectedIcon;
  
  /// Callback when a new icon is selected
  final Function(String?) onIconSelected;
  
  /// Predefined set of material icons to choose from
  /// Using hardcoded values to satisfy const requirement
  static const List<int> _iconSet = [
    0xe318, // home
    0xe8f9, // work
    0xe56b, // school
    0xe8cc, // shopping_cart
    0xe25b, // favorite
    0xe548, // local_hospital
    0xe1d7, // directions_car
    0xe284, // fitness_center
    0xe56c, // restaurant
    0xe545, // local_grocery_store
    0xe40a, // movie
    0xe3a1, // music_note
    0xe0db, // book
    0xe0b6, // beach_access
    0xe28e, // flight
    0xe65a, // sports_basketball
    0xe31e, // laptop
    0xe4b2, // pets
    0xe09d, // attach_money
    0xe28b, // family_restroom
    0xe60b, // star
    0xe561, // schedule
  ];
  
  /// Constructor
  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _iconSet.map((iconCode) {
            final isSelected = selectedIcon == iconCode.toString();
            final color = Theme.of(context).primaryColor;
            
            return GestureDetector(
              onTap: () => onIconSelected(iconCode.toString()),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getIconData(iconCode),
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
        
        // Option to clear icon selection
        if (selectedIcon != null) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => onIconSelected(null),
            icon: const Icon(Icons.clear),
            label: const Text('Clear icon selection'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ],
    );
  }

  /// Get IconData from icon code in a tree-shake friendly way
  IconData _getIconData(int iconCode) {
    // Use a predefined set of common icons for better tree shaking
    switch (iconCode) {
      case 0xe318: return Icons.home;
      case 0xe8f9: return Icons.work;
      case 0xe56b: return Icons.school;
      case 0xe8cc: return Icons.shopping_cart;
      case 0xe25b: return Icons.favorite;
      case 0xe548: return Icons.local_hospital;
      case 0xe1d7: return Icons.directions_car;
      case 0xe284: return Icons.fitness_center;
      case 0xe56c: return Icons.restaurant;
      case 0xe545: return Icons.local_grocery_store;
      case 0xe40a: return Icons.movie;
      case 0xe3a1: return Icons.music_note;
      case 0xe0db: return Icons.book;
      case 0xe0b6: return Icons.beach_access;
      case 0xe28e: return Icons.flight;
      case 0xe65a: return Icons.sports_basketball;
      case 0xe31e: return Icons.laptop;
      case 0xe4b2: return Icons.pets;
      case 0xe09d: return Icons.attach_money;
      case 0xe28b: return Icons.family_restroom;
      case 0xe60b: return Icons.star;
      case 0xe561: return Icons.schedule;
      default:
        // Fallback to a safe default icon
        return Icons.category;
    }
  }
}
