import 'package:flutter/material.dart';
import 'package:vuet_app/widgets/notification_badge.dart';

/// A widget that displays an icon with an optional notification badge
class BadgedIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// The icon size
  final double size;
  
  /// The icon color
  final Color? color;
  
  /// Whether to show the badge
  final bool showBadge;
  
  /// The badge count to display (if null, only a dot is shown)
  final int? badgeCount;
  
  /// The color of the badge
  final Color? badgeColor;
  
  /// The position of the badge
  final BadgePosition badgePosition;
  
  /// Constructor
  const BadgedIcon({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.color,
    this.showBadge = false,
    this.badgeCount,
    this.badgeColor,
    this.badgePosition = BadgePosition.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge || (badgeCount != null && badgeCount! <= 0)) {
      // If no badge should be shown or count is zero, just return the icon
      return Icon(
        icon,
        size: size,
        color: color,
      );
    }

    // Calculate badge position
    final double? positionTop;
    final double? positionRight;
    final double? positionLeft;
    
    switch (badgePosition) {
      case BadgePosition.topRight:
        positionTop = 0;
        positionRight = 0;
        positionLeft = null;
        break;
      case BadgePosition.topLeft:
        positionTop = 0;
        positionRight = null;
        positionLeft = 0;
        break;
      case BadgePosition.bottomRight:
        positionTop = null;
        positionRight = 0;
        positionLeft = null;
        break;
      case BadgePosition.bottomLeft:
        positionTop = null;
        positionRight = null;
        positionLeft = 0;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          size: size,
          color: color,
        ),
        if (showBadge)
          Positioned(
            top: positionTop,
            right: positionRight,
            left: positionLeft,
            bottom: positionTop != null ? null : 0,
            child: NotificationBadge(
              size: BadgeSize.small,
              showCount: badgeCount != null,
              color: badgeColor,
              maxDisplayCount: 99,
            ),
          ),
      ],
    );
  }
}

/// Badge position options
enum BadgePosition {
  /// Top right of the icon
  topRight,
  
  /// Top left of the icon
  topLeft,
  
  /// Bottom right of the icon
  bottomRight,
  
  /// Bottom left of the icon
  bottomLeft,
}
