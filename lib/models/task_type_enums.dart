

// Enums for task types and subtypes
// These enums match exactly the 7 types from the old React app

/// Main task type enum - matches exactly the 7 types from the old React app
enum TaskType {
  /// Regular task (can be fixed or flexible, dynamic when flexible)
  task,
  
  /// Appointment (meeting, doctor, etc.) - static/fixed
  appointment,
  
  /// Due date (deadline, submission, etc.) - static/fixed
  dueDate,
  
  /// Activity (going out, entertainment, etc.) - static/fixed
  activity,
  
  /// Transport (getting there - flight, train, etc.) - static/fixed
  transport,
  
  /// Accommodation (staying overnight - hotel, etc.) - static/fixed
  accommodation,
  
  /// Anniversary (birthday, anniversary, etc.) - static/fixed
  anniversary,
}

/// Extension on TaskType to provide a displayName getter
extension TaskTypeExtension on TaskType {
  /// Get a user-friendly display name for the task type
  String get displayName {
    switch (this) {
      case TaskType.task:
        return 'Task';
      case TaskType.appointment:
        return 'Appointment';
      case TaskType.dueDate:
        return 'Due Date';
      case TaskType.activity:
        return 'Going Out';
      case TaskType.transport:
        return 'Getting There';
      case TaskType.accommodation:
        return 'Staying Overnight';
      case TaskType.anniversary:
        return 'Birthday / Anniversary';
    }
  }
}

/// Transport subtypes for transport tasks (from old React app)
enum TransportSubtype {
  /// Flight
  flight,
  
  /// Train or public transport
  train,
  
  /// Rental car
  rentalCar,
  
  /// Taxi
  taxi,
  
  /// Drive time
  driveTime,
}

/// Activity subtypes for activity tasks (from old React app)
enum ActivitySubtype {
  /// General activity
  activity,
  
  /// Food activity
  foodActivity,
  
  /// Other activity
  otherActivity,
}

/// Accommodation subtypes for accommodation tasks (from old React app)
enum AccommodationSubtype {
  /// Hotel
  hotel,
  
  /// Stay with friend
  stayWithFriend,
}

/// Anniversary subtypes for anniversary tasks (from old React app)
enum AnniversarySubtype {
  /// Birthday
  birthday,
  
  /// Anniversary
  anniversary,
}

/// Priority levels for tasks
enum TaskPriority {
  /// Low priority
  low,
  
  /// Medium priority
  medium,
  
  /// High priority
  high,
}

/// Status options for tasks
enum TaskStatus {
  /// Pending (not started)
  pending,
  
  /// In progress
  inProgress,
  
  /// Completed
  completed,
  
  /// Cancelled
  cancelled,
  
  /// Delayed
  delayed,
}

/// Extension on TransportSubtype to provide a displayName getter
extension TransportSubtypeExtension on TransportSubtype {
  /// Get a user-friendly display name for the transport subtype
  String get displayName {
    switch (this) {
      case TransportSubtype.flight:
        return 'Flight';
      case TransportSubtype.train:
        return 'Train / Public Transport';
      case TransportSubtype.rentalCar:
        return 'Rental Car';
      case TransportSubtype.taxi:
        return 'Taxi';
      case TransportSubtype.driveTime:
        return 'Drive Time';
    }
  }
}

/// Extension on ActivitySubtype to provide a displayName getter
extension ActivitySubtypeExtension on ActivitySubtype {
  /// Get a user-friendly display name for the activity subtype
  String get displayName {
    switch (this) {
      case ActivitySubtype.activity:
        return 'Activity';
      case ActivitySubtype.foodActivity:
        return 'Food';
      case ActivitySubtype.otherActivity:
        return 'Other';
    }
  }
}

/// Extension on AccommodationSubtype to provide a displayName getter
extension AccommodationSubtypeExtension on AccommodationSubtype {
  /// Get a user-friendly display name for the accommodation subtype
  String get displayName {
    switch (this) {
      case AccommodationSubtype.hotel:
        return 'Hotel';
      case AccommodationSubtype.stayWithFriend:
        return 'Stay With Friend';
    }
  }
}

/// Extension on AnniversarySubtype to provide a displayName getter
extension AnniversarySubtypeExtension on AnniversarySubtype {
  /// Get a user-friendly display name for the anniversary subtype
  String get displayName {
    switch (this) {
      case AnniversarySubtype.birthday:
        return 'Birthday';
      case AnniversarySubtype.anniversary:
        return 'Anniversary';
    }
  }
}
