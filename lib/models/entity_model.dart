import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_model.freezed.dart';
part 'entity_model.g.dart';

// Entity subtypes matching exact database values (50 total)
enum EntitySubtype {
  // Education entities (Category 3)
  @JsonValue('Academic Plan')
  academicPlan,
  @JsonValue('Course Work')
  courseWork,
  @JsonValue('Extracurricular Plan')
  extracurricularPlan,
  @JsonValue('School')
  school,
  @JsonValue('Student')
  student,
  @JsonValue('Subject')
  subject,
  @JsonValue('Teacher')
  teacher,
  @JsonValue('Tutor')
  tutor,
  
  // Social entities (Category 2)
  @JsonValue('Anniversary')
  anniversary,
  @JsonValue('Anniversary Plan')
  anniversaryPlan,
  @JsonValue('Birthday')
  birthday,
  @JsonValue('Event')
  event,
  @JsonValue('Guest List Invite')
  guestListInvite,
  @JsonValue('Hobby')
  hobby,
  @JsonValue('Holiday')
  holiday,
  @JsonValue('Holiday Plan')
  holidayPlan,
  @JsonValue('Social Media')
  socialMedia,
  @JsonValue('Social Plan')
  socialPlan,
  
  // Pets entities (Category 1)
  @JsonValue('Pet')
  pet,
  @JsonValue('Vet')
  vet,
  @JsonValue('Pet Walker')
  petWalker,
  @JsonValue('Pet Groomer')
  petGroomer,
  @JsonValue('Pet Sitter')
  petSitter,
  @JsonValue('Microchip Company')
  microchipCompany,
  @JsonValue('Pet Insurance Company')
  petInsuranceCompany,
  @JsonValue('Pet Insurance Policy')
  petInsurancePolicy,
  
  // Career entities (Category 4)
  @JsonValue('Colleague')
  colleague,
  @JsonValue('Work')
  work,
  
  // Health entities (Category 6)
  @JsonValue('Beauty Salon')
  beautySalon,
  @JsonValue('Dentist')
  dentist,
  @JsonValue('Doctor')
  doctor,
  @JsonValue('Stylist')
  stylist,
  
  // Home entities (Category 7)
  @JsonValue('Appliance')
  appliance,
  @JsonValue('Contractor')
  contractor,
  @JsonValue('Furniture')
  furniture,
  @JsonValue('Home')
  home,
  @JsonValue('Room')
  room,
  
  // Garden entities (Category 8)
  @JsonValue('Garden Tool')
  gardenTool,
  @JsonValue('Plant')
  plant,
  
  // Food entities (Category 9)
  @JsonValue('Food Plan')
  foodPlan,
  @JsonValue('Recipe')
  recipe,
  @JsonValue('Restaurant')
  restaurant,
  
  // Laundry entities (Category 10)
  @JsonValue('Dry Cleaners')
  dryCleaners,
  @JsonValue('Laundry Item')
  laundryItem,
  
  // Finance entities (Category 11)
  @JsonValue('Bank')
  bank,
  @JsonValue('Bank Account')
  bankAccount,
  @JsonValue('Credit Card')
  creditCard,
  
  // Transport entities (Category 12)
  @JsonValue('Boat')
  boat,
  @JsonValue('Car')
  car,
  @JsonValue('Public Transport')
  publicTransport,
  
  // Travel entities (Category 5)
  @JsonValue('Trip')
  trip,
}

@freezed
class BaseEntityModel with _$BaseEntityModel {
  const factory BaseEntityModel({
    String? id,
    required String name,
    String? description,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'app_category_id') int? appCategoryId,
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

// Entity type helper class for category mapping
class EntityTypeHelper {
  static const Map<EntitySubtype, int> categoryMapping = {
    // Pets (Category 1)
    EntitySubtype.pet: 1,
    EntitySubtype.vet: 1,
    EntitySubtype.petWalker: 1,
    EntitySubtype.petGroomer: 1,
    EntitySubtype.petSitter: 1,
    EntitySubtype.microchipCompany: 1,
    EntitySubtype.petInsuranceCompany: 1,
    EntitySubtype.petInsurancePolicy: 1,
    
    // Social (Category 2)
    EntitySubtype.anniversary: 2,
    EntitySubtype.anniversaryPlan: 2,
    EntitySubtype.birthday: 2,
    EntitySubtype.event: 2,
    EntitySubtype.guestListInvite: 2,
    EntitySubtype.hobby: 2,
    EntitySubtype.holiday: 2,
    EntitySubtype.holidayPlan: 2,
    EntitySubtype.socialMedia: 2,
    EntitySubtype.socialPlan: 2,
    
    // Education (Category 3)
    EntitySubtype.academicPlan: 3,
    EntitySubtype.courseWork: 3,
    EntitySubtype.extracurricularPlan: 3,
    EntitySubtype.school: 3,
    EntitySubtype.student: 3,
    EntitySubtype.subject: 3,
    EntitySubtype.teacher: 3,
    EntitySubtype.tutor: 3,
    
    // Career (Category 4)
    EntitySubtype.colleague: 4,
    EntitySubtype.work: 4,
    
    // Travel (Category 5)
    EntitySubtype.trip: 5,
    
    // Health (Category 6)
    EntitySubtype.beautySalon: 6,
    EntitySubtype.dentist: 6,
    EntitySubtype.doctor: 6,
    EntitySubtype.stylist: 6,
    
    // Home (Category 7)
    EntitySubtype.appliance: 7,
    EntitySubtype.contractor: 7,
    EntitySubtype.furniture: 7,
    EntitySubtype.home: 7,
    EntitySubtype.room: 7,
    
    // Garden (Category 8)
    EntitySubtype.gardenTool: 8,
    EntitySubtype.plant: 8,
    
    // Food (Category 9)
    EntitySubtype.foodPlan: 9,
    EntitySubtype.recipe: 9,
    EntitySubtype.restaurant: 9,
    
    // Laundry (Category 10)
    EntitySubtype.dryCleaners: 10,
    EntitySubtype.laundryItem: 10,
    
    // Finance (Category 11)
    EntitySubtype.bank: 11,
    EntitySubtype.bankAccount: 11,
    EntitySubtype.creditCard: 11,
    
    // Transport (Category 12)
    EntitySubtype.boat: 12,
    EntitySubtype.car: 12,
    EntitySubtype.publicTransport: 12,
  };
  
  static int getCategoryId(EntitySubtype subtype) {
    return categoryMapping[subtype] ?? 1;
  }
  
  static List<EntitySubtype> getEntityTypesForCategory(int categoryId) {
    return categoryMapping.entries
        .where((entry) => entry.value == categoryId)
        .map((entry) => entry.key)
        .toList();
  }
  
  static String getDisplayName(EntitySubtype subtype) {
    return subtype.toString().split('.').last;
  }
}
