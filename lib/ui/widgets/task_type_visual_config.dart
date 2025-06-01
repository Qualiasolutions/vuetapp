import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_type_enums.dart';

/// Visual configuration for task types including colors, icons, and display properties
class TaskTypeVisualConfig {
  final Color primaryColor;
  final Color backgroundColor;
  final IconData icon;
  final String displayName;
  final String shortName;

  const TaskTypeVisualConfig({
    required this.primaryColor,
    required this.backgroundColor,
    required this.icon,
    required this.displayName,
    required this.shortName,
  });

  /// Get visual configuration for a task type
  static TaskTypeVisualConfig getConfig(TaskType taskType) {
    switch (taskType) {
      case TaskType.task:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF0D9488), // Teal
          backgroundColor: Color(0xFFE6FFFA), // Light teal
          icon: Icons.task_alt,
          displayName: 'Task',
          shortName: 'T',
        );
      case TaskType.appointment:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF2196F3), // Blue
          backgroundColor: Color(0xFFE3F2FD), // Light blue
          icon: Icons.event,
          displayName: 'Appointment',
          shortName: 'A',
        );
      case TaskType.deadline:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFFFF9800), // Orange
          backgroundColor: Color(0xFFFFF3E0), // Light orange
          icon: Icons.schedule,
          displayName: 'Due Date',
          shortName: 'D',
        );
      case TaskType.activity:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF9C27B0), // Purple
          backgroundColor: Color(0xFFF3E5F5), // Light purple
          icon: Icons.celebration,
          displayName: 'Going Out',
          shortName: 'G',
        );
      case TaskType.transport:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF4CAF50), // Green
          backgroundColor: Color(0xFFE8F5E8), // Light green
          icon: Icons.directions_car,
          displayName: 'Getting There',
          shortName: 'Tr',
        );
      case TaskType.accommodation:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF3F51B5), // Indigo
          backgroundColor: Color(0xFFE8EAF6), // Light indigo
          icon: Icons.hotel,
          displayName: 'Staying Overnight',
          shortName: 'S',
        );
      case TaskType.anniversary:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFFE91E63), // Pink
          backgroundColor: Color(0xFFFCE4EC), // Light pink
          icon: Icons.cake,
          displayName: 'Birthday / Anniversary',
          shortName: 'B',
        );
      case TaskType.payment:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF607D8B), // Blue Grey
          backgroundColor: Color(0xFFECEFF1), // Light Blue Grey
          icon: Icons.payment,
          displayName: 'Payment',
          shortName: 'P',
        );
      case TaskType.shopping:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFFFFC107), // Amber
          backgroundColor: Color(0xFFFFECB3), // Light Amber
          icon: Icons.shopping_cart,
          displayName: 'Shopping',
          shortName: 'Sh',
        );
      case TaskType.health:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFFF44336), // Red
          backgroundColor: Color(0xFFFFEBEE), // Light Red
          icon: Icons.health_and_safety,
          displayName: 'Health',
          shortName: 'H',
        );
      case TaskType.education:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF795548), // Brown
          backgroundColor: Color(0xFFEFEBE9), // Light Brown
          icon: Icons.school,
          displayName: 'Education',
          shortName: 'Ed',
        );
      case TaskType.work:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF673AB7), // Deep Purple
          backgroundColor: Color(0xFFEDE7F6), // Light Deep Purple
          icon: Icons.work,
          displayName: 'Work',
          shortName: 'Wk',
        );
      case TaskType.family:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFFCDDC39), // Lime
          backgroundColor: Color(0xFFF9FBE7), // Light Lime
          icon: Icons.family_restroom,
          displayName: 'Family',
          shortName: 'F',
        );
      case TaskType.personal:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF00BCD4), // Cyan
          backgroundColor: Color(0xFFE0F7FA), // Light Cyan
          icon: Icons.person,
          displayName: 'Personal',
          shortName: 'P',
        );
      case TaskType.other:
        return const TaskTypeVisualConfig(
          primaryColor: Color(0xFF757575), // Grey
          backgroundColor: Color(0xFFF5F5F5), // Light grey
          icon: Icons.category,
          displayName: 'Other',
          shortName: 'O',
        );
    }
  }

  /// Get a default configuration for unknown task types
  static const TaskTypeVisualConfig defaultConfig = TaskTypeVisualConfig(
    primaryColor: Color(0xFF757575), // Grey
    backgroundColor: Color(0xFFF5F5F5), // Light grey
    icon: Icons.help_outline,
    displayName: 'Unknown',
    shortName: 'U',
  );

  /// Get all available task type configurations
  static List<TaskTypeVisualConfig> getAllConfigs() {
    return TaskType.values.map((type) => getConfig(type)).toList();
  }

  /// Get icon for transport subtype
  static IconData getTransportIcon(TransportSubtype subtype) {
    switch (subtype) {
      case TransportSubtype.flying:
        return Icons.flight;
      case TransportSubtype.publicTransport:
        return Icons.train;
      case TransportSubtype.rideshare:
        return Icons.car_rental;
      case TransportSubtype.taxi:
        return Icons.local_taxi;
      case TransportSubtype.driving:
        return Icons.directions_car;
      case TransportSubtype.walking:
        return Icons.directions_walk;
      case TransportSubtype.cycling:
        return Icons.directions_bike;
      case TransportSubtype.boating:
        return Icons.directions_boat;
      case TransportSubtype.other:
        return Icons.alt_route;
    }
  }

  /// Get icon for activity subtype
  static IconData getActivityIcon(ActivitySubtype subtype) {
    switch (subtype) {
      case ActivitySubtype.sports:
        return Icons.sports_basketball;
      case ActivitySubtype.entertainment:
        return Icons.movie;
      case ActivitySubtype.social:
        return Icons.people;
      case ActivitySubtype.dining:
        return Icons.restaurant;
      case ActivitySubtype.shopping:
        return Icons.shopping_bag;
      case ActivitySubtype.outdoor:
        return Icons.landscape;
      case ActivitySubtype.cultural:
        return Icons.museum;
      case ActivitySubtype.relaxation:
        return Icons.spa;
      case ActivitySubtype.other:
        return Icons.local_activity;
    }
  }

  /// Get icon for accommodation subtype
  static IconData getAccommodationIcon(AccommodationSubtype subtype) {
    switch (subtype) {
      case AccommodationSubtype.hotel:
        return Icons.hotel;
      case AccommodationSubtype.friendFamily:
        return Icons.home;
      case AccommodationSubtype.airbnb:
        return Icons.house;
      case AccommodationSubtype.hostel:
        return Icons.bed;
      case AccommodationSubtype.resort:
        return Icons.beach_access;
      case AccommodationSubtype.camping:
        return Icons.cabin;
      case AccommodationSubtype.vacationRental:
        return Icons.holiday_village;
      case AccommodationSubtype.business:
        return Icons.business_center;
      case AccommodationSubtype.other:
        return Icons.apartment;
    }
  }

  /// Get icon for anniversary subtype
  static IconData getAnniversaryIcon(AnniversarySubtype subtype) {
    switch (subtype) {
      case AnniversarySubtype.birthday:
        return Icons.cake;
      case AnniversarySubtype.wedding:
        return Icons.favorite;
      case AnniversarySubtype.relationship:
        return Icons.volunteer_activism;
      case AnniversarySubtype.work:
        return Icons.work;
      case AnniversarySubtype.graduation:
        return Icons.school;
      case AnniversarySubtype.memorial:
        return Icons.sentiment_very_satisfied;
      case AnniversarySubtype.holiday:
        return Icons.celebration;
      case AnniversarySubtype.other:
        return Icons.event_note;
    }
  }

  /// Get appropriate icon for task type with subtype consideration
  static IconData getTaskIcon(TaskType? taskType, String? taskSubtype) {
    if (taskType == null) return defaultConfig.icon;

    // Handle subtypes
    if (taskSubtype != null) {
      switch (taskType) {
        case TaskType.transport:
          try {
            final subtype = TransportSubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return getTransportIcon(subtype);
          } catch (e) {
            // Fallback to main type icon if subtype parsing fails
            break;
          }
        case TaskType.activity:
          try {
            final subtype = ActivitySubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return getActivityIcon(subtype);
          } catch (e) {
            break;
          }
        case TaskType.accommodation:
          try {
            final subtype = AccommodationSubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return getAccommodationIcon(subtype);
          } catch (e) {
            break;
          }
        case TaskType.anniversary:
          try {
            final subtype = AnniversarySubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return getAnniversaryIcon(subtype);
          } catch (e) {
            break;
          }
        default:
          break;
      }
    }

    // Return main type icon
    return getConfig(taskType).icon;
  }

  /// Get display name with subtype consideration
  static String getDisplayName(TaskType? taskType, String? taskSubtype) {
    if (taskType == null) return defaultConfig.displayName;

    final config = getConfig(taskType);
    
    // For types with meaningful subtypes, show subtype name
    if (taskSubtype != null) {
      switch (taskType) {
        case TaskType.transport:
          try {
            final subtype = TransportSubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return subtype.displayName;
          } catch (e) {
            break;
          }
        case TaskType.activity:
          try {
            final subtype = ActivitySubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return subtype.displayName;
          } catch (e) {
            break;
          }
        case TaskType.accommodation:
          try {
            final subtype = AccommodationSubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return subtype.displayName;
          } catch (e) {
            break;
          }
        case TaskType.anniversary:
          try {
            final subtype = AnniversarySubtype.values.firstWhere(
              (e) => e.toString().split('.').last == taskSubtype,
            );
            return subtype.displayName;
          } catch (e) {
            break;
          }
        default:
          break;
      }
    }

    return config.displayName;
  }

  /// Create a task type indicator widget
  static Widget buildTaskTypeIndicator({
    required TaskType? taskType,
    String? taskSubtype,
    double size = 24.0,
    bool showBackground = true,
    bool showShortName = false,
  }) {
    final config = taskType != null ? getConfig(taskType) : defaultConfig;
    final icon = getTaskIcon(taskType, taskSubtype);
    
    if (showShortName) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: showBackground ? config.backgroundColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: config.primaryColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            config.shortName,
            style: TextStyle(
              color: config.primaryColor,
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: showBackground ? config.backgroundColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: config.primaryColor,
        size: size * 0.6,
      ),
    );
  }

  /// Create a task type chip widget
  static Widget buildTaskTypeChip({
    required TaskType? taskType,
    String? taskSubtype,
    bool compact = false,
  }) {
    final config = taskType != null ? getConfig(taskType) : defaultConfig;
    final displayName = getDisplayName(taskType, taskSubtype);
    final icon = getTaskIcon(taskType, taskSubtype);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.0 : 8.0,
        vertical: compact ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.primaryColor.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: config.primaryColor,
            size: compact ? 14.0 : 16.0,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              displayName,
              style: TextStyle(
                color: config.primaryColor,
                fontSize: compact ? 10.0 : 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
