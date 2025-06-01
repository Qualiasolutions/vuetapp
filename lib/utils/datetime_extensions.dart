import 'package:intl/intl.dart';

/// Extension methods for DateTime class
extension DateTimeExtensions on DateTime {
  /// Format a DateTime as a short date string (MM/dd/yyyy)
  String toShortDateString() {
    return DateFormat('MM/dd/yyyy').format(this);
  }

  /// Format a DateTime as a short time string (h:mm a)
  String toShortTimeString() {
    return DateFormat('h:mm a').format(this);
  }
}
