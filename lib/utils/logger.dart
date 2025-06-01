import 'dart:developer' as developer;

// Define LogLevel enum
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal, // For critical errors
}

// Updated log function
void log(
  String message, {
  String name = '',
  LogLevel level = LogLevel.info, // Default level
  Object? error,
  StackTrace? stackTrace,
}) {
  // Simple mapping to developer.log levels (adjust as needed)
  // developer.log uses int levels: fine=500, info=800, warning=900, severe=1000
  int developerLogLevel = 800; // Default to info
  switch (level) {
    case LogLevel.debug:
      developerLogLevel = 500; // fine
      break;
    case LogLevel.info:
      developerLogLevel = 800; // info
      break;
    case LogLevel.warning:
      developerLogLevel = 900; // warning
      break;
    case LogLevel.error:
    case LogLevel.fatal:
      developerLogLevel = 1000; // severe
      break;
  }
  
  developer.log(
    message,
    name: name,
    level: developerLogLevel,
    error: error,
    stackTrace: stackTrace,
  );
}
