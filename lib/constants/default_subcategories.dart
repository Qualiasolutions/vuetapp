import 'package:vuet_app/models/entity_subcategory_model.dart';

// Default subcategories, aligned with vuet-complete-model.md from memory-bank.
// Icons and colors are placeholders or inherited where not specified.

// Helper to create placeholder icon paths
String _iconPath(String subcatName) => 'assets/images/categories/sub_${subcatName.toLowerCase().replaceAll(' ', '_')}.png';

// --- PETS ---
final List<EntitySubcategoryModel> petSubcategories = [
  EntitySubcategoryModel(
    id: 'pet',
    categoryId: 'pets',
    name: 'pet',
    displayName: 'Pet',
    icon: _iconPath('pet'),
    color: '#8D6E63',
    entityTypeIds: ['Pet'], // Main Pet entity
    tagName: 'pet',
  ),
  // Specific Pet Types - assuming these are UI sugar and map to the 'Pet' entity type,
  // potentially pre-filling a 'kind' field.
  EntitySubcategoryModel(id: 'pets_bird', categoryId: 'pets', name: 'bird', displayName: 'Bird', icon: _iconPath('bird'), color: '#8D6E63', entityTypeIds: ['Pet'], tagName: 'bird'),
  EntitySubcategoryModel(id: 'pets_cat', categoryId: 'pets', name: 'cat', displayName: 'Cat', icon: _iconPath('cat'), color: '#8D6E63', entityTypeIds: ['Pet'], tagName: 'cat'),
  EntitySubcategoryModel(id: 'pets_dog', categoryId: 'pets', name: 'dog', displayName: 'Dog', icon: _iconPath('dog'), color: '#8D6E63', entityTypeIds: ['Pet'], tagName: 'dog'),
  EntitySubcategoryModel(id: 'pets_fish', categoryId: 'pets', name: 'fish', displayName: 'Fish', icon: _iconPath('fish'), color: '#8D6E63', entityTypeIds: ['Pet'], tagName: 'fish'),
  EntitySubcategoryModel(id: 'pets_other_pet', categoryId: 'pets', name: 'other_pet', displayName: 'Other Pet', icon: _iconPath('other_pet'), color: '#8D6E63', entityTypeIds: ['Pet'], tagName: 'other_pet'),

  EntitySubcategoryModel(
    id: 'vet',
    categoryId: 'pets',
    name: 'vet',
    displayName: 'Vet',
    icon: _iconPath('vet'),
    color: '#8D6E63',
    entityTypeIds: ['Vet'],
    tagName: 'vet',
  ),
  EntitySubcategoryModel(
    id: 'pet_walker', // Assuming 'Walker' from docs means 'PetWalker'
    categoryId: 'pets',
    name: 'pet_walker',
    displayName: 'Pet Walker',
    icon: _iconPath('pet_walker'),
    color: '#8D6E63',
    entityTypeIds: ['Walker'], // React name was 'Walker'
    tagName: 'pet_walker',
  ),
  EntitySubcategoryModel(
    id: 'pet_groomer', // Assuming 'Groomer' from docs means 'PetGroomer'
    categoryId: 'pets',
    name: 'pet_groomer',
    displayName: 'Pet Groomer',
    icon: _iconPath('pet_groomer'),
    color: '#8D6E63',
    entityTypeIds: ['Groomer'], // React name was 'Groomer'
    tagName: 'pet_groomer',
  ),
  EntitySubcategoryModel(
    id: 'pet_sitter', // Assuming 'Sitter' from docs means 'PetSitter'
    categoryId: 'pets',
    name: 'pet_sitter',
    displayName: 'Pet Sitter',
    icon: _iconPath('pet_sitter'),
    color: '#8D6E63',
    entityTypeIds: ['Sitter'], // React name was 'Sitter'
    tagName: 'pet_sitter',
  ),
  EntitySubcategoryModel(
    id: 'microchip_company',
    categoryId: 'pets',
    name: 'microchip_company',
    displayName: 'Microchip Company',
    icon: _iconPath('microchip_company'),
    color: '#8D6E63',
    entityTypeIds: ['MicrochipCompany'],
    tagName: 'microchip_company',
  ),
  EntitySubcategoryModel(
    id: 'insurance_company',
    categoryId: 'pets',
    name: 'insurance_company',
    displayName: 'Insurance Company (Pet)',
    icon: _iconPath('insurance_company_pet'),
    color: '#8D6E63',
    entityTypeIds: ['InsuranceCompany'], // Generic name, context implies pet
    tagName: 'insurance_company_pet',
  ),
  EntitySubcategoryModel(
    id: 'insurance_policy',
    categoryId: 'pets',
    name: 'insurance_policy',
    displayName: 'Insurance Policy (Pet)',
    icon: _iconPath('insurance_policy_pet'),
    color: '#8D6E63',
    entityTypeIds: ['InsurancePolicy'], // Generic name, context implies pet
    tagName: 'insurance_policy_pet',
  ),
   EntitySubcategoryModel( // Kept from previous version, assuming it's a valid distinct type
    id: 'pet_birthday',
    categoryId: 'pets',
    name: 'pet_birthday',
    displayName: 'Pet Birthday',
    icon: _iconPath('pet_birthday'),
    color: '#8D6E63',
    entityTypeIds: ['PetBirthday'],
    tagName: 'pet_birthday',
  ),
];

