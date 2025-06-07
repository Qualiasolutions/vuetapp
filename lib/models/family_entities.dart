import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_entities.freezed.dart';
part 'family_entities.g.dart';

/// Birthday entity for Family category
/// Fields as specified in detailed guide: name, dob, known_year
@freezed
class Birthday with _$Birthday {
  const factory Birthday({
    int? id,
    required String name,
    required DateTime dob,
    @Default(true) bool knownYear,
    String? notes,
    @Default('Birthday') String resourceType,
  }) = _Birthday;

  factory Birthday.fromJson(Map<String, dynamic> json) => _$BirthdayFromJson(json);
}

/// Anniversary entity for Family category
/// Same fields as Birthday but dob renamed to date
@freezed
class Anniversary with _$Anniversary {
  const factory Anniversary({
    int? id,
    required String name,
    required DateTime date,
    @Default(true) bool knownYear,
    String? notes,
    @Default('Anniversary') String resourceType,
  }) = _Anniversary;

  factory Anniversary.fromJson(Map<String, dynamic> json) => _$AnniversaryFromJson(json);
}

/// Patient entity for Family category
/// Fields: first_name, last_name, medical_number
@freezed
class Patient with _$Patient {
  const factory Patient({
    int? id,
    required String firstName,
    required String lastName,
    String? medicalNumber,
    String? notes,
    @Default('Patient') String resourceType,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
}

/// Appointment entity for Family category
/// Fields: title, start_datetime, end_datetime
@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    int? id,
    required String title,
    required DateTime startDatetime,
    required DateTime endDatetime,
    String? location,
    String? notes,
    List<int>? patientIds, // Links to Patient entities
    @Default('Appointment') String resourceType,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}

/// Family Member entity for Family category
@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    int? id,
    required String firstName,
    required String lastName,
    String? relationship,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
    @Default('FamilyMember') String resourceType,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);
}

/// Validation helpers for Family entities
class FamilyValidators {
  /// Required string validator
  static String? required(String? value) {
    return value != null && value.trim().isNotEmpty ? null : 'Required';
  }
  
  /// Date ISO validator (YYYY-MM-DD)
  static String? dateIso(String? value) {
    return DateTime.tryParse(value ?? '') != null ? null : 'yyyy-MM-dd';
  }
  
  /// Positive integer validator
  static String? positiveInt(String? value) {
    return int.tryParse(value ?? '') != null && int.parse(value!) > 0 ? null : '>0';
  }
}
