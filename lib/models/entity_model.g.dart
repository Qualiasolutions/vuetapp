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
  EntitySubtype.anniversary: 'Anniversary',
  EntitySubtype.anniversaryPlan: 'AnniversaryPlan',
  EntitySubtype.birthday: 'Birthday',
  EntitySubtype.careerGoal: 'CareerGoal',
  EntitySubtype.daysOff: 'DaysOff',
  EntitySubtype.employee: 'Employee',
  EntitySubtype.academicPlan: 'AcademicPlan',
  EntitySubtype.extracurricularPlan: 'ExtracurricularPlan',
  EntitySubtype.school: 'School',
  EntitySubtype.schoolBreak: 'SchoolBreak',
  EntitySubtype.schoolTerm: 'SchoolTerm',
  EntitySubtype.schoolYear: 'SchoolYear',
  EntitySubtype.student: 'Student',
  EntitySubtype.finance: 'Finance',
  EntitySubtype.food: 'Food',
  EntitySubtype.foodPlan: 'FoodPlan',
  EntitySubtype.garden: 'Garden',
  EntitySubtype.healthBeauty: 'HealthBeauty',
  EntitySubtype.healthGoal: 'HealthGoal',
  EntitySubtype.patient: 'Patient',
  EntitySubtype.appointment: 'Appointment',
  EntitySubtype.home: 'Home',
  EntitySubtype.homeAppliance: 'HomeAppliance',
  EntitySubtype.laundryPlan: 'LaundryPlan',
  EntitySubtype.list: 'List',
  EntitySubtype.listEntry: 'ListEntry',
  EntitySubtype.planningList: 'PlanningList',
  EntitySubtype.planningSublist: 'PlanningSublist',
  EntitySubtype.planningListItem: 'PlanningListItem',
  EntitySubtype.shoppingList: 'ShoppingList',
  EntitySubtype.shoppingListItem: 'ShoppingListItem',
  EntitySubtype.shoppingListStore: 'ShoppingListStore',
  EntitySubtype.shoppingListDelegation: 'ShoppingListDelegation',
  EntitySubtype.pet: 'Pet',
  EntitySubtype.vet: 'Vet',
  EntitySubtype.walker: 'Walker',
  EntitySubtype.groomer: 'Groomer',
  EntitySubtype.sitter: 'Sitter',
  EntitySubtype.microchipCompany: 'MicrochipCompany',
  EntitySubtype.insuranceCompany: 'InsuranceCompany',
  EntitySubtype.insurancePolicy: 'InsurancePolicy',
  EntitySubtype.event: 'Event',
  EntitySubtype.eventSubentity: 'EventSubentity',
  EntitySubtype.hobby: 'Hobby',
  EntitySubtype.holiday: 'Holiday',
  EntitySubtype.holidayPlan: 'HolidayPlan',
  EntitySubtype.socialPlan: 'SocialPlan',
  EntitySubtype.socialMedia: 'SocialMedia',
  EntitySubtype.guestListInvite: 'GuestListInvite',
  EntitySubtype.car: 'Car',
  EntitySubtype.boat: 'Boat',
  EntitySubtype.publicTransport: 'PublicTransport',
  EntitySubtype.vehicle: 'Vehicle',
  EntitySubtype.trip: 'Trip',
  EntitySubtype.travelPlan: 'TravelPlan',
  EntitySubtype.flight: 'Flight',
  EntitySubtype.trainBusFerry: 'TrainBusFerry',
  EntitySubtype.rentalCar: 'RentalCar',
  EntitySubtype.taxiOrTransfer: 'TaxiOrTransfer',
  EntitySubtype.driveTime: 'DriveTime',
  EntitySubtype.hotelOrRental: 'HotelOrRental',
  EntitySubtype.stayWithFriend: 'StayWithFriend',
  EntitySubtype.professionalEntity: 'ProfessionalEntity',
  EntitySubtype.charity: 'Charity',
  EntitySubtype.religiousOrganization: 'ReligiousOrganization',
  EntitySubtype.charityEvent: 'CharityEvent',
  EntitySubtype.donation: 'Donation',
  EntitySubtype.religiousService: 'ReligiousService',
  EntitySubtype.clothing: 'Clothing',
};
