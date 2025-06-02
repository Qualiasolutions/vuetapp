import 'package:flutter/material.dart';

class UiHelpers {
  static IconData getIconFromString(String? iconName) {
    // TODO: Implement actual icon mapping based on iconName.
    // Example: 
    // if (iconName == null) return Icons.help_outline;
    // switch (iconName.toLowerCase()) {
    //   case 'home':
    //     return Icons.home;
    //   case 'pets':
    //     return Icons.pets;
    //   // Add more cases for your specific icon names
    //   default:
    //     return Icons.help_outline;
    // }
    return Icons.help_outline; // Default icon
  }

  static Color getColorFromString(String? colorName) {
    if (colorName == null || colorName.isEmpty) {
      return Colors.grey; // Default color if no name is provided
    }

    // Check if it's a hex color string
    if (colorName.startsWith('#')) {
      try {
        return Color(int.parse(colorName.substring(1), radix: 16) + 0xFF000000);
      } catch (e) {
        print('Error parsing hex color: $colorName. Error: $e');
        return Colors.grey; // Fallback for invalid hex
      }
    } else if (colorName.length == 6 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(colorName)) {
      // Try parsing as hex without #
       try {
        return Color(int.parse(colorName, radix: 16) + 0xFF000000);
      } catch (e) {
        print('Error parsing hex color: $colorName. Error: $e');
        return Colors.grey; // Fallback for invalid hex
      }
    }

    // TODO: Implement mapping for named colors if needed.
    // Example:
    // switch (colorName.toLowerCase()) {
    //   case 'blue':
    //     return Colors.blue;
    //   case 'red':
    //     return Colors.red;
    //   // Add more cases for named colors
    // }
    
    return Colors.grey; // Default color if no specific mapping found
  }
} 