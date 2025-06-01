// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseEntityModelImpl _$$BaseEntityModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BaseEntityModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String,
      appCategoryId: (json['app_category_id'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      parentId: json['parentId'] as String?,
      subtype: $enumDecode(_$EntitySubtypeEnumMap, json['entity_type_id']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isHidden: json['isHidden'] as bool?,
      customFields: json['attributes'] as Map<String, dynamic>?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$BaseEntityModelImplToJson(
        _$BaseEntityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'user_id': instance.userId,
      'app_category_id': instance.appCategoryId,
      'imageUrl': instance.imageUrl,
      'parentId': instance.parentId,
      'entity_type_id': _$EntitySubtypeEnumMap[instance.subtype]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'isHidden': instance.isHidden,
      'attributes': instance.customFields,
      'attachments': instance.attachments,
      'dueDate': instance.dueDate?.toIso8601String(),
      'status': instance.status,
    };

const _$EntitySubtypeEnumMap = {
  EntitySubtype.academicPlan: 'Academic Plan',
  EntitySubtype.courseWork: 'Course Work',
  EntitySubtype.extracurricularPlan: 'Extracurricular Plan',
  EntitySubtype.school: 'School',
  EntitySubtype.student: 'Student',
  EntitySubtype.subject: 'Subject',
  EntitySubtype.teacher: 'Teacher',
  EntitySubtype.tutor: 'Tutor',
  EntitySubtype.anniversary: 'Anniversary',
  EntitySubtype.anniversaryPlan: 'Anniversary Plan',
  EntitySubtype.birthday: 'Birthday',
  EntitySubtype.event: 'Event',
  EntitySubtype.guestListInvite: 'Guest List Invite',
  EntitySubtype.hobby: 'Hobby',
  EntitySubtype.holiday: 'Holiday',
  EntitySubtype.holidayPlan: 'Holiday Plan',
  EntitySubtype.socialMedia: 'Social Media',
  EntitySubtype.socialPlan: 'Social Plan',
  EntitySubtype.pet: 'Pet',
  EntitySubtype.vet: 'Vet',
  EntitySubtype.petWalker: 'Pet Walker',
  EntitySubtype.petGroomer: 'Pet Groomer',
  EntitySubtype.petSitter: 'Pet Sitter',
  EntitySubtype.microchipCompany: 'Microchip Company',
  EntitySubtype.petInsuranceCompany: 'Pet Insurance Company',
  EntitySubtype.petInsurancePolicy: 'Pet Insurance Policy',
  EntitySubtype.colleague: 'Colleague',
  EntitySubtype.work: 'Work',
  EntitySubtype.beautySalon: 'Beauty Salon',
  EntitySubtype.dentist: 'Dentist',
  EntitySubtype.doctor: 'Doctor',
  EntitySubtype.stylist: 'Stylist',
  EntitySubtype.appliance: 'Appliance',
  EntitySubtype.contractor: 'Contractor',
  EntitySubtype.furniture: 'Furniture',
  EntitySubtype.home: 'Home',
  EntitySubtype.room: 'Room',
  EntitySubtype.gardenTool: 'Garden Tool',
  EntitySubtype.plant: 'Plant',
  EntitySubtype.foodPlan: 'Food Plan',
  EntitySubtype.recipe: 'Recipe',
  EntitySubtype.restaurant: 'Restaurant',
  EntitySubtype.dryCleaners: 'Dry Cleaners',
  EntitySubtype.laundryItem: 'Laundry Item',
  EntitySubtype.bank: 'Bank',
  EntitySubtype.bankAccount: 'Bank Account',
  EntitySubtype.creditCard: 'Credit Card',
  EntitySubtype.boat: 'Boat',
  EntitySubtype.car: 'Car',
  EntitySubtype.publicTransport: 'Public Transport',
  EntitySubtype.trip: 'Trip',
};
