import 'package:freezed_annotation/freezed_annotation.dart';
// Ensure this import path is correct and entity_model.dart contains EntitySubtype

part 'entity_subtype_models.freezed.dart';
part 'entity_subtype_models.g.dart';

// Represents data from the 'pet_entities' table
@freezed
abstract class PetSpecificDataModel with _$PetSpecificDataModel {
  const factory PetSpecificDataModel({
    required String entityId,
    String? petType, // Changed from species
    String? breed,
    DateTime? dateOfBirth,
    String? vetName,
    String? vetPhoneNumber,
    String? microchipId,
    String? insurancePolicyNumber,
    String? notes, // Pet-specific notes
  }) = _PetSpecificDataModel;

  factory PetSpecificDataModel.fromJson(Map<String, dynamic> json) =>
      _$PetSpecificDataModelFromJson(json);
}

// Represents data from the 'home_appliance_entities' table
@freezed
abstract class HomeApplianceSpecificDataModel with _$HomeApplianceSpecificDataModel {
  const factory HomeApplianceSpecificDataModel({
    required String entityId,
    String? applianceType,
    String? brand,
    String? modelNumber,
    DateTime? purchaseDate,
    DateTime? warrantyExpiryDate,
    String? serialNumber, // Added
    String? manualUrl,
  }) = _HomeApplianceSpecificDataModel;

  factory HomeApplianceSpecificDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeApplianceSpecificDataModelFromJson(json);
}

// Represents data from the 'car_entities' table
@freezed
abstract class CarSpecificDataModel with _$CarSpecificDataModel {
  const factory CarSpecificDataModel({
    required String entityId,
    String? make,
    String? model,
    String? registration,
    DateTime? motDueDate,
    DateTime? insuranceDueDate,
    DateTime? serviceDueDate,
  }) = _CarSpecificDataModel;

  factory CarSpecificDataModel.fromJson(Map<String, dynamic> json) =>
      _$CarSpecificDataModelFromJson(json);
}

// Represents data from the 'holiday_entities' table
@freezed
abstract class HolidaySpecificDataModel with _$HolidaySpecificDataModel {
  const factory HolidaySpecificDataModel({
    required String entityId,
    String? destination, // Added
    required DateTime startDate,
    required DateTime endDate,
    String? holidayType, // Added
    String? transportationDetails, // Added
    String? accommodationDetails, // Added
    double? budget, // Added
    String? stringId, 
    String? countryCode,
  }) = _HolidaySpecificDataModel;

  factory HolidaySpecificDataModel.fromJson(Map<String, dynamic> json) =>
      _$HolidaySpecificDataModelFromJson(json);
}

// A wrapper class that might be used by repositories or services
// to combine BaseEntityModel with its specific data.
// This is optional and depends on how data is consumed.
// For now, repositories can return Tuples or custom classes if needed.
/*
@freezed
class FullEntityModel<T> with _$FullEntityModel<T> {
  const factory FullEntityModel({
    required BaseEntityModel baseDetails,
    T? specificDetails,
  }) = _FullEntityModel<T>;

  // No fromJson/toJson here as T is generic. 
  // Deserialization would happen at a higher level.
}
*/
