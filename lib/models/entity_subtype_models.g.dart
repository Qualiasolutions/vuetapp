// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_subtype_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetSpecificDataModelImpl _$$PetSpecificDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PetSpecificDataModelImpl(
      entityId: json['entityId'] as String,
      petType: json['petType'] as String?,
      breed: json['breed'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      vetName: json['vetName'] as String?,
      vetPhoneNumber: json['vetPhoneNumber'] as String?,
      microchipId: json['microchipId'] as String?,
      insurancePolicyNumber: json['insurancePolicyNumber'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$PetSpecificDataModelImplToJson(
        _$PetSpecificDataModelImpl instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'petType': instance.petType,
      'breed': instance.breed,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'vetName': instance.vetName,
      'vetPhoneNumber': instance.vetPhoneNumber,
      'microchipId': instance.microchipId,
      'insurancePolicyNumber': instance.insurancePolicyNumber,
      'notes': instance.notes,
    };

_$HomeApplianceSpecificDataModelImpl
    _$$HomeApplianceSpecificDataModelImplFromJson(Map<String, dynamic> json) =>
        _$HomeApplianceSpecificDataModelImpl(
          entityId: json['entityId'] as String,
          applianceType: json['applianceType'] as String?,
          brand: json['brand'] as String?,
          modelNumber: json['modelNumber'] as String?,
          purchaseDate: json['purchaseDate'] == null
              ? null
              : DateTime.parse(json['purchaseDate'] as String),
          warrantyExpiryDate: json['warrantyExpiryDate'] == null
              ? null
              : DateTime.parse(json['warrantyExpiryDate'] as String),
          serialNumber: json['serialNumber'] as String?,
          manualUrl: json['manualUrl'] as String?,
        );

Map<String, dynamic> _$$HomeApplianceSpecificDataModelImplToJson(
        _$HomeApplianceSpecificDataModelImpl instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'applianceType': instance.applianceType,
      'brand': instance.brand,
      'modelNumber': instance.modelNumber,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'warrantyExpiryDate': instance.warrantyExpiryDate?.toIso8601String(),
      'serialNumber': instance.serialNumber,
      'manualUrl': instance.manualUrl,
    };

_$CarSpecificDataModelImpl _$$CarSpecificDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CarSpecificDataModelImpl(
      entityId: json['entityId'] as String,
      make: json['make'] as String?,
      model: json['model'] as String?,
      registration: json['registration'] as String?,
      motDueDate: json['motDueDate'] == null
          ? null
          : DateTime.parse(json['motDueDate'] as String),
      insuranceDueDate: json['insuranceDueDate'] == null
          ? null
          : DateTime.parse(json['insuranceDueDate'] as String),
      serviceDueDate: json['serviceDueDate'] == null
          ? null
          : DateTime.parse(json['serviceDueDate'] as String),
    );

Map<String, dynamic> _$$CarSpecificDataModelImplToJson(
        _$CarSpecificDataModelImpl instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'make': instance.make,
      'model': instance.model,
      'registration': instance.registration,
      'motDueDate': instance.motDueDate?.toIso8601String(),
      'insuranceDueDate': instance.insuranceDueDate?.toIso8601String(),
      'serviceDueDate': instance.serviceDueDate?.toIso8601String(),
    };

_$HolidaySpecificDataModelImpl _$$HolidaySpecificDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HolidaySpecificDataModelImpl(
      entityId: json['entityId'] as String,
      destination: json['destination'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      holidayType: json['holidayType'] as String?,
      transportationDetails: json['transportationDetails'] as String?,
      accommodationDetails: json['accommodationDetails'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      stringId: json['stringId'] as String?,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$$HolidaySpecificDataModelImplToJson(
        _$HolidaySpecificDataModelImpl instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'holidayType': instance.holidayType,
      'transportationDetails': instance.transportationDetails,
      'accommodationDetails': instance.accommodationDetails,
      'budget': instance.budget,
      'stringId': instance.stringId,
      'countryCode': instance.countryCode,
    };
