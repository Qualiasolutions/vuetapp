// Enums for task types and subtypes
// These enums are used to categorize tasks in the application

/// Main task type enum
enum TaskType {
  /// Regular task
  task,
  
  /// Appointment (meeting, doctor, etc.)
  appointment,
  
  /// Activity (sports, entertainment, etc.)
  activity,
  
  /// Transport (flight, train, etc.)
  transport,
  
  /// Accommodation (hotel, airbnb, etc.)
  accommodation,
  
  /// Anniversary (birthday, wedding, etc.)
  anniversary,
  
  /// Deadline (project, submission, etc.)
  deadline,
  
  /// Payment (bill, subscription, etc.)
  payment,
  
  /// Shopping (groceries, clothes, etc.)
  shopping,
  
  /// Health (medication, checkup, etc.)
  health,
  
  /// Education (class, homework, etc.)
  education,
  
  /// Work (meeting, project, etc.)
  work,
  
  /// Family (pickup, dropoff, etc.)
  family,
  
  /// Personal (hobby, self-care, etc.)
  personal,
  
  /// Other (miscellaneous tasks)
  other,
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
      case TaskType.activity:
        return 'Activity';
      case TaskType.transport:
        return 'Transport';
      case TaskType.accommodation:
        return 'Accommodation';
      case TaskType.anniversary:
        return 'Anniversary';
      case TaskType.deadline:
        return 'Deadline';
      case TaskType.payment:
        return 'Payment';
      case TaskType.shopping:
        return 'Shopping';
      case TaskType.health:
        return 'Health';
      case TaskType.education:
        return 'Education';
      case TaskType.work:
        return 'Work';
      case TaskType.family:
        return 'Family';
      case TaskType.personal:
        return 'Personal';
      case TaskType.other:
        return 'Other';
    }
  }
}

/// Transport subtypes for transport tasks
enum TransportSubtype {
  /// Driving (car, motorcycle, etc.)
  driving,
  
  /// Public transport (bus, train, subway, etc.)
  publicTransport,
  
  /// Walking
  walking,
  
  /// Cycling
  cycling,
  
  /// Flying (airplane, helicopter, etc.)
  flying,
  
  /// Boating (ferry, cruise, etc.)
  boating,
  
  /// Rideshare (Uber, Lyft, etc.)
  rideshare,
  
  /// Taxi
  taxi,
  
  /// Other transport
  other,
}

/// Activity subtypes for activity tasks
enum ActivitySubtype {
  /// Sports (playing, watching, etc.)
  sports,
  
  /// Entertainment (movie, concert, etc.)
  entertainment,
  
  /// Social (party, gathering, etc.)
  social,
  
  /// Dining (restaurant, cafe, etc.)
  dining,
  
  /// Shopping (mall, store, etc.)
  shopping,
  
  /// Outdoor (hiking, picnic, etc.)
  outdoor,
  
  /// Cultural (museum, theater, etc.)
  cultural,
  
  /// Relaxation (spa, massage, etc.)
  relaxation,
  
  /// Other activity
  other,
}

/// Accommodation subtypes for accommodation tasks
enum AccommodationSubtype {
  /// Hotel
  hotel,
  
  /// Airbnb or similar rental
  airbnb,
  
  /// Hostel
  hostel,
  
  /// Resort
  resort,
  
  /// Camping
  camping,
  
  /// Friend/Family home
  friendFamily,
  
  /// Vacation rental
  vacationRental,
  
  /// Business lodging
  business,
  
  /// Other accommodation
  other,
}

/// Anniversary subtypes for anniversary tasks
enum AnniversarySubtype {
  /// Birthday
  birthday,
  
  /// Wedding anniversary
  wedding,
  
  /// Relationship anniversary
  relationship,
  
  /// Work anniversary
  work,
  
  /// Graduation anniversary
  graduation,
  
  /// Memorial
  memorial,
  
  /// Holiday
  holiday,
  
  /// Other anniversary
  other,
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
      case TransportSubtype.driving:
        return 'Driving';
      case TransportSubtype.publicTransport:
        return 'Public Transport';
      case TransportSubtype.walking:
        return 'Walking';
      case TransportSubtype.cycling:
        return 'Cycling';
      case TransportSubtype.flying:
        return 'Flying';
      case TransportSubtype.boating:
        return 'Boating';
      case TransportSubtype.rideshare:
        return 'Rideshare';
      case TransportSubtype.taxi:
        return 'Taxi';
      case TransportSubtype.other:
        return 'Other Transport';
    }
  }
}

/// Extension on ActivitySubtype to provide a displayName getter
extension ActivitySubtypeExtension on ActivitySubtype {
  /// Get a user-friendly display name for the activity subtype
  String get displayName {
    switch (this) {
      case ActivitySubtype.sports:
        return 'Sports';
      case ActivitySubtype.entertainment:
        return 'Entertainment';
      case ActivitySubtype.social:
        return 'Social';
      case ActivitySubtype.dining:
        return 'Dining';
      case ActivitySubtype.shopping:
        return 'Shopping';
      case ActivitySubtype.outdoor:
        return 'Outdoor';
      case ActivitySubtype.cultural:
        return 'Cultural';
      case ActivitySubtype.relaxation:
        return 'Relaxation';
      case ActivitySubtype.other:
        return 'Other Activity';
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
      case AccommodationSubtype.airbnb:
        return 'Airbnb';
      case AccommodationSubtype.hostel:
        return 'Hostel';
      case AccommodationSubtype.resort:
        return 'Resort';
      case AccommodationSubtype.camping:
        return 'Camping';
      case AccommodationSubtype.friendFamily:
        return 'Friend/Family Home';
      case AccommodationSubtype.vacationRental:
        return 'Vacation Rental';
      case AccommodationSubtype.business:
        return 'Business Lodging';
      case AccommodationSubtype.other:
        return 'Other Accommodation';
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
      case AnniversarySubtype.wedding:
        return 'Wedding Anniversary';
      case AnniversarySubtype.relationship:
        return 'Relationship Anniversary';
      case AnniversarySubtype.work:
        return 'Work Anniversary';
      case AnniversarySubtype.graduation:
        return 'Graduation Anniversary';
      case AnniversarySubtype.memorial:
        return 'Memorial';
      case AnniversarySubtype.holiday:
        return 'Holiday';
      case AnniversarySubtype.other:
        return 'Other Anniversary';
    }
  }
}
