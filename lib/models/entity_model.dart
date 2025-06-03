import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart'; // Removed unused import
import 'package:uuid/uuid.dart';

part 'entity_model.freezed.dart';
part 'entity_model.g.dart';

// Entity subtypes matching exact database values (50 total)
enum EntitySubtype {
  // Education entities (Category 3)
  @JsonValue('AcademicPlan')
  academicPlan,
  @JsonValue('CourseWork')
  courseWork,
  @JsonValue('ExtracurricularPlan')
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
  @JsonValue('SchoolBreak')
  schoolBreak,
  @JsonValue('SchoolTerm')
  schoolTerm,
  @JsonValue('SchoolTermEnd')
  schoolTermEnd,
  @JsonValue('SchoolTermStart')
  schoolTermStart,
  @JsonValue('SchoolYearEnd')
  schoolYearEnd,
  @JsonValue('SchoolYearStart')
  schoolYearStart,
  
  // Social entities (Category 2)
  @JsonValue('Anniversary')
  anniversary,
  @JsonValue('AnniversaryPlan')
  anniversaryPlan,
  @JsonValue('Birthday')
  birthday,
  @JsonValue('Event')
  event,
  @JsonValue('GuestListInvite')
  guestListInvite,
  @JsonValue('Hobby')
  hobby,
  @JsonValue('Holiday')
  holiday,
  @JsonValue('HolidayPlan')
  holidayPlan,
  @JsonValue('SocialMedia')
  socialMedia,
  @JsonValue('SocialPlan')
  socialPlan,
  @JsonValue('EventSubentity')
  eventSubentity,
  @JsonValue('PetBirthday')
  petBirthday,
  
  // Pets entities (Category 1)
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
  
  // Career entities (Category 4)
  @JsonValue('Colleague')
  colleague,
  @JsonValue('Work')
  work,
  @JsonValue('CareerGoal')
  careerGoal,
  @JsonValue('DaysOff')
  daysOff,
  @JsonValue('Employee')
  employee,
  
  // Health entities (Category 6)
  @JsonValue('BeautySalon')
  beautySalon,
  @JsonValue('Dentist')
  dentist,
  @JsonValue('Doctor')
  doctor,
  @JsonValue('Stylist')
  stylist,
  @JsonValue('Therapist')
  therapist,
  @JsonValue('Physiotherapist')
  physiotherapist,
  @JsonValue('Medical Specialist')
  specialist,
  @JsonValue('Surgeon')
  surgeon,
  @JsonValue('Appointment')
  appointment,
  @JsonValue('BEAUTY')
  beauty,
  @JsonValue('FITNESS_ACTIVITY')
  fitnessActivity,
  @JsonValue('HealthGoal')
  healthGoal,
  @JsonValue('MEDICAL')
  medical,
  @JsonValue('Patient')
  patient,
  
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
  @JsonValue('CLEANING')
  cleaning,
  @JsonValue('COOKING')
  cooking,
  @JsonValue('HOME_MAINTENANCE')
  homeMaintenance,
  
  // Garden entities (Category 8)
  @JsonValue('Tool')
  tool,
  @JsonValue('Plant')
  plant,
  @JsonValue('Garden')
  garden,
  @JsonValue('GARDENING')
  gardening,
  
  // Food entities (Category 9)
  @JsonValue('FoodPlan')
  foodPlan,
  @JsonValue('Recipe')
  recipe,
  @JsonValue('Restaurant')
  restaurant,
  @JsonValue('Food')
  food,
  
  // Laundry entities (Category 10)
  @JsonValue('DryCleaners')
  dryCleaners,
  @JsonValue('Item')
  item,
  @JsonValue('Clothing')
  clothing,
  @JsonValue('LaundryPlan')
  laundryPlan,
  
  // Finance entities (Category 11)
  @JsonValue('Bank')
  bank,
  @JsonValue('BankAccount')
  bankAccount,
  @JsonValue('CreditCard')
  creditCard,
  @JsonValue('Finance')
  finance,
  
