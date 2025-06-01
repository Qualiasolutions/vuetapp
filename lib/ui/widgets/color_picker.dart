import 'package:flutter/material.dart';

/// A widget for selecting colors from a predefined palette
class ColorPicker extends StatelessWidget {
  /// Currently selected color (as a hex string)
  final String selectedColor;
  
  /// Callback when a new color is selected
  final Function(String) onColorSelected;
  
  /// Predefined color palette
  static const List<String> _colorPalette = [
    '#F44336', // Red
    '#E91E63', // Pink
    '#9C27B0', // Purple
    '#673AB7', // Deep Purple
    '#3F51B5', // Indigo
    '#2196F3', // Blue
    '#03A9F4', // Light Blue
    '#00BCD4', // Cyan
    '#009688', // Teal
    '#4CAF50', // Green
    '#8BC34A', // Light Green
    '#CDDC39', // Lime
    '#FFEB3B', // Yellow
    '#FFC107', // Amber
    '#FF9800', // Orange
    '#FF5722', // Deep Orange
    '#795548', // Brown
    '#9E9E9E', // Grey
  ];
  
  /// Constructor
  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _colorPalette.map((hexColor) {
        final color = _getColorFromHex(hexColor);
        final isSelected = hexColor.toUpperCase() == selectedColor.toUpperCase();
        
        return GestureDetector(
          onTap: () => onColorSelected(hexColor),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
  
  /// Converts a hex color string to a Color object
  Color _getColorFromHex(String hexColor) {
    if (hexColor.startsWith('#')) {
      return Color(int.parse('FF${hexColor.substring(1)}', radix: 16));
    }
    return Colors.grey;
  }
}
