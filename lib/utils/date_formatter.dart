import 'package:intl/intl.dart';

/// Utility class for date and time formatting
class DateFormatter {
  /// Format a DateTime to a short date string (e.g., "Jan 15, 2025")
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
  
  /// Format a DateTime to a long date string (e.g., "January 15, 2025")
  static String formatLongDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }
  
  /// Format a DateTime to a short time string (e.g., "3:30 PM")
  static String formatShortTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
  
  /// Format a DateTime to a full date and time string (e.g., "Jan 15, 2025 at 3:30 PM")
  static String formatFullDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }
  
  /// Format a date range from start to end (e.g., "Jan 15 - Jan 20, 2025")
  static String formatDateRange(DateTime start, DateTime end) {
    final isSameYear = start.year == end.year;
    final isSameMonth = start.month == end.month && isSameYear;
    
    if (isSameMonth) {
      // Same month, same year
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('d, y').format(end)}';
    } else if (isSameYear) {
      // Different month, same year
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, y').format(end)}';
    } else {
      // Different years
      return '${DateFormat('MMM d, y').format(start)} - ${DateFormat('MMM d, y').format(end)}';
    }
  }
  
  /// Format a time range from start to end (e.g., "3:30 PM - 5:00 PM")
  static String formatTimeRange(DateTime start, DateTime end) {
    return '${DateFormat('h:mm a').format(start)} - ${DateFormat('h:mm a').format(end)}';
  }
  
  /// Format a duration in minutes to a human-readable string (e.g., "2h 30m")
  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '${hours}h${remainingMinutes > 0 ? ' ${remainingMinutes}m' : ''}';
    } else {
      return '${remainingMinutes}m';
    }
  }
  
  /// Format a day of week (1-7) to its name (e.g., 1 -> "Monday")
  static String dayOfWeekToString(int dayOfWeek) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    
    // Make sure dayOfWeek is between 1-7 (ISO 8601: 1 = Monday, 7 = Sunday)
    final index = ((dayOfWeek - 1) % 7);
    return days[index];
  }
  
  /// Format a day of week (1-7) to its short name (e.g., 1 -> "Mon")
  static String dayOfWeekToShortString(int dayOfWeek) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    // Make sure dayOfWeek is between 1-7 (ISO 8601: 1 = Monday, 7 = Sunday)
    final index = ((dayOfWeek - 1) % 7);
    return days[index];
  }
  
  /// Format a DateTime to a datetime string (legacy compatibility)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }
  
  /// Format a DateTime to a date string (legacy compatibility)
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
  
  /// Get a human-readable relative date (e.g., "2 days ago")
  static String getRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