// --- SOCIAL INTERESTS ---
final List<EntitySubcategoryModel> socialInterestsSubcategories = [
  EntitySubcategoryModel(
    id: 'event',
    categoryId: 'social_interests',
    name: 'event',
    displayName: 'Event',
    icon: _iconPath('event'),
    color: '#EC407A',
    entityTypeIds: ['Event'],
    tagName: 'event',
  ),
  EntitySubcategoryModel(
    id: 'hobby',
    categoryId: 'social_interests',
    name: 'hobby',
    displayName: 'Hobby',
    icon: _iconPath('hobby'),
    color: '#EC407A',
    entityTypeIds: ['Hobby'],
    tagName: 'hobby',
  ),
  EntitySubcategoryModel( // From previous default_subcategories
    id: 'holiday',
    categoryId: 'social_interests', // Note: 'Holiday' also under Travel in vuet-complete-model.md
    name: 'holiday',
    displayName: 'Holiday (Social)',
    icon: _iconPath('holiday_social'),
    color: '#EC407A',
    entityTypeIds: ['Holiday'],
    tagName: 'holiday_social',
  ),
  EntitySubcategoryModel(
    id: 'holiday_plan',
    categoryId: 'social_interests',
    name: 'holiday_plan',
    displayName: 'Holiday Plan (Social)',
    icon: _iconPath('holiday_plan_social'),
    color: '#EC407A',
    entityTypeIds: ['HolidayPlan'],
    tagName: 'holiday_plan_social',
  ),
  EntitySubcategoryModel(
    id: 'social_plan',
    categoryId: 'social_interests',
    name: 'social_plan',
    displayName: 'Social Plan',
    icon: _iconPath('social_plan'),
    color: '#EC407A',
    entityTypeIds: ['SocialPlan'],
    tagName: 'social_plan',
  ),
  EntitySubcategoryModel(
    id: 'social_media',
    categoryId: 'social_interests',
    name: 'social_media',
    displayName: 'Social Media',
    icon: _iconPath('social_media'),
    color: '#EC407A',
    entityTypeIds: ['SocialMedia'],
    tagName: 'social_media',
  ),
  EntitySubcategoryModel(
    id: 'anniversary_plan',
    categoryId: 'social_interests',
    name: 'anniversary_plan',
    displayName: 'Anniversary Plan',
    icon: _iconPath('anniversary_plan'),
    color: '#EC407A',
    entityTypeIds: ['AnniversaryPlan'],
    tagName: 'anniversary_plan',
  ),
  EntitySubcategoryModel(
    id: 'birthday',
    categoryId: 'social_interests',
    name: 'birthday',
    displayName: 'Birthday',
    icon: _iconPath('birthday'),
    color: '#EC407A',
    entityTypeIds: ['Birthday'],
    tagName: 'birthday',
  ),
  EntitySubcategoryModel(
    id: 'anniversary',
    categoryId: 'social_interests',
    name: 'anniversary',
    displayName: 'Anniversary',
    icon: _iconPath('anniversary'),
    color: '#EC407A',
    entityTypeIds: ['Anniversary'],
    tagName: 'anniversary',
  ),
  EntitySubcategoryModel(
    id: 'event_subentity',
    categoryId: 'social_interests',
    name: 'event_subentity',
    displayName: 'Event Subentity',
    icon: _iconPath('event_subentity'),
    color: '#EC407A',
    entityTypeIds: ['EventSubentity'],
    tagName: 'event_subentity',
  ),
  EntitySubcategoryModel(
    id: 'guest_list_invite',
    categoryId: 'social_interests',
    name: 'guest_list_invite',
    displayName: 'Guest List Invite',
    icon: _iconPath('guest_list_invite'),
    color: '#EC407A',
    entityTypeIds: ['GuestListInvite'],
    tagName: 'guest_list_invite',
  ),
];

