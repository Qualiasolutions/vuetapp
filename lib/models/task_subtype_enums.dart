// File defining subtypes for various task types

/// Transport subtypes for the transport task type
enum TransportSubtype {
  flight('flight', 'Flight'),
  train('train', 'Train'),
  rentalCar('rentalCar', 'Rental Car'),
  taxi('taxi', 'Taxi'),
  driveTime('driveTime', 'Drive Time');

  const TransportSubtype(this.value, this.displayName);

  final String value;
  final String displayName;
}

/// Activity subtypes for the activity task type
enum ActivitySubtype {
  activity('activity', 'Activity'),
  foodActivity('foodActivity', 'Food/Dining'),
  otherActivity('otherActivity', 'Other Activity');

  const ActivitySubtype(this.value, this.displayName);

  final String value;
  final String displayName;
}

/// Accommodation subtypes for the accommodation task type
enum AccommodationSubtype {
  hotel('hotel', 'Hotel'),
  stayWithFriend('stayWithFriend', 'Stay with Friend');

  const AccommodationSubtype(this.value, this.displayName);

  final String value;
  final String displayName;
}

/// Anniversary subtypes for the anniversary task type
enum AnniversarySubtype {
  birthday('birthday', 'Birthday'),
  anniversary('anniversary', 'Anniversary');

  const AnniversarySubtype(this.value, this.displayName);

  final String value;
  final String displayName;
}
