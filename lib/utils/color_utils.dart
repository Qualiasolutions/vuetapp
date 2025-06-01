import 'package:flutter/material.dart';

class ColorUtils {
  /// Convert a hex color string (e.g., "#RRGGBB" or "RRGGBB") to a Color object.
  static Color fromHex(String hexString) {
    final hexCode = hexString.replaceAll('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    } else if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16));
    } else {
      throw FormatException('Invalid hex color string: $hexString');
    }
  }

  /// Convert a Color object to a hex color string (e.g., "#RRGGBB").
  static String toHex(Color color, {bool includeHash = true}) {
    final hex = (color.r * 255.0).round().toRadixString(16).padLeft(2, '0') + 
                (color.g * 255.0).round().toRadixString(16).padLeft(2, '0') + 
                (color.b * 255.0).round().toRadixString(16).padLeft(2, '0'); // Remove alpha channel
    return includeHash ? '#$hex' : hex;
  }
}
