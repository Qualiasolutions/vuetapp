import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuet_app/models/notification_model.dart';
import 'package:vuet_app/services/notification_service.dart';
import 'package:vuet_app/widgets/badged_bottom_navigation_item.dart';

/// A bottom navigation bar with notification badges
class NavigationWithBadges extends StatelessWidget {
  /// Current selected index
  final int currentIndex;
  
  /// Callback when index changes
  final Function(int) onIndexChanged;
  
  /// Constructor
  const NavigationWithBadges({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
          type: BottomNavigationBarType.fixed,
          items: [
            // Home tab
            BadgedBottomNavigationItem(
              context: context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
            ),
            
            // Tasks tab with task-related notification badge
            BadgedBottomNavigationItem(
              context: context,
              icon: Icons.check_circle_outline,
              activeIcon: Icons.check_circle,
              label: 'Tasks',
              notificationCategory: NotificationModel.categoryTask,
            ),
            
            // Calendar tab with reminder notification badge
            BadgedBottomNavigationItem(
              context: context,
              icon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_today,
              label: 'Calendar',
              notificationCategory: NotificationModel.categoryReminder,
            ),
            
            // Notifications tab with total unread count
            BadgedBottomNavigationItem(
              context: context,
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Notifications',
              // No category filter - shows all notifications
            ),
            
            // Profile tab
            BadgedBottomNavigationItem(
              context: context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}

/// Example page demonstrating how to use the notification badges in app bar and list
class NotificationBadgeExamplePage extends StatelessWidget {
  /// Constructor
  const NotificationBadgeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Example'),
        actions: [
          // Notification icon with badge in app bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<NotificationService>(
              builder: (context, notificationService, _) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Navigate to notifications page
                      },
                    ),
                    if (notificationService.unreadCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${notificationService.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Implementation Examples', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Examples of how to use notification badges throughout the app'),
          ),
          
          // Example list tile with badge
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('My Tasks'),
            subtitle: const Text('View and manage your tasks'),
            trailing: Consumer<NotificationService>(
              builder: (context, notificationService, _) {
                final taskNotifications = notificationService
                    .getNotificationsByCategory(NotificationModel.categoryTask)
                    .where((n) => !n.isRead)
                    .length;
                    
                if (taskNotifications <= 0) {
                  return const Icon(Icons.chevron_right);
                }
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$taskNotifications new',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            onTap: () {
              // Navigate to tasks screen
            },
          ),
          
          // Example list tile with reminder badge
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Upcoming Reminders'),
            subtitle: const Text('View your scheduled reminders'),
            trailing: Consumer<NotificationService>(
              builder: (context, notificationService, _) {
                final reminderNotifications = notificationService
                    .getNotificationsByCategory(NotificationModel.categoryReminder)
                    .where((n) => !n.isRead)
                    .length;
                    
                if (reminderNotifications <= 0) {
                  return const Icon(Icons.chevron_right);
                }
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$reminderNotifications due soon',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            onTap: () {
              // Navigate to reminders screen
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationWithBadges(
        currentIndex: 3, // Notifications tab
        onIndexChanged: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
