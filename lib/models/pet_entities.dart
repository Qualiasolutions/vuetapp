import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_entities.freezed.dart';
part 'pet_entities.g.dart';

/// Pet entity for Pets category
/// Fields as specified in detailed guide: name, type, breed, dob, microchip_number, vet_id
@freezed
class Pet with _$Pet {
  const factory Pet({
    int? id,
    required String name,
    required String type, // Dog, Cat, Bird, etc.
    String? breed,
    DateTime? dob,
    String? microchipNumber,
    int? vetId, // Links to Vet entity
    String? notes,
    @Default('Pet') String resourceType,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

/// Vet entity for Pets category
/// Fields: name, phone, address, email
@freezed
class Vet with _$Vet {
  const factory Vet({
    int? id,
    required String name,
    String? phone,
    String? address,
    String? email,
    String? notes,
    @Default('Vet') String resourceType,
  }) = _Vet;

  factory Vet.fromJson(Map<String, dynamic> json) => _$VetFromJson(json);
}

/// Pet Appointment entity for Pets category
/// Fields: pet_id, vet_id, appointment_datetime, type, notes
@freezed
class PetAppointment with _$PetAppointment {
  const factory PetAppointment({
    int? id,
    required int petId,
    required int vetId,
    required DateTime appointmentDatetime,
    required String type, // Checkup, Vaccination, Surgery, etc.
    String? notes,
    @Default('PetAppointment') String resourceType,
  }) = _PetAppointment;

  factory PetAppointment.fromJson(Map<String, dynamic> json) => _$PetAppointmentFromJson(json);
}

/// Pet Walker entity for Pets category
@freezed
class PetWalker with _$PetWalker {
  const factory PetWalker({
    int? id,
    required String name,
    String? phone,
    String? email,
    double? hourlyRate,
    String? availability,
    String? notes,
    @Default('PetWalker') String resourceType,
  }) = _PetWalker;

  factory PetWalker.fromJson(Map<String, dynamic> json) => _$PetWalkerFromJson(json);
}

/// Pet Groomer entity for Pets category
@freezed
class PetGroomer with _$PetGroomer {
  const factory PetGroomer({
    int? id,
    required String name,
    String? phone,
    String? address,
    String? email,
    String? services, // Bathing, Nail trimming, Hair cutting, etc.
    String? notes,
    @Default('PetGroomer') String resourceType,
  }) = _PetGroomer;

  factory PetGroomer.fromJson(Map<String, dynamic> json) => _$PetGroomerFromJson(json);
}

/// Pet Sitter entity for Pets category
@freezed
class PetSitter with _$PetSitter {
  const factory PetSitter({
    int? id,
    required String name,
    String? phone,
    String? email,
    String? address,
    double? dailyRate,
    String? availability,
    String? notes,
    @Default('PetSitter') String resourceType,
  }) = _PetSitter;

  factory PetSitter.fromJson(Map<String, dynamic> json) => _$PetSitterFromJson(json);
}

/// Validation helpers for Pet entities
class PetValidators {
  /// Required string validator
  static String? required(String? value) {
    return value != null && value.trim().isNotEmpty ? null : 'Required';
  }
  
  /// Date ISO validator (YYYY-MM-DD)
  static String? dateIso(String? value) {
    return DateTime.tryParse(value ?? '') != null ? null : 'yyyy-MM-dd';
  }
  
  /// Optional date validator
  static String? optionalDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value) != null ? null : 'yyyy-MM-dd';
  }
  
  /// Positive number validator
  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = double.tryParse(value);
    return parsed != null && parsed > 0 ? null : 'Must be > 0';
  }
  
  /// Email validator (optional)
  static String? optionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(value) ? null : 'Invalid email';
  }
  
  /// Phone validator (optional)
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(value) ? null : 'Invalid phone';
  }
}