// --- EDUCATION ---
// Note: SchoolYear, SchoolTerm, SchoolBreak were not 'Entities' in vuet-complete-model
// but are included here as they were in default_subcategories and might be needed for UI.
// Their entityTypeIds reflect this potential special handling.
final List<EntitySubcategoryModel> educationSubcategories = [
  EntitySubcategoryModel(
    id: 'school',
    categoryId: 'education',
    name: 'school',
    displayName: 'School',
    icon: _iconPath('school'),
    color: '#26A69A',
    entityTypeIds: ['School'],
    tagName: 'school',
  ),
  EntitySubcategoryModel(
    id: 'subject',
    categoryId: 'education',
    name: 'subject',
    displayName: 'Subject',
    icon: _iconPath('subject'),
    color: '#26A69A',
    entityTypeIds: ['Subject'],
    tagName: 'subject',
  ),
  EntitySubcategoryModel(
    id: 'course_work',
    categoryId: 'education',
    name: 'course_work',
    displayName: 'Course Work',
    icon: _iconPath('course_work'),
    color: '#26A69A',
    entityTypeIds: ['CourseWork'],
    tagName: 'course_work',
  ),
  EntitySubcategoryModel(
    id: 'teacher',
    categoryId: 'education',
    name: 'teacher',
    displayName: 'Teacher',
    icon: _iconPath('teacher'),
    color: '#26A69A',
    entityTypeIds: ['Teacher'],
    tagName: 'teacher',
  ),
  EntitySubcategoryModel(
    id: 'tutor',
    categoryId: 'education',
    name: 'tutor',
    displayName: 'Tutor',
    icon: _iconPath('tutor'),
    color: '#26A69A',
    entityTypeIds: ['Tutor'],
    tagName: 'tutor',
  ),
  EntitySubcategoryModel(
    id: 'academic_plan',
    categoryId: 'education',
    name: 'academic_plan',
    displayName: 'Academic Plan',
    icon: _iconPath('academic_plan'),
    color: '#26A69A',
    entityTypeIds: ['AcademicPlan'],
    tagName: 'academic_plan',
  ),
  EntitySubcategoryModel(
    id: 'extracurricular_plan',
    categoryId: 'education',
    name: 'extracurricular_plan',
    displayName: 'Extracurricular Plan',
    icon: _iconPath('extracurricular_plan'),
    color: '#26A69A',
    entityTypeIds: ['ExtracurricularPlan'],
    tagName: 'extracurricular_plan',
  ),
  EntitySubcategoryModel(
    id: 'student',
    categoryId: 'education',
    name: 'student',
    displayName: 'Student',
    icon: _iconPath('student'),
    color: '#26A69A',
    entityTypeIds: ['Student'],
    tagName: 'student',
  ),
  // Entries from previous default_subcategories, potentially non-standard entities
  EntitySubcategoryModel(id: 'school_break', categoryId: 'education', name: 'school_break', displayName: 'School Break', icon: _iconPath('school_break'), color: '#26A69A', entityTypeIds: ['SchoolBreak'], tagName: 'school_break'),
  EntitySubcategoryModel(id: 'school_term', categoryId: 'education', name: 'school_term', displayName: 'School Term', icon: _iconPath('school_term'), color: '#26A69A', entityTypeIds: ['SchoolTerm'], tagName: 'school_term'),
  EntitySubcategoryModel(id: 'school_term_end', categoryId: 'education', name: 'school_term_end', displayName: 'School Term End', icon: _iconPath('school_term_end'), color: '#26A69A', entityTypeIds: ['SchoolTermEnd'], tagName: 'school_term_end'),
  EntitySubcategoryModel(id: 'school_term_start', categoryId: 'education', name: 'school_term_start', displayName: 'School Term Start', icon: _iconPath('school_term_start'), color: '#26A69A', entityTypeIds: ['SchoolTermStart'], tagName: 'school_term_start'),
  EntitySubcategoryModel(id: 'school_year_end', categoryId: 'education', name: 'school_year_end', displayName: 'School Year End', icon: _iconPath('school_year_end'), color: '#26A69A', entityTypeIds: ['SchoolYearEnd'], tagName: 'school_year_end'),
  EntitySubcategoryModel(id: 'school_year_start', categoryId: 'education', name: 'school_year_start', displayName: 'School Year Start', icon: _iconPath('school_year_start'), color: '#26A69A', entityTypeIds: ['SchoolYearStart'], tagName: 'school_year_start'),
];

