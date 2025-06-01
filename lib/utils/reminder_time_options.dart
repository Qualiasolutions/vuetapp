import 'package:flutter/material.dart';

/// Class to manage reminder time options
class ReminderTimeOptions {
  /// 5 minutes before
  static const Duration fiveMinutes = Duration(minutes: 5);
  
  /// 15 minutes before
  static const Duration fifteenMinutes = Duration(minutes: 15);
  
  /// 30 minutes before
  static const Duration thirtyMinutes = Duration(minutes: 30);
  
  /// 1 hour before
  static const Duration oneHour = Duration(hours: 1);
  
  /// 2 hours before
  static const Duration twoHours = Duration(hours: 2);
  
  /// 4 hours before
  static const Duration fourHours = Duration(hours: 4);
  
  /// 12 hours before
  static const Duration twelveHours = Duration(hours: 12);
  
  /// 1 day before
  static const Duration oneDay = Duration(days: 1);
  
  /// 2 days before
  static const Duration twoDays = Duration(days: 2);
  
  /// 1 week before
  static const Duration oneWeek = Duration(days: 7);
  
  /// At the time of the deadline
  static const Duration atDeadline = Duration.zero;
  
  /// List of all available reminder time options
  static List<Duration> get allOptions => [
    fiveMinutes,
    fifteenMinutes,
    thirtyMinutes,
    oneHour,
    twoHours,
    fourHours,
    twelveHours,
    oneDay,
    twoDays,
    oneWeek,
    atDeadline,
  ];
  
  /// Get a human-readable string for a reminder time
  static String getDisplayText(Duration reminderTime) {
    if (reminderTime == fiveMinutes) return '5 minutes before';
    if (reminderTime == fifteenMinutes) return '15 minutes before';
    if (reminderTime == thirtyMinutes) return '30 minutes before';
    if (reminderTime == oneHour) return '1 hour before';
    if (reminderTime == twoHours) return '2 hours before';
    if (reminderTime == fourHours) return '4 hours before';
    if (reminderTime == twelveHours) return '12 hours before';
    if (reminderTime == oneDay) return '1 day before';
    if (reminderTime == twoDays) return '2 days before';
    if (reminderTime == oneWeek) return '1 week before';
    if (reminderTime == atDeadline) return 'At the deadline';
    
    // For custom durations
    if (reminderTime.inDays > 0) {
      return '${reminderTime.inDays} days before';
    } else if (reminderTime.inHours > 0) {
      return '${reminderTime.inHours} hours before';
    } else if (reminderTime.inMinutes > 0) {
      return '${reminderTime.inMinutes} minutes before';
    } else {
      return 'Custom time';
    }
  }
  
  /// Parse a duration from a string (inverse of getDisplayText)
  static Duration parseDuration(String text) {
    if (text == '5 minutes before') return fiveMinutes;
    if (text == '15 minutes before') return fifteenMinutes;
    if (text == '30 minutes before') return thirtyMinutes;
    if (text == '1 hour before') return oneHour;
    if (text == '2 hours before') return twoHours;
    if (text == '4 hours before') return fourHours;
    if (text == '12 hours before') return twelveHours;
    if (text == '1 day before') return oneDay;
    if (text == '2 days before') return twoDays;
    if (text == '1 week before') return oneWeek;
    if (text == 'At the deadline') return atDeadline;
    
    // For custom display texts, try to parse
    if (text.contains('days before')) {
      final days = int.tryParse(text.split(' ')[0]);
      if (days != null) {
        return Duration(days: days);
      }
    } else if (text.contains('hours before')) {
      final hours = int.tryParse(text.split(' ')[0]);
      if (hours != null) {
        return Duration(hours: hours);
      }
    } else if (text.contains('minutes before')) {
      final minutes = int.tryParse(text.split(' ')[0]);
      if (minutes != null) {
        return Duration(minutes: minutes);
      }
    }
    
    // Default to one day if parsing fails
    return oneDay;
  }
  
  /// Get a list of all reminder time options as display strings
  static List<String> get allDisplayOptions => 
      allOptions.map((duration) => getDisplayText(duration)).toList();
      
  /// Convert minutes to a Duration
  static Duration fromMinutes(int minutes) => Duration(minutes: minutes);
  
  /// Convert a Duration to minutes
  static int toMinutes(Duration duration) => duration.inMinutes;
}

/// A widget for selecting a reminder time
class ReminderTimeSelector extends StatefulWidget {
  /// The currently selected reminder time
  final Duration initialValue;
  
  /// Callback for when the reminder time changes
  final ValueChanged<Duration> onChanged;
  
  /// Constructor
  const ReminderTimeSelector({
    super.key,
    this.initialValue = ReminderTimeOptions.oneDay,
    required this.onChanged,
  });

  @override
  State<ReminderTimeSelector> createState() => _ReminderTimeSelectorState();
}

class _ReminderTimeSelectorState extends State<ReminderTimeSelector> {
  late Duration _selectedTime;
  
  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialValue;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reminder Time',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: ReminderTimeOptions.getDisplayText(_selectedTime),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ReminderTimeOptions.allDisplayOptions
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedTime = ReminderTimeOptions.parseDuration(value);
              });
              widget.onChanged(_selectedTime);
            }
          },
        ),
      ],
    );
  }
}
