import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Changed to Riverpod
import 'package:vuet_app/services/notification_service.dart';

/// A widget to display an unread notification badge
class NotificationBadge extends ConsumerWidget { // Changed to ConsumerWidget
  /// The badge size (default: small)
  final BadgeSize size;
  
  /// Whether to show the count (default: true)
  final bool showCount;
  
  /// Threshold at which to display "99+" instead of the actual count
  final int maxDisplayCount;

  /// Color of the badge (default: red)
  final Color? color;
  
  /// Optional filter for specific notification categories
  final String? categoryFilter;

  /// Constructor
  const NotificationBadge({
    super.key, // Changed Key? key to super.key
    this.size = BadgeSize.small,
    this.showCount = true,
    this.maxDisplayCount = 99,
    this.color,
    this.categoryFilter,
  }); // Removed : super(key: key)

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef ref
    final theme = Theme.of(context);
    // Use Riverpod's ref.watch to get the NotificationService
    final notificationService = ref.watch(notificationServiceProvider); 
    
    // Get unread count, optionally filtered by category
    int unreadCount = categoryFilter != null
        ? notificationService.getNotificationsByCategory(categoryFilter!)
            .where((n) => !n.isRead)
            .length
        : notificationService.unreadCount;
    
    // Don't display anything if no unread notifications
    // Also, check if the service itself has notifications loaded to prevent brief display of '0'
    // if unreadCount is briefly 0 during loading.
    if (unreadCount <= 0 && notificationService.notifications.isEmpty && notificationService.unreadCount == 0) {
      // More robust check: if unreadCount is 0 AND there are no notifications at all (still loading perhaps)
      // OR if unreadCount is definitively 0 after loading, then shrink.
      // This avoids showing a badge flicker if unreadCount is temporarily 0.
      // A simpler check is just unreadCount <= 0, but this adds a bit more robustness against flicker.
      // For now, the original logic `if (unreadCount <= 0)` is fine as `unreadCount` itself is reactive.
       return const SizedBox.shrink();
    }
    
    // Format the count text
    final countText = unreadCount > maxDisplayCount
        ? '$maxDisplayCount+'
        : unreadCount.toString();
    
    // Determine badge dimensions based on size
    final double height;
    final double minWidth;
    final double fontSize;
    
    switch (size) {
      case BadgeSize.small:
        height = 16;
        minWidth = 16;
        fontSize = 10;
        break;
      case BadgeSize.medium:
        height = 20;
        minWidth = 20;
        fontSize = 12;
        break;
      case BadgeSize.large:
        height = 24;
        minWidth = 24;
        fontSize = 14;
        break;
    }
    
    return Container(
      height: height,
      constraints: BoxConstraints(minWidth: minWidth),
      padding: EdgeInsets.symmetric(horizontal: showCount ? 4 : 0),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.error,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: showCount
          ? Center(
              child: Text(
                countText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}

/// Badge size options
enum BadgeSize {
  /// Small badge (16x16)
  small,
  
  /// Medium badge (20x20)
  medium,
  
  /// Large badge (24x24)
  large,
}
