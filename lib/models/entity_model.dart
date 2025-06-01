import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_model.freezed.dart';
part 'entity_model.g.dart';

// Renamed from EntityTypeName for clarity and to match Supabase 'subtype' column
enum EntitySubtype {
  // Anniversary & Birthday entities
  @JsonValue('Anniversary')
  anniversary,
  @JsonValue('AnniversaryPlan')
  anniversaryPlan,
  @JsonValue('Birthday')
  birthday,
  
  // Career entities
  @JsonValue('CareerGoal')
  careerGoal,
  @JsonValue('DaysOff')
  daysOff,
  @JsonValue('Employee')
  employee,
  
  // Education entities
  @JsonValue('AcademicPlan')
  academicPlan,
  @JsonValue('ExtracurricularPlan')
  extracurricularPlan,
  @JsonValue('School')
  school,
  @JsonValue('SchoolBreak')
  schoolBreak,
  @JsonValue('SchoolTerm')
  schoolTerm,
  @JsonValue('SchoolYear')
  schoolYear,
  @JsonValue('Student')
  student,
  
  // Finance entities
  @JsonValue('Finance')
  finance,
  
  // Food entities
  @JsonValue('Food')
  food,
  @JsonValue('FoodPlan')
  foodPlan,
  
  // Garden entities
  @JsonValue('Garden')
  garden,
  
  // Health entities
  @JsonValue('HealthBeauty')
  healthBeauty,
  @JsonValue('HealthGoal')
  healthGoal,
  @JsonValue('Patient')
  patient,
  @JsonValue('Appointment')
  appointment,
  
  // Home entities
  @JsonValue('Home')
  home,
  @JsonValue('HomeAppliance')
  homeAppliance,
  
  // Laundry entities
  @JsonValue('LaundryPlan')
  laundryPlan,
  
  // List entities
  @JsonValue('List')
  list,
  @JsonValue('ListEntry')
  listEntry,
  @JsonValue('PlanningList')
  planningList,
  @JsonValue('PlanningSublist')
  planningSublist,
  @JsonValue('PlanningListItem')
  planningListItem,
  @JsonValue('ShoppingList')
  shoppingList,
  @JsonValue('ShoppingListItem')
  shoppingListItem,
  @JsonValue('ShoppingListStore')
  shoppingListStore,
  @JsonValue('ShoppingListDelegation')
  shoppingListDelegation,
  
  // Pet entities
  @JsonValue('Pet')
  pet,
  @JsonValue('Vet')
  vet,
  @JsonValue('Walker')
  walker,
  @JsonValue('Groomer')
  groomer,
  @JsonValue('Sitter')
  sitter,
  @JsonValue('MicrochipCompany')
  microchipCompany,
  @JsonValue('InsuranceCompany')
  insuranceCompany,
  @JsonValue('InsurancePolicy')
  insurancePolicy,
  
  // Social entities
  @JsonValue('Event')
  event,
  @JsonValue('EventSubentity')
  eventSubentity,
  @JsonValue('Hobby')
  hobby,
  @JsonValue('Holiday')
  holiday,
  @JsonValue('HolidayPlan')
  holidayPlan,
  @JsonValue('SocialPlan')
  socialPlan,
  @JsonValue('SocialMedia')
  socialMedia,
  @JsonValue('GuestListInvite')
  guestListInvite,
  
  // Transport entities
  @JsonValue('Car')
  car,
  @JsonValue('Boat')
  boat,
  @JsonValue('PublicTransport')
  publicTransport,
  @JsonValue('Vehicle')
  vehicle,
  
  // Travel entities
  @JsonValue('Trip')
  trip,
  @JsonValue('TravelPlan')
  travelPlan,
  @JsonValue('Flight')
  flight,
  @JsonValue('TrainBusFerry')
  trainBusFerry,
  @JsonValue('RentalCar')
  rentalCar,
  @JsonValue('TaxiOrTransfer')
  taxiOrTransfer,
  @JsonValue('DriveTime')
  driveTime,
  @JsonValue('HotelOrRental')
  hotelOrRental,
  @JsonValue('StayWithFriend')
  stayWithFriend,
  
  // Professional entities
  @JsonValue('ProfessionalEntity')
  professionalEntity,
  
  // Charity & Religion entities
  @JsonValue('Charity')
  charity,
  @JsonValue('ReligiousOrganization')
  religiousOrganization,
  @JsonValue('CharityEvent')
  charityEvent,
  @JsonValue('Donation')
  donation,
  @JsonValue('ReligiousService')
  religiousService,
  
  // Generic/Other
  @JsonValue('Clothing')
  clothing,
}

@freezed
class BaseEntityModel with _$BaseEntityModel {
  const factory BaseEntityModel({
    String? id,
    required String name,
    String? description,
    @JsonKey(name: 'user_id') required String userId, // Corrected to user_id
    @JsonKey(name: 'app_category_id') int? appCategoryId, // Changed from categoryId, type to int?
    String? imageUrl,
    String? parentId,
    @JsonKey(name: 'entity_type_id') required EntitySubtype subtype,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    bool? isHidden,
    @JsonKey(name: 'attributes') Map<String, dynamic>? customFields,
    List<String>? attachments,
    DateTime? dueDate,
    String? status,
  }) = _BaseEntityModel;

  factory BaseEntityModel.fromJson(Map<String, dynamic> json) =>
      _$BaseEntityModelFromJson(json);
}
