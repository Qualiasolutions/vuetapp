import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_entities.freezed.dart';
part 'transport_entities.g.dart';

/// Car entity for Transport category
/// Fields as specified in detailed guide: make, model, registration, mot_due_date, insurance_due_date, service_due_date, tax_due_date, warranty_due_date
@freezed
class Car with _$Car {
  const factory Car({
    int? id,
    required String name,
    required String make,
    required String model,
    required String registration,
    DateTime? motDueDate,
    DateTime? insuranceDueDate,
    DateTime? serviceDueDate,
    DateTime? taxDueDate,
    DateTime? warrantyDueDate,
    String? notes,
    @Default('Car') String resourceType,
  }) = _Car;

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}

/// Public Transport entity for Transport category
@freezed
class PublicTransport with _$PublicTransport {
  const factory PublicTransport({
    int? id,
    required String name,
    required String transportType, // Bus, Metro, Tram, etc.
    String? routeNumber,
    String? operator,
    String? notes,
    @Default('PublicTransport') String resourceType,
  }) = _PublicTransport;

  factory PublicTransport.fromJson(Map<String, dynamic> json) => _$PublicTransportFromJson(json);
}

/// Train/Bus/Ferry entity for Transport category
@freezed
class TrainBusFerry with _$TrainBusFerry {
  const factory TrainBusFerry({
    int? id,
    required String name,
    required String transportType, // Train, Bus, Ferry
    String? operator,
    String? routeNumber,
    String? departureStation,
    String? arrivalStation,
    DateTime? departureTime,
    DateTime? arrivalTime,
    String? notes,
    @Default('TrainBusFerry') String resourceType,
  }) = _TrainBusFerry;

  factory TrainBusFerry.fromJson(Map<String, dynamic> json) => _$TrainBusFerryFromJson(json);
}

/// Rental Car entity for Transport category
@freezed
class RentalCar with _$RentalCar {
  const factory RentalCar({
    int? id,
    required String name,
    required String rentalCompany,
    String? make,
    String? model,
    String? registration,
    DateTime? pickupDate,
    DateTime? returnDate,
    String? pickupLocation,
    String? returnLocation,
    double? totalCost,
    String? notes,
    @Default('RentalCar') String resourceType,
  }) = _RentalCar;

  factory RentalCar.fromJson(Map<String, dynamic> json) => _$RentalCarFromJson(json);
}

/// Validation helpers for Transport entities
class TransportValidators {
  /// Required string validator
  static String? required(String? value) {
    return value != null && value.trim().isNotEmpty ? null : 'Required';
  }
  
  /// Date ISO validator (YYYY-MM-DD)
  static String? dateIso(String? value) {
    return DateTime.tryParse(value ?? '') != null ? null : 'yyyy-MM-dd';
  }
  
  /// Positive number validator
  static String? positiveNumber(String? value) {
    final parsed = double.tryParse(value ?? '');
    return parsed != null && parsed > 0 ? null : 'Must be > 0';
  }
  
  /// Optional date validator
  static String? optionalDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value) != null ? null : 'yyyy-MM-dd';
  }
}