// --- CAREER ---
final List<EntitySubcategoryModel> careerSubcategories = [
  EntitySubcategoryModel(
    id: 'work',
    categoryId: 'career',
    name: 'work',
    displayName: 'Work',
    icon: _iconPath('work'),
    color: '#42A5F5',
    entityTypeIds: ['Work'],
    tagName: 'work',
  ),
  EntitySubcategoryModel(
    id: 'colleague',
    categoryId: 'career',
    name: 'colleague',
    displayName: 'Colleague',
    icon: _iconPath('colleague'),
    color: '#42A5F5',
    entityTypeIds: ['Colleague'],
    tagName: 'colleague',
  ),
  // Entries from previous default_subcategories
  EntitySubcategoryModel(id: 'career_goal', categoryId: 'career', name: 'career_goal', displayName: 'Career Goal', icon: _iconPath('career_goal'), color: '#42A5F5', entityTypeIds: ['CareerGoal'], tagName: 'career_goal'),
  EntitySubcategoryModel(id: 'days_off', categoryId: 'career', name: 'days_off', displayName: 'Days Off', icon: _iconPath('days_off'), color: '#42A5F5', entityTypeIds: ['DaysOff'], tagName: 'days_off'),
  EntitySubcategoryModel(id: 'employee', categoryId: 'career', name: 'employee', displayName: 'Employee', icon: _iconPath('employee'), color: '#42A5F5', entityTypeIds: ['Employee'], tagName: 'employee'),
];