  // Transport entities (Category 12)
  @JsonValue('Boat')
  boat,
  @JsonValue('Car')
  car,
  @JsonValue('vehicle_car')
  vehicleCar,
  @JsonValue('PublicTransport')
  publicTransport,
  @JsonValue('Motorcycle')
  motorcycle,
  @JsonValue('Bicycle')
  bicycle,
  @JsonValue('Truck')
  truck,
  @JsonValue('Van')
  van,
  @JsonValue('RV')
  rv,
  @JsonValue('ATV')
  atv,
  @JsonValue('JetSki')
  jetSki,
  
  // Travel entities (Category 5)
  @JsonValue('Trip')
  trip,
  @JsonValue('ACCOMMODATION')
  accommodation,
  @JsonValue('PLACE')
  place,
  @JsonValue('DriveTime')
  driveTime,
  @JsonValue('Flight')
  flight,
  @JsonValue('HotelOrRental')
  hotelOrRental,
  @JsonValue('RentalCar')
  rentalCar,
  @JsonValue('StayWithFriend')
  stayWithFriend,
  @JsonValue('TaxiOrTransfer')
  taxiOrTransfer,
  @JsonValue('TrainBusFerry')
  trainBusFerry,
  @JsonValue('TravelPlan')
  travelPlan,
  
  // Documents entities (Category 14)
  @JsonValue('Document')
  document,
  @JsonValue('Passport')
  passport,
  @JsonValue('License')
  license,
  @JsonValue('BankStatement')
  bankStatement,
  @JsonValue('TaxDocument')
  taxDocument,
  @JsonValue('Contract')
  contract,
  @JsonValue('Will')
  will,
  @JsonValue('MedicalRecord')
  medicalRecord,
  @JsonValue('Prescription')
  prescription,
  @JsonValue('Resume')
  resume,
  @JsonValue('Certificate')
  certificate,
  
  // Fallback/General types - if needed
  @JsonValue('other')
  other,
  @JsonValue('general')
  general,
}

@freezed
class BaseEntityModel with _$BaseEntityModel {
  const factory BaseEntityModel({
    String? id,
    required String name,
    String? description,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'app_category_id') int? appCategoryId,
    @JsonKey(name: 'category_id') String? categoryId,
    String? imageUrl,
    String? parentId,
    @JsonKey(name: 'subtype') required EntitySubtype subtype,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    bool? isHidden,
    @JsonKey(name: 'custom_fields') Map<String, dynamic>? customFields,
    List<String>? attachments,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    String? status,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
  }) = _BaseEntityModel;

  factory BaseEntityModel.fromJson(Map<String, dynamic> json) =>
      _$BaseEntityModelFromJson(json);
}

// Entity type helper class for category mapping
class EntityTypeHelper {
  // Category ID mapping
  static const Map<EntitySubtype, int> categoryMapping = {
    // Pets (Category 1)
    EntitySubtype.pet: 1,
    EntitySubtype.vet: 1,
    EntitySubtype.walker: 1,
    EntitySubtype.groomer: 1,
    EntitySubtype.sitter: 1,
    EntitySubtype.microchipCompany: 1,
    EntitySubtype.insuranceCompany: 1,
    EntitySubtype.insurancePolicy: 1,
    
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
    EntitySubtype.therapist: 6,
    EntitySubtype.physiotherapist: 6,
    EntitySubtype.specialist: 6,
    EntitySubtype.surgeon: 6,
    
    // Home (Category 7)
    EntitySubtype.appliance: 7,
    EntitySubtype.contractor: 7,
    EntitySubtype.furniture: 7,
    EntitySubtype.home: 7,
    EntitySubtype.room: 7,
    
    // Garden (Category 8)
    EntitySubtype.tool: 8,
    EntitySubtype.plant: 8,
    
    // Food (Category 9)
    EntitySubtype.foodPlan: 9,
    EntitySubtype.recipe: 9,
    EntitySubtype.restaurant: 9,
    
    // Laundry (Category 10)
    EntitySubtype.dryCleaners: 10,
    EntitySubtype.item: 10,
    
    // Finance (Category 11)
    EntitySubtype.bank: 11,
    EntitySubtype.bankAccount: 11,
    EntitySubtype.creditCard: 11,
    
    // Transport (Category 12)
    EntitySubtype.boat: 12,
    EntitySubtype.car: 12,
    EntitySubtype.vehicleCar: 12,
    EntitySubtype.publicTransport: 12,
    EntitySubtype.motorcycle: 12,
    EntitySubtype.bicycle: 12,
    EntitySubtype.truck: 12,
    EntitySubtype.van: 12,
    EntitySubtype.rv: 12,
    EntitySubtype.atv: 12,
    EntitySubtype.jetSki: 12,
    
    // Documents (Category 14)
    EntitySubtype.document: 14,
    EntitySubtype.passport: 14,
    EntitySubtype.license: 14,
    EntitySubtype.bankStatement: 14,
    EntitySubtype.taxDocument: 14,
    EntitySubtype.contract: 14,
    EntitySubtype.will: 14,
    EntitySubtype.medicalRecord: 14,
    EntitySubtype.prescription: 14,
    EntitySubtype.resume: 14,
    EntitySubtype.certificate: 14,
  };
  
