import 'package:freezed_annotation/freezed_annotation.dart';

part 'pets_model.freezed.dart';
part 'pets_model.g.dart';

enum PetSpecies {
  cat,
  dog,
  other,
}

@freezed
class Pet with _$Pet {
  const factory Pet({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    PetSpecies? species,
    DateTime? dob,
    @JsonKey(name: 'vaccination_due') DateTime? vaccinationDue,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

@freezed
class PetAppointment with _$PetAppointment {
  const factory PetAppointment({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'pet_id') required String petId,
    required String title,
    @JsonKey(name: 'start_datetime') required DateTime startDatetime,
    @JsonKey(name: 'end_datetime') required DateTime endDatetime,
    String? notes,
    String? location,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PetAppointment;

  factory PetAppointment.fromJson(Map<String, dynamic> json) => _$PetAppointmentFromJson(json);
}