// --- TRAVEL ---
final List<EntitySubcategoryModel> travelSubcategories = [
  EntitySubcategoryModel(
    id: 'trip',
    categoryId: 'travel',
    name: 'trip',
    displayName: 'Trip',
    icon: _iconPath('trip'),
    color: '#7E57C2',
    entityTypeIds: ['Trip'],
    tagName: 'trip',
  ),
  // Entries from previous default_subcategories, may overlap or be specific aspects of Trip
  EntitySubcategoryModel(id: 'accommodations', categoryId: 'travel', name: 'accommodations', displayName: 'Accommodations', icon: 'hotel', color: '#FF8C00', entityTypeIds: ['ACCOMMODATION'], tagName: 'accommodation'), // Generic
  EntitySubcategoryModel(id: 'attractions', categoryId: 'travel', name: 'attractions', displayName: 'Attractions', icon: 'photo_camera', color: '#FF8C00', entityTypeIds: ['PLACE'], tagName: 'attraction'), // Generic
  EntitySubcategoryModel(id: 'drive_time', categoryId: 'travel', name: 'drive_time', displayName: 'Drive Time', icon: _iconPath('drive_time'), color: '#7E57C2', entityTypeIds: ['DriveTime'], tagName: 'drive_time'),
  EntitySubcategoryModel(id: 'flight', categoryId: 'travel', name: 'flight', displayName: 'Flight', icon: _iconPath('flight'), color: '#7E57C2', entityTypeIds: ['Flight'], tagName: 'flight'),
  EntitySubcategoryModel(id: 'holiday_travel', categoryId: 'travel', name: 'holiday_travel', displayName: 'Holiday (Travel)', icon: _iconPath('holiday_travel'), color: '#7E57C2', entityTypeIds: ['Holiday'], tagName: 'holiday_travel'), // differentiate from social Holiday
  EntitySubcategoryModel(id: 'holiday_plan_travel', categoryId: 'travel', name: 'holiday_plan_travel', displayName: 'Holiday Plan (Travel)', icon: _iconPath('holiday_plan_travel'), color: '#7E57C2', entityTypeIds: ['HolidayPlan'], tagName: 'holiday_plan_travel'),
  EntitySubcategoryModel(id: 'hotel_or_rental', categoryId: 'travel', name: 'hotel_or_rental', displayName: 'Hotel Or Rental', icon: _iconPath('hotel_or_rental'), color: '#7E57C2', entityTypeIds: ['HotelOrRental'], tagName: 'hotel_or_rental'),
  EntitySubcategoryModel(id: 'rental_car', categoryId: 'travel', name: 'rental_car', displayName: 'Rental Car', icon: _iconPath('rental_car'), color: '#7E57C2', entityTypeIds: ['RentalCar'], tagName: 'rental_car'),
  EntitySubcategoryModel(id: 'stay_with_friend', categoryId: 'travel', name: 'stay_with_friend', displayName: 'Stay With Friend', icon: _iconPath('stay_with_friend'), color: '#7E57C2', entityTypeIds: ['StayWithFriend'], tagName: 'stay_with_friend'),
  EntitySubcategoryModel(id: 'taxi_or_transfer', categoryId: 'travel', name: 'taxi_or_transfer', displayName: 'Taxi Or Transfer', icon: _iconPath('taxi_or_transfer'), color: '#7E57C2', entityTypeIds: ['TaxiOrTransfer'], tagName: 'taxi_or_transfer'),
  EntitySubcategoryModel(id: 'train_bus_ferry', categoryId: 'travel', name: 'train_bus_ferry', displayName: 'Train Bus Ferry', icon: _iconPath('train_bus_ferry'), color: '#7E57C2', entityTypeIds: ['TrainBusFerry'], tagName: 'train_bus_ferry'),
  EntitySubcategoryModel(id: 'travel_plan', categoryId: 'travel', name: 'travel_plan', displayName: 'Travel Plan', icon: _iconPath('travel_plan'), color: '#7E57C2', entityTypeIds: ['TravelPlan'], tagName: 'travel_plan'),
];

// --- HEALTH & BEAUTY ---
final List<EntitySubcategoryModel> healthBeautySubcategories = [
  EntitySubcategoryModel(
    id: 'doctor',
    categoryId: 'health_beauty',
    name: 'doctor',
    displayName: 'Doctor',
    icon: _iconPath('doctor'),
    color: '#66BB6A',
    entityTypeIds: ['Doctor'],
    tagName: 'doctor',
  ),
  EntitySubcategoryModel(
    id: 'dentist',
    categoryId: 'health_beauty',
    name: 'dentist',
    displayName: 'Dentist',
    icon: _iconPath('dentist'),
    color: '#66BB6A',
    entityTypeIds: ['Dentist'],
    tagName: 'dentist',
  ),
  EntitySubcategoryModel(
    id: 'beauty_salon',
    categoryId: 'health_beauty',
    name: 'beauty_salon',
    displayName: 'Beauty Salon',
    icon: _iconPath('beauty_salon'),
    color: '#66BB6A',
    entityTypeIds: ['BeautySalon'],
    tagName: 'beauty_salon',
  ),
  EntitySubcategoryModel(
    id: 'stylist',
    categoryId: 'health_beauty',
    name: 'stylist',
    displayName: 'Stylist',
    icon: _iconPath('stylist'),
    color: '#66BB6A',
    entityTypeIds: ['Stylist'],
    tagName: 'stylist',
  ),
  // Entries from previous default_subcategories
  EntitySubcategoryModel(id: 'appointment', categoryId: 'health_beauty', name: 'appointment', displayName: 'Appointment', icon: _iconPath('appointment'), color: '#66BB6A', entityTypeIds: ['Appointment'], tagName: 'appointment'),
  EntitySubcategoryModel(id: 'beauty_generic', categoryId: 'health_beauty', name: 'beauty_generic', displayName: 'Beauty (Generic)', icon: 'spa', color: '#9370DB', entityTypeIds: ['BEAUTY'], tagName: 'beauty_generic'), // Generic
  EntitySubcategoryModel(id: 'fitness_activity', categoryId: 'health_beauty', name: 'fitness_activity', displayName: 'Fitness Activity', icon: 'fitness_center', color: '#9370DB', entityTypeIds: ['FITNESS_ACTIVITY'], tagName: 'fitness_activity'), // Generic
  EntitySubcategoryModel(id: 'health_goal', categoryId: 'health_beauty', name: 'health_goal', displayName: 'Health Goal', icon: _iconPath('health_goal'), color: '#66BB6A', entityTypeIds: ['HealthGoal'], tagName: 'health_goal'),
  EntitySubcategoryModel(id: 'medical_generic', categoryId: 'health_beauty', name: 'medical_generic', displayName: 'Medical (Generic)', icon: 'local_hospital', color: '#9370DB', entityTypeIds: ['MEDICAL'], tagName: 'medical_generic'), // Generic
  EntitySubcategoryModel(id: 'patient', categoryId: 'health_beauty', name: 'patient', displayName: 'Patient', icon: _iconPath('patient'), color: '#66BB6A', entityTypeIds: ['Patient'], tagName: 'patient'),
];

