import 'package:flutter/material.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// A notification badge widget for bottom navigation tabs or other navigation elements
class TabNotificationBadge extends StatelessWidget {
  /// The number of unread items to display
  final int count;
  
  /// Whether to display the badge even if count is 0
  final bool showZero;
  
  /// The size of the badge
  final double size;
  
  /// The color of the badge background
  final Color? color;
  
  /// The color of the text
  final Color? textColor;

  /// Constructor
  const TabNotificationBadge({
    super.key,
    required this.count,
    this.showZero = false,
    this.size = 14.0,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0 && !showZero) {
      return const SizedBox.shrink(); // Don't show anything if count is 0
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? AppTheme.notificationUnreadColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: count > 99
            ? Container() // If count > 99, just show the dot without number
            : Text(
                count.toString(),
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: size * 0.65,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
