import 'package:flutter/material.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// A dialog for selecting colors for task categories
class CategoryColorPicker extends StatefulWidget {
  /// Initial color value (hex string with #)
  final String? initialColor;

  /// Callback when a color is selected
  final Function(String) onColorSelected;

  /// Constructor
  const CategoryColorPicker({
    super.key,
    this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<CategoryColorPicker> createState() => _CategoryColorPickerState();
}

class _CategoryColorPickerState extends State<CategoryColorPicker> {
  late String _selectedColor;

  // A predefined set of colors for categories
  final List<String> _predefinedColors = [
    '#f44336', // Red
    '#e91e63', // Pink
    '#9c27b0', // Purple
    '#673ab7', // Deep Purple
    '#3f51b5', // Indigo
    '#2196f3', // Blue
    '#03a9f4', // Light Blue
    '#00bcd4', // Cyan
    '#009688', // Teal
    '#4caf50', // Green
    '#8bc34a', // Light Green
    '#cddc39', // Lime
    '#ffeb3b', // Yellow
    '#ffc107', // Amber
    '#ff9800', // Orange
    '#ff5722', // Deep Orange
    '#795548', // Brown
    '#607d8b', // Blue Grey
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor ?? _predefinedColors[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category Color'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _predefinedColors.length,
          itemBuilder: (context, index) {
            final colorHex = _predefinedColors[index];
            final colorValue = Color(int.parse('FF${colorHex.substring(1)}', radix: 16));
            final isSelected = _selectedColor == colorHex;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorHex;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorValue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onColorSelected(_selectedColor);
            Navigator.pop(context);
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}

/// Shows the color picker dialog and returns the selected color
Future<String?> showCategoryColorPicker({
  required BuildContext context,
  String? initialColor,
}) async {
  String? selectedColor;
  
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CategoryColorPicker(
        initialColor: initialColor,
        onColorSelected: (color) {
          selectedColor = color;
        },
      );
    },
  );
  
  return selectedColor;
}