// --- HOME ---
final List<EntitySubcategoryModel> homeSubcategories = [
  EntitySubcategoryModel(
    id: 'home',
    categoryId: 'home',
    name: 'home',
    displayName: 'Home (Property)',
    icon: _iconPath('home_property'),
    color: '#FF7043',
    entityTypeIds: ['Home'], // This is the main 'Home' entity from vuet-complete-model
    tagName: 'home_property',
  ),
  EntitySubcategoryModel(
    id: 'room',
    categoryId: 'home',
    name: 'room',
    displayName: 'Room',
    icon: _iconPath('room'),
    color: '#FF7043',
    entityTypeIds: ['Room'],
    tagName: 'room',
  ),
  EntitySubcategoryModel(
    id: 'furniture',
    categoryId: 'home',
    name: 'furniture',
    displayName: 'Furniture',
    icon: _iconPath('furniture'),
    color: '#FF7043',
    entityTypeIds: ['Furniture'],
    tagName: 'furniture',
  ),
  EntitySubcategoryModel(
    id: 'appliance',
    categoryId: 'home',
    name: 'appliance',
    displayName: 'Appliance',
    icon: _iconPath('appliance'),
    color: '#FF7043',
    entityTypeIds: ['Appliance'],
    tagName: 'appliance',
  ),
  EntitySubcategoryModel(
    id: 'contractor',
    categoryId: 'home',
    name: 'contractor',
    displayName: 'Contractor',
    icon: _iconPath('contractor'),
    color: '#FF7043',
    entityTypeIds: ['Contractor'],
    tagName: 'contractor',
  ),
  // Entries from previous default_subcategories
  EntitySubcategoryModel(id: 'cleaning_home', categoryId: 'home', name: 'cleaning_home', displayName: 'Cleaning (Home)', icon: 'cleaning_services', color: '#FF7043', entityTypeIds: ['CLEANING'], tagName: 'cleaning_home'), // Generic
  EntitySubcategoryModel(id: 'cooking_home', categoryId: 'home', name: 'cooking_home', displayName: 'Cooking (Home)', icon: 'restaurant', color: '#FF7043', entityTypeIds: ['COOKING'], tagName: 'cooking_home'), // Generic
  EntitySubcategoryModel(id: 'home_maintenance_tasks', categoryId: 'home', name: 'home_maintenance_tasks', displayName: 'Home Maintenance Tasks', icon: 'home_repair_service', color: '#FF7043', entityTypeIds: ['HOME_MAINTENANCE'], tagName: 'home_maintenance_tasks'), // Generic
];

