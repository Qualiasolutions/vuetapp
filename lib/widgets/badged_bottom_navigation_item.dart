import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuet_app/services/notification_service.dart';
import 'package:vuet_app/widgets/notification_badge.dart';

/// A bottom navigation bar item with a notification badge
class BadgedBottomNavigationItem extends BottomNavigationBarItem {
  /// Create a badged bottom navigation bar item
  BadgedBottomNavigationItem({
    required BuildContext context,
    required IconData icon,
    IconData? activeIcon,
    super.label,
    String? notificationCategory,
    Color? badgeColor,
  }) : super(
          icon: _BadgedIcon(
            icon: icon,
            notificationCategory: notificationCategory,
            color: Theme.of(context).unselectedWidgetColor,
            badgeColor: badgeColor,
          ),
          activeIcon: _BadgedIcon(
            icon: activeIcon ?? icon,
            notificationCategory: notificationCategory,
            color: Theme.of(context).colorScheme.primary,
            badgeColor: badgeColor,
          ),
        );
}

/// A private widget that shows an icon with a notification badge
class _BadgedIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// The notification category to filter by, or null for all
  final String? notificationCategory;

  /// The icon color
  final Color? color;

  /// The badge color
  final Color? badgeColor;

  /// Constructor
  const _BadgedIcon({
    required this.icon,
    this.notificationCategory,
    this.color,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: color,
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Consumer<NotificationService>(
            builder: (context, notificationService, _) {
              // Get unread notification count for the specified category (if any)
              final int unreadCount = notificationCategory != null
                  ? notificationService
                      .getNotificationsByCategory(notificationCategory!)
                      .where((n) => !n.isRead)
                      .length
                  : notificationService.unreadCount;

              // Only show badge if there are unread notifications
              if (unreadCount <= 0) {
                return const SizedBox.shrink();
              }

              return NotificationBadge(
                size: BadgeSize.small,
                showCount: unreadCount > 1,
                color: badgeColor,
              );
            },
          ),
        ),
      ],
    );
  }
}