  // Map from EntitySubtype to entity_type_id in the database
  static const Map<EntitySubtype, String> entityTypeIdMapping = {
    // Pet category
    EntitySubtype.pet: 'pet',
    EntitySubtype.vet: 'vet',
    EntitySubtype.walker: 'walker',
    EntitySubtype.groomer: 'groomer',
    EntitySubtype.sitter: 'sitter',
    EntitySubtype.microchipCompany: 'microchip_company',
    EntitySubtype.insuranceCompany: 'insurance_company_pet',
    EntitySubtype.insurancePolicy: 'insurance_policy_pet',
    
    // Social category
    EntitySubtype.event: 'event',
    EntitySubtype.hobby: 'hobby',
    EntitySubtype.socialMedia: 'social_media',
    EntitySubtype.socialPlan: 'social_plan',
    EntitySubtype.anniversary: 'anniversary',
    EntitySubtype.anniversaryPlan: 'anniversary_plan',
    EntitySubtype.birthday: 'birthday',
    EntitySubtype.holiday: 'holiday',
    EntitySubtype.holidayPlan: 'holiday_plan',
    EntitySubtype.guestListInvite: 'guest_list_invite',
    
    // Education category
    EntitySubtype.academicPlan: 'academic_plan',
    EntitySubtype.courseWork: 'course_work',
    EntitySubtype.extracurricularPlan: 'extracurricular_plan',
    EntitySubtype.school: 'school',
    EntitySubtype.student: 'student',
    EntitySubtype.subject: 'subject',
    EntitySubtype.teacher: 'teacher',
    EntitySubtype.tutor: 'tutor',
    
    // Career category
    EntitySubtype.colleague: 'colleague',
    EntitySubtype.work: 'work',
    
    // Travel category
    EntitySubtype.trip: 'trip',
    
    // Health category
    EntitySubtype.beautySalon: 'beauty_salon',
    EntitySubtype.dentist: 'dentist',
    EntitySubtype.doctor: 'doctor',
    EntitySubtype.stylist: 'stylist',
    EntitySubtype.therapist: 'therapist',
    EntitySubtype.physiotherapist: 'physiotherapist',
    EntitySubtype.specialist: 'specialist',
    EntitySubtype.surgeon: 'surgeon',
    
    // Home category
    EntitySubtype.appliance: 'appliance',
    EntitySubtype.contractor: 'contractor',
    EntitySubtype.furniture: 'furniture',
    EntitySubtype.home: 'home',
    EntitySubtype.room: 'room',
    
    // Garden category
    EntitySubtype.tool: 'tool',
    EntitySubtype.plant: 'plant',
    
    // Food category
    EntitySubtype.foodPlan: 'food_plan',
    EntitySubtype.recipe: 'recipe',
    EntitySubtype.restaurant: 'restaurant',
    
    // Laundry category
    EntitySubtype.dryCleaners: 'dry_cleaners',
    EntitySubtype.item: 'item',
    
    // Finance category
    EntitySubtype.bank: 'bank',
    EntitySubtype.bankAccount: 'bank_account',
    EntitySubtype.creditCard: 'credit_card',
    
    // Transport category
    EntitySubtype.boat: 'vehicle_boat',
    EntitySubtype.car: 'vehicle_car',
    EntitySubtype.vehicleCar: 'vehicle_car',
    EntitySubtype.publicTransport: 'public_transport',
    EntitySubtype.motorcycle: 'motorcycle',
    EntitySubtype.bicycle: 'bicycle',
    EntitySubtype.truck: 'truck',
    EntitySubtype.van: 'van',
    EntitySubtype.rv: 'rv',
    EntitySubtype.atv: 'atv',
    EntitySubtype.jetSki: 'jet_ski',
    
    // Documents category
    EntitySubtype.document: 'document',
    EntitySubtype.passport: 'passport',
    EntitySubtype.license: 'license',
    EntitySubtype.bankStatement: 'bank_statement',
    EntitySubtype.taxDocument: 'tax_document',
    EntitySubtype.contract: 'contract',
    EntitySubtype.will: 'will',
    EntitySubtype.medicalRecord: 'medical_record',
    EntitySubtype.prescription: 'prescription',
    EntitySubtype.resume: 'resume',
    EntitySubtype.certificate: 'certificate',
  };
  