// --- GARDEN ---
final List<EntitySubcategoryModel> gardenSubcategories = [
  EntitySubcategoryModel(
    id: 'plant',
    categoryId: 'garden',
    name: 'plant',
    displayName: 'Plant',
    icon: _iconPath('plant'),
    color: '#8BC34A',
    entityTypeIds: ['Plant'],
    tagName: 'plant',
  ),
  EntitySubcategoryModel(
    id: 'garden_tool', // 'Tool' from vuet-complete-model under Garden
    categoryId: 'garden',
    name: 'garden_tool',
    displayName: 'Garden Tool',
    icon: _iconPath('garden_tool'),
    color: '#8BC34A',
    entityTypeIds: ['Tool'], // React name 'Tool'
    tagName: 'garden_tool',
  ),
  // Entries from previous default_subcategories
  EntitySubcategoryModel(id: 'garden_generic', categoryId: 'garden', name: 'garden_generic', displayName: 'Garden (Generic)', icon: _iconPath('garden_generic'), color: '#8BC34A', entityTypeIds: ['Garden'], tagName: 'garden_generic'), // This was 'Garden' before, now made generic
  EntitySubcategoryModel(id: 'gardening_tasks', categoryId: 'garden', name: 'gardening_tasks', displayName: 'Gardening Tasks', icon: 'yard', color: '#8BC34A', entityTypeIds: ['GARDENING'], tagName: 'gardening_tasks'), // Generic
];

// --- FOOD ---
final List<EntitySubcategoryModel> foodSubcategories = [
  EntitySubcategoryModel(
    id: 'food_plan',
    categoryId: 'food',
    name: 'food_plan',
    displayName: 'Food Plan',
    icon: _iconPath('food_plan'),
    color: '#FF9800',
    entityTypeIds: ['FoodPlan'],
    tagName: 'food_plan',
  ),
  EntitySubcategoryModel(
    id: 'recipe',
    categoryId: 'food',
    name: 'recipe',
    displayName: 'Recipe',
    icon: _iconPath('recipe'),
    color: '#FF9800',
    entityTypeIds: ['Recipe'],
    tagName: 'recipe',
  ),
  EntitySubcategoryModel(
    id: 'restaurant',
    categoryId: 'food',
    name: 'restaurant',
    displayName: 'Restaurant',
    icon: _iconPath('restaurant'),
    color: '#FF9800',
    entityTypeIds: ['Restaurant'],
    tagName: 'restaurant',
  ),
  // Entry from previous default_subcategories
  EntitySubcategoryModel(id: 'food_generic', categoryId: 'food', name: 'food_generic', displayName: 'Food (Generic Item)', icon: _iconPath('food_generic'), color: '#FF9800', entityTypeIds: ['Food'], tagName: 'food_generic'), // This was 'Food' before
];

// --- LAUNDRY ---
final List<EntitySubcategoryModel> laundrySubcategories = [
  EntitySubcategoryModel(
    id: 'laundry_item', // 'Item' from vuet-complete-model under Laundry
    categoryId: 'laundry',
    name: 'laundry_item',
    displayName: 'Laundry Item',
    icon: _iconPath('laundry_item'),
    color: '#00BCD4',
    entityTypeIds: ['Item'], // React name 'Item'
    tagName: 'laundry_item',
  ),
  EntitySubcategoryModel(
    id: 'dry_cleaners',
    categoryId: 'laundry',
    name: 'dry_cleaners',
    displayName: 'Dry Cleaners',
    icon: _iconPath('dry_cleaners'),
    color: '#00BCD4',
    entityTypeIds: ['DryCleaners'],
    tagName: 'dry_cleaners',
  ),
  // Entries from previous default_subcategories
  EntitySubcategoryModel(id: 'clothing_laundry', categoryId: 'laundry', name: 'clothing_laundry', displayName: 'Clothing (Laundry)', icon: _iconPath('clothing_laundry'), color: '#00BCD4', entityTypeIds: ['Clothing'], tagName: 'clothing_laundry'), // May be same as Laundry Item or distinct
  EntitySubcategoryModel(id: 'laundry_plan', categoryId: 'laundry', name: 'laundry_plan', displayName: 'Laundry Plan', icon: _iconPath('laundry_plan'), color: '#00BCD4', entityTypeIds: ['LaundryPlan'], tagName: 'laundry_plan'),
];

// --- FINANCE ---
final List<EntitySubcategoryModel> financeSubcategories = [
  EntitySubcategoryModel(
    id: 'bank',
    categoryId: 'finance',
    name: 'bank',
    displayName: 'Bank',
    icon: _iconPath('bank'),
    color: '#FFCA28',
    entityTypeIds: ['Bank'],
    tagName: 'bank',
  ),
  EntitySubcategoryModel(
    id: 'credit_card',
    categoryId: 'finance',
    name: 'credit_card',
    displayName: 'Credit Card',
    icon: _iconPath('credit_card'),
    color: '#FFCA28',
    entityTypeIds: ['CreditCard'],
    tagName: 'credit_card',
  ),
  EntitySubcategoryModel(
    id: 'bank_account',
    categoryId: 'finance',
    name: 'bank_account',
    displayName: 'Bank Account',
    icon: _iconPath('bank_account'),
    color: '#FFCA28',
    entityTypeIds: ['BankAccount'],
    tagName: 'bank_account',
  ),
  // Entry from previous default_subcategories
  EntitySubcategoryModel(id: 'finance_generic', categoryId: 'finance', name: 'finance_generic', displayName: 'Finance (Generic)', icon: _iconPath('finance_generic'), color: '#FFCA28', entityTypeIds: ['Finance'], tagName: 'finance_generic'), // This was 'Finance' before
];

// --- TRANSPORT ---
final List<EntitySubcategoryModel> transportSubcategories = [
  EntitySubcategoryModel(
    id: 'cars_motorcycles',
    categoryId: 'transport',
    name: 'cars_motorcycles',
    displayName: 'Cars & Motorcycles',
    icon: _iconPath('car'), // Using car as representative icon
    color: '#607D8B',
    entityTypeIds: ['Car', 'Motorcycle'],
    tagName: 'cars_motorcycles',
  ),
  EntitySubcategoryModel(
    id: 'boats_and_others',
    categoryId: 'transport',
    name: 'boats_and_others',
    displayName: 'Boats & Other',
    icon: _iconPath('boat'),
    color: '#607D8B',
    entityTypeIds: ['Boat', 'JetSki', 'RV', 'ATV', 'Truck', 'Van', 'Bicycle'],
    tagName: 'boats_and_others',
  ),
  EntitySubcategoryModel(
    id: 'public_transport_cat', // Changed id to avoid conflict if 'public_transport' is also an EntitySubtype
    categoryId: 'transport',
    name: 'public_transport_cat',
    displayName: 'Public Transport',
    icon: _iconPath('public_transport'),
    color: '#607D8B',
    entityTypeIds: ['PublicTransport'], // Corrected to match EntitySubtype.publicTransport JsonValue
    tagName: 'public_transport_cat',
  ),
];

// Aggregated list of all default subcategories
final List<EntitySubcategoryModel> allDefaultSubcategories = [
  ...petSubcategories,
  ...socialInterestsSubcategories,
  ...educationSubcategories,
  ...careerSubcategories,
  ...travelSubcategories,
  ...healthBeautySubcategories,
  ...homeSubcategories,
  ...gardenSubcategories,
  ...foodSubcategories,
  ...laundrySubcategories,
  ...financeSubcategories,
  ...transportSubcategories,
];

// Map of all subcategories by category ID for easy access
final Map<String, List<EntitySubcategoryModel>> allSubcategories = {
  'pets': petSubcategories,
  'social_interests': socialInterestsSubcategories,
  'education': educationSubcategories,
  'career': careerSubcategories,
  'travel': travelSubcategories,
  'health_beauty': healthBeautySubcategories,
  'home': homeSubcategories,
  'garden': gardenSubcategories,
  'food': foodSubcategories,
  'laundry': laundrySubcategories,
  'finance': financeSubcategories,
  'transport': transportSubcategories,
  // For combined categories (if SubCategoryScreen is ever called with them directly as categoryId)
  // These might not be strictly necessary if SubCategoryScreen always receives the individual keys
  // in widget.subCategoryKeys and iterates as per its current logic.
  // However, including them for robustness if widget.categoryId could be a combined key.
  'education_career': [...educationSubcategories, ...careerSubcategories],
  'home_garden_food_laundry': [...homeSubcategories, ...gardenSubcategories, ...foodSubcategories, ...laundrySubcategories],
};