  // Map from display name to EntitySubtype - useful for reverse lookup
  static final Map<String, EntitySubtype> displayNameToEnum = {
    'Pet': EntitySubtype.pet,
    'Vet': EntitySubtype.vet,
    'Pet Walker': EntitySubtype.walker,
    'Pet Groomer': EntitySubtype.groomer,
    'Pet Sitter': EntitySubtype.sitter,
    'Microchip Company': EntitySubtype.microchipCompany,
    'Pet Insurance Company': EntitySubtype.insuranceCompany,
    'Pet Insurance Policy': EntitySubtype.insurancePolicy,
    
    'Event': EntitySubtype.event,
    'Hobby': EntitySubtype.hobby,
    'Holiday': EntitySubtype.holiday,
    'Holiday Plan': EntitySubtype.holidayPlan,
    'Social Plan': EntitySubtype.socialPlan,
    'Social Media': EntitySubtype.socialMedia,
    'Anniversary Plan': EntitySubtype.anniversaryPlan,
    'Birthday': EntitySubtype.birthday,
    'Anniversary': EntitySubtype.anniversary,
    'Guest List Invite': EntitySubtype.guestListInvite,
    
    // Add more mappings for all entity types as needed
  };
  
  // Map from database entity_type_id to EntitySubtype - useful for parsing database values
  static final Map<String, EntitySubtype> dbIdToEnum = {
    'pet': EntitySubtype.pet,
    'vet': EntitySubtype.vet,
    'walker': EntitySubtype.walker,
    'groomer': EntitySubtype.groomer,
    'sitter': EntitySubtype.sitter,
    'microchip_company': EntitySubtype.microchipCompany,
    'insurance_company_pet': EntitySubtype.insuranceCompany,
    'insurance_policy_pet': EntitySubtype.insurancePolicy,
    
    'event': EntitySubtype.event,
    'hobby': EntitySubtype.hobby,
    'social_media': EntitySubtype.socialMedia,
    'social_plan': EntitySubtype.socialPlan,
    'anniversary': EntitySubtype.anniversary,
    'anniversary_plan': EntitySubtype.anniversaryPlan,
    'birthday': EntitySubtype.birthday,
    'holiday': EntitySubtype.holiday,
    'holiday_plan': EntitySubtype.holidayPlan,
    'guest_list_invite': EntitySubtype.guestListInvite,
    
    // Add more mappings for all entity types as needed
  };
  
  static String getEntityTypeId(EntitySubtype subtype) {
    final typeId = entityTypeIdMapping[subtype];
    if (typeId == null) {
      // print('⚠️ WARNING: No entity_type_id mapping found for subtype: ${subtype.toString()}');
      
      // Convert the enum value to snake_case to try to match database format
      final enumName = subtype.toString().split('.').last;
      final snakeCaseName = enumName.replaceAllMapped(
          RegExp(r'([A-Z])'), 
          (match) => match.start > 0 ? '_${match.group(0)!.toLowerCase()}' : match.group(0)!.toLowerCase()
      );
      
      // print('🔍 Trying fallback snake_case mapping: $snakeCaseName');

      // Return the converted name as a fallback
      return snakeCaseName;
    }
    return typeId;
  }
  
  static int getCategoryId(EntitySubtype subtype) {
    // Use the mapping or default to social category (2) if not found
    return categoryMapping[subtype] ?? 2;
  }
  
  static List<EntitySubtype> getEntityTypesForCategory(int categoryId) {
    return categoryMapping.entries
        .where((entry) => entry.value == categoryId)
        .map((entry) => entry.key)
        .toList();
  }
  
  static String getDisplayName(EntitySubtype subtype) {
    // This should return the formatted display name, not the enum name
    switch (subtype) {
      case EntitySubtype.pet: return 'Pet';
      case EntitySubtype.vet: return 'Vet';
      case EntitySubtype.walker: return 'Pet Walker';
      case EntitySubtype.groomer: return 'Pet Groomer';
      case EntitySubtype.sitter: return 'Pet Sitter';
      case EntitySubtype.microchipCompany: return 'Microchip Company';
      case EntitySubtype.insuranceCompany: return 'Pet Insurance Company';
      case EntitySubtype.insurancePolicy: return 'Pet Insurance Policy';
      
      case EntitySubtype.event: return 'Event';
      case EntitySubtype.hobby: return 'Hobby';
      case EntitySubtype.socialMedia: return 'Social Media';
      case EntitySubtype.socialPlan: return 'Social Plan';
      case EntitySubtype.anniversary: return 'Anniversary';
      case EntitySubtype.anniversaryPlan: return 'Anniversary Plan';
      case EntitySubtype.birthday: return 'Birthday';
      case EntitySubtype.holiday: return 'Holiday';
      case EntitySubtype.holidayPlan: return 'Holiday Plan';
      case EntitySubtype.guestListInvite: return 'Guest List Invite';
      
      // Add cases for all other entity types
      default:
        // Convert camelCase to Title Case with spaces
        return subtype.toString().split('.').last
            .replaceAllMapped(
                RegExp(r'([A-Z])'),
                (match) => match.start > 0 ? ' ${match.group(0)}' : match.group(0)!
            );
    }
  }

  // Helper method to diagnose entity type issues - can be called before saving
  static void diagnoseEntityType(EntitySubtype subtype) {
    // final entityTypeId = EntityTypeHelper.getEntityTypeId(subtype); // Removed unused variable
    // final categoryId = EntityTypeHelper.getCategoryId(subtype); // Removed unused variable
    // final displayName = EntityTypeHelper.getDisplayName(subtype); // Removed unused variable
    
    // print('🔍 DIAGNOSIS for ${subtype.toString()}:');
    // print('  - Display name: "$displayName"');
    // print('  - entity_type_id to save: "$entityTypeId"');
    // print('  - app_category_id: $categoryId');
    // print('  - Original enum value: ${subtype.toString().split('.').last}');
  }
  
  // Parse entity subtype from database id - useful when loading from DB
  static EntitySubtype parseFromTypeId(String? typeId) {
    if (typeId == null) {
      // print('⚠️ WARNING: Null entity_type_id, defaulting to event');
      return EntitySubtype.event;
    }
    
    final subtype = dbIdToEnum[typeId];
    if (subtype != null) {
      return subtype;
    }
    
    // Try to match by camelCase conversion
    final camelCase = typeId.replaceAllMapped(
        RegExp(r'_([a-z])'),
        (match) => match.group(1)!.toUpperCase()
    );
    
    try {
      return EntitySubtype.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == camelCase.toLowerCase()
      );
    } catch (e) {
      // print('⚠️ WARNING: Could not parse entity_type_id: $typeId, defaulting to event');
      return EntitySubtype.event;
    }
  }
}

// Update the toJson method if needed
extension BaseEntityModelExtensions on BaseEntityModel {
  // Helper method to get app category ID from entity subtype if needed
  int? getAppCategoryId() {
    return appCategoryId ?? EntityTypeHelper.getCategoryId(subtype);
  }
  
  // Method to create a map for Supabase (handles fields that need special conversion)
  Map<String, dynamic> toSupabaseJson() {
    final json = toJson();
    
    // Add diagnostic information 
    EntityTypeHelper.diagnoseEntityType(subtype);
    
    // Generate UUID if id is null
    if (json['id'] == null) {
      // Use Supabase's UUID format (matches database)
      json['id'] = const Uuid().v4();
    }
    
    // Ensure app_category_id is included
    if (json['app_category_id'] == null) {
      json['app_category_id'] = EntityTypeHelper.getCategoryId(subtype);
    }
    
    // Get entity_type_id value (the database key format) using a direct mapping
    // This ensures we get the exact database ID regardless of the JsonValue annotation
    final entityTypeId = EntityTypeHelper.getEntityTypeId(subtype);
    
    // print('🔍 DEBUG - Entity subtype: ${subtype.toString()}');
    // print('🔍 DEBUG - Setting entity_type_id: $entityTypeId');
    
    // Set the required entity_type_id field from the direct mapping
    json['entity_type_id'] = entityTypeId;
    
    // Remove category_id if it exists since this field doesn't exist in the database schema
    json.remove('category_id');
    
    // Make sure field names match database column names
    if (json.containsKey('imageUrl')) {
      json['image_url'] = json.remove('imageUrl');
    }
    
    if (json.containsKey('parentId')) {
      json['parent_id'] = json.remove('parentId');
    }
    
    if (json.containsKey('isHidden')) {
      json['is_hidden'] = json.remove('isHidden');
    }
    
    // Ensure custom_fields is a valid JSONB value
    if (json.containsKey('custom_fields') && json['custom_fields'] != null) {
      // If custom_fields is empty, ensure it's an empty object, not null
      if (json['custom_fields'].isEmpty) {
        json['custom_fields'] = {};
      }
    } else {
      // Provide an empty object as default
      json['custom_fields'] = {};
    }
    
    // Handle the 'subtype' field - in database we need the display name, not the enum
    try {
      // Get the JsonValue annotation if it exists
      final subtypeString = _getSubtypeDisplayName();
      json['subtype'] = subtypeString;
    } catch (e) {
      // print('⚠️ Warning: Could not get JsonValue for subtype: $e');
      // Fallback to string representation
      json['subtype'] = subtype.toString().split('.').last;
    }
    
    return json;
  }
  
  // Helper to extract the JsonValue annotation for the EntitySubtype enum
  String _getSubtypeDisplayName() {
    // Get the JsonValue string or fallback to the enum name
    switch (subtype) {
      case EntitySubtype.pet: return 'Pet';
      case EntitySubtype.vet: return 'Vet';
      case EntitySubtype.walker: return 'Pet Walker';
      case EntitySubtype.groomer: return 'Pet Groomer';
      case EntitySubtype.sitter: return 'Pet Sitter';
      case EntitySubtype.microchipCompany: return 'Microchip Company';
      case EntitySubtype.insuranceCompany: return 'Pet Insurance Company';
      case EntitySubtype.insurancePolicy: return 'Pet Insurance Policy';
      
      case EntitySubtype.event: return 'Event';
      case EntitySubtype.hobby: return 'Hobby';
      case EntitySubtype.socialMedia: return 'Social Media';
      case EntitySubtype.socialPlan: return 'Social Plan';
      case EntitySubtype.anniversary: return 'Anniversary';
      case EntitySubtype.anniversaryPlan: return 'Anniversary Plan';
      case EntitySubtype.birthday: return 'Birthday';
      case EntitySubtype.holiday: return 'Holiday';
      case EntitySubtype.holidayPlan: return 'Holiday Plan';
      case EntitySubtype.guestListInvite: return 'Guest List Invite';
      
      // Add cases for all other EntitySubtype values...
      default:
        // Just return the enum name without the enum type prefix
        return subtype.toString().split('.').last;
    }
  }
}
