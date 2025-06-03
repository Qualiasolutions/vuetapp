import 'package:vuet_app/models/entity_subcategory_model.dart';

// Default subcategories, integrating new ones from old codebase.
// Note: Icons like 'assets/images/categories/sub_*.png' are placeholders and need to be created.
// Colors are inherited from parent categories or use a default.
// Skipped entities due to category mapping issues:
// Skipping List (category: 'FAMILY') - category not mapped.

// Subcategories for pets
final List<EntitySubcategoryModel> petSubcategories = [
  EntitySubcategoryModel(
    id: 'pet',
    categoryId: 'pets',
    name: 'pet',
    displayName: 'Pet',
    icon: 'assets/images/categories/sub_pet.png', // Placeholder icon
    color: '#8D6E63',
    entityTypeIds: ['Pet'],
    tagName: 'pet',
  ),
  EntitySubcategoryModel(
    id: 'pet_birthday',
    categoryId: 'pets',
    name: 'pet_birthday',
    displayName: 'Pet Birthday',
    icon: 'assets/images/categories/sub_pet_birthday.png', // Placeholder icon
    color: '#8D6E63',
    entityTypeIds: ['PetBirthday'],
    tagName: 'pet_birthday',
  ),
  EntitySubcategoryModel(id: 'pets_birds', categoryId: 'pets', name: 'birds', displayName: 'Birds', icon: 'pets', color: '#8D6E63', entityTypeIds: ['PET'], tagName: 'bird',),
  EntitySubcategoryModel(id: 'pets_cats', categoryId: 'pets', name: 'cats', displayName: 'Cats', icon: 'pets', color: '#8D6E63', entityTypeIds: ['PET'], tagName: 'cat',),
  EntitySubcategoryModel(id: 'pets_dogs', categoryId: 'pets', name: 'dogs', displayName: 'Dogs', icon: 'pets', color: '#8D6E63', entityTypeIds: ['PET'], tagName: 'dog',),
  EntitySubcategoryModel(id: 'pets_fish', categoryId: 'pets', name: 'fish', displayName: 'Fish', icon: 'pets', color: '#8D6E63', entityTypeIds: ['PET'], tagName: 'fish',),
  EntitySubcategoryModel(id: 'pets_other', categoryId: 'pets', name: 'other_pets', displayName: 'Other Pets', icon: 'pets', color: '#8D6E63', entityTypeIds: ['PET'], tagName: 'other_pet',),
];

// Subcategories for social_interests
final List<EntitySubcategoryModel> socialInterestsSubcategories = [
  EntitySubcategoryModel(
    id: 'anniversary',
    categoryId: 'social_interests',
    name: 'anniversary',
    displayName: 'Anniversary',
    icon: 'assets/images/categories/sub_anniversary.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['Anniversary'],
    tagName: 'anniversary',
  ),
  EntitySubcategoryModel(
    id: 'anniversary_plan',
    categoryId: 'social_interests',
    name: 'anniversary_plan',
    displayName: 'Anniversary Plan',
    icon: 'assets/images/categories/sub_anniversary_plan.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['AnniversaryPlan'],
    tagName: 'anniversary_plan',
  ),
  EntitySubcategoryModel(
    id: 'birthday',
    categoryId: 'social_interests',
    name: 'birthday',
    displayName: 'Birthday',
    icon: 'assets/images/categories/sub_birthday.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['Birthday'],
    tagName: 'birthday',
  ),
  EntitySubcategoryModel(
    id: 'event',
    categoryId: 'social_interests',
    name: 'event',
    displayName: 'Event',
    icon: 'assets/images/categories/sub_event.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['Event'],
    tagName: 'event',
  ),
  EntitySubcategoryModel(
    id: 'event_subentity',
    categoryId: 'social_interests',
    name: 'event_subentity',
    displayName: 'Event Subentity',
    icon: 'assets/images/categories/sub_event_subentity.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['EventSubentity'],
    tagName: 'event_subentity',
  ),
  EntitySubcategoryModel(
    id: 'hobby',
    categoryId: 'social_interests',
    name: 'hobby',
    displayName: 'Hobby',
    icon: 'assets/images/categories/sub_hobby.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['Hobby'],
    tagName: 'hobby',
  ),
  EntitySubcategoryModel(id: 'social_media', categoryId: 'social_interests', name: 'social_media', displayName: 'Social Media', icon: 'assets/images/categories/sub_social_media.png', color: '#EC407A', entityTypeIds: ['SocialMedia'], tagName: 'social_media',),
  EntitySubcategoryModel(
    id: 'social_plan',
    categoryId: 'social_interests',
    name: 'social_plan',
    displayName: 'Social Plan',
    icon: 'assets/images/categories/sub_social_plan.png', // Placeholder icon
    color: '#EC407A',
    entityTypeIds: ['SocialPlan'],
    tagName: 'social_plan',
  ),
];

// Subcategories for education
final List<EntitySubcategoryModel> educationSubcategories = [
  EntitySubcategoryModel(
    id: 'academic_plan',
    categoryId: 'education',
    name: 'academic_plan',
    displayName: 'Academic Plan',
    icon: 'assets/images/categories/sub_academic_plan.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['AcademicPlan'],
    tagName: 'academic_plan',
  ),
  EntitySubcategoryModel(
    id: 'extracurricular_plan',
    categoryId: 'education',
    name: 'extracurricular_plan',
    displayName: 'Extracurricular Plan',
    icon: 'assets/images/categories/sub_extracurricular_plan.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['ExtracurricularPlan'],
    tagName: 'extracurricular_plan',
  ),
  EntitySubcategoryModel(
    id: 'school',
    categoryId: 'education',
    name: 'school',
    displayName: 'School',
    icon: 'assets/images/categories/sub_school.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['School'],
    tagName: 'school',
  ),
  EntitySubcategoryModel(
    id: 'school_break',
    categoryId: 'education',
    name: 'school_break',
    displayName: 'School Break',
    icon: 'assets/images/categories/sub_school_break.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolBreak'],
    tagName: 'school_break',
  ),
  EntitySubcategoryModel(
    id: 'school_term',
    categoryId: 'education',
    name: 'school_term',
    displayName: 'School Term',
    icon: 'assets/images/categories/sub_school_term.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolTerm'],
    tagName: 'school_term',
  ),
  EntitySubcategoryModel(
    id: 'school_term_end',
    categoryId: 'education',
    name: 'school_term_end',
    displayName: 'School Term End',
    icon: 'assets/images/categories/sub_school_term_end.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolTermEnd'],
    tagName: 'school_term_end',
  ),
  EntitySubcategoryModel(
    id: 'school_term_start',
    categoryId: 'education',
    name: 'school_term_start',
    displayName: 'School Term Start',
    icon: 'assets/images/categories/sub_school_term_start.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolTermStart'],
    tagName: 'school_term_start',
  ),
  EntitySubcategoryModel(
    id: 'school_year_end',
    categoryId: 'education',
    name: 'school_year_end',
    displayName: 'School Year End',
    icon: 'assets/images/categories/sub_school_year_end.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolYearEnd'],
    tagName: 'school_year_end',
  ),
  EntitySubcategoryModel(
    id: 'school_year_start',
    categoryId: 'education',
    name: 'school_year_start',
    displayName: 'School Year Start',
    icon: 'assets/images/categories/sub_school_year_start.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['SchoolYearStart'],
    tagName: 'school_year_start',
  ),
  EntitySubcategoryModel(
    id: 'student',
    categoryId: 'education',
    name: 'student',
    displayName: 'Student',
    icon: 'assets/images/categories/sub_student.png', // Placeholder icon
    color: '#26A69A',
    entityTypeIds: ['Student'],
    tagName: 'student',
  ),
];

// Subcategories for career
final List<EntitySubcategoryModel> careerSubcategories = [
  EntitySubcategoryModel(
    id: 'career_goal',
    categoryId: 'career',
    name: 'career_goal',
    displayName: 'Career Goal',
    icon: 'assets/images/categories/sub_career_goal.png', // Placeholder icon
    color: '#42A5F5',
    entityTypeIds: ['CareerGoal'],
    tagName: 'career_goal',
  ),
  EntitySubcategoryModel(
    id: 'days_off',
    categoryId: 'career',
    name: 'days_off',
    displayName: 'Days Off',
    icon: 'assets/images/categories/sub_days_off.png', // Placeholder icon
    color: '#42A5F5',
    entityTypeIds: ['DaysOff'],
    tagName: 'days_off',
  ),
  EntitySubcategoryModel(
    id: 'employee',
    categoryId: 'career',
    name: 'employee',
    displayName: 'Employee',
    icon: 'assets/images/categories/sub_employee.png', // Placeholder icon
    color: '#42A5F5',
    entityTypeIds: ['Employee'],
    tagName: 'employee',
  ),
];

// Subcategories for travel
final List<EntitySubcategoryModel> travelSubcategories = [
  EntitySubcategoryModel(id: 'accommodations', categoryId: 'travel', name: 'accommodations', displayName: 'Accommodations', icon: 'hotel', color: '#FF8C00', entityTypeIds: ['ACCOMMODATION'], tagName: 'accommodation',),
  EntitySubcategoryModel(id: 'attractions', categoryId: 'travel', name: 'attractions', displayName: 'Attractions', icon: 'photo_camera', color: '#FF8C00', entityTypeIds: ['PLACE'], tagName: 'attraction',),
  EntitySubcategoryModel(
    id: 'drive_time',
    categoryId: 'travel',
    name: 'drive_time',
    displayName: 'Drive Time',
    icon: 'assets/images/categories/sub_drive_time.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['DriveTime'],
    tagName: 'drive_time',
  ),
  EntitySubcategoryModel(
    id: 'flight',
    categoryId: 'travel',
    name: 'flight',
    displayName: 'Flight',
    icon: 'assets/images/categories/sub_flight.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['Flight'],
    tagName: 'flight',
  ),
  EntitySubcategoryModel(
    id: 'holiday',
    categoryId: 'travel',
    name: 'holiday',
    displayName: 'Holiday',
    icon: 'assets/images/categories/sub_holiday.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['Holiday'],
    tagName: 'holiday',
  ),
  EntitySubcategoryModel(
    id: 'holiday_plan',
    categoryId: 'travel',
    name: 'holiday_plan',
    displayName: 'Holiday Plan',
    icon: 'assets/images/categories/sub_holiday_plan.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['HolidayPlan'],
    tagName: 'holiday_plan',
  ),
  EntitySubcategoryModel(
    id: 'hotel_or_rental',
    categoryId: 'travel',
    name: 'hotel_or_rental',
    displayName: 'Hotel Or Rental',
    icon: 'assets/images/categories/sub_hotel_or_rental.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['HotelOrRental'],
    tagName: 'hotel_or_rental',
  ),
  EntitySubcategoryModel(
    id: 'rental_car',
    categoryId: 'travel',
    name: 'rental_car',
    displayName: 'Rental Car',
    icon: 'assets/images/categories/sub_rental_car.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['RentalCar'],
    tagName: 'rental_car',
  ),
  EntitySubcategoryModel(
    id: 'stay_with_friend',
    categoryId: 'travel',
    name: 'stay_with_friend',
    displayName: 'Stay With Friend',
    icon: 'assets/images/categories/sub_stay_with_friend.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['StayWithFriend'],
    tagName: 'stay_with_friend',
  ),
  EntitySubcategoryModel(
    id: 'taxi_or_transfer',
    categoryId: 'travel',
    name: 'taxi_or_transfer',
    displayName: 'Taxi Or Transfer',
    icon: 'assets/images/categories/sub_taxi_or_transfer.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['TaxiOrTransfer'],
    tagName: 'taxi_or_transfer',
  ),
  EntitySubcategoryModel(
    id: 'train_bus_ferry',
    categoryId: 'travel',
    name: 'train_bus_ferry',
    displayName: 'Train Bus Ferry',
    icon: 'assets/images/categories/sub_train_bus_ferry.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['TrainBusFerry'],
    tagName: 'train_bus_ferry',
  ),
  EntitySubcategoryModel(
    id: 'travel_plan',
    categoryId: 'travel',
    name: 'travel_plan',
    displayName: 'Travel Plan',
    icon: 'assets/images/categories/sub_travel_plan.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['TravelPlan'],
    tagName: 'travel_plan',
  ),
  EntitySubcategoryModel(
    id: 'trip',
    categoryId: 'travel',
    name: 'trip',
    displayName: 'Trip',
    icon: 'assets/images/categories/sub_trip.png', // Placeholder icon
    color: '#7E57C2',
    entityTypeIds: ['Trip'],
    tagName: 'trip',
  ),
];

// Subcategories for health_beauty
final List<EntitySubcategoryModel> healthBeautySubcategories = [
  EntitySubcategoryModel(
    id: 'appointment',
    categoryId: 'health_beauty',
    name: 'appointment',
    displayName: 'Appointment',
    icon: 'assets/images/categories/sub_appointment.png', // Placeholder icon
    color: '#66BB6A',
    entityTypeIds: ['Appointment'],
    tagName: 'appointment',
  ),
  EntitySubcategoryModel(id: 'beauty', categoryId: 'health_beauty', name: 'beauty', displayName: 'Beauty', icon: 'spa', color: '#9370DB', entityTypeIds: ['BEAUTY'], tagName: 'beauty',),
  EntitySubcategoryModel(id: 'fitness', categoryId: 'health_beauty', name: 'fitness', displayName: 'Fitness', icon: 'fitness_center', color: '#9370DB', entityTypeIds: ['FITNESS_ACTIVITY'], tagName: 'fitness',),
  EntitySubcategoryModel(
    id: 'health_goal',
    categoryId: 'health_beauty',
    name: 'health_goal',
    displayName: 'Health Goal',
    icon: 'assets/images/categories/sub_health_goal.png', // Placeholder icon
    color: '#66BB6A',
    entityTypeIds: ['HealthGoal'],
    tagName: 'health_goal',
  ),
  EntitySubcategoryModel(id: 'medical', categoryId: 'health_beauty', name: 'medical', displayName: 'Medical', icon: 'local_hospital', color: '#9370DB', entityTypeIds: ['MEDICAL'], tagName: 'medical',),
  EntitySubcategoryModel(
    id: 'patient',
    categoryId: 'health_beauty',
    name: 'patient',
    displayName: 'Patient',
    icon: 'assets/images/categories/sub_patient.png', // Placeholder icon
    color: '#66BB6A',
    entityTypeIds: ['Patient'],
    tagName: 'patient',
  ),
];

// Subcategories for home
final List<EntitySubcategoryModel> homeSubcategories = [
  EntitySubcategoryModel(id: 'cleaning', categoryId: 'home', name: 'cleaning', displayName: 'Cleaning', icon: 'cleaning_services', color: '#FF7043', entityTypeIds: ['CLEANING'], tagName: 'cleaning',),
  EntitySubcategoryModel(id: 'cooking', categoryId: 'home', name: 'cooking', displayName: 'Cooking', icon: 'restaurant', color: '#FF7043', entityTypeIds: ['COOKING'], tagName: 'cooking',),
  EntitySubcategoryModel(
    id: 'home',
    categoryId: 'home',
    name: 'home',
    displayName: 'Home',
    icon: 'assets/images/categories/sub_home.png', // Placeholder icon
    color: '#FF7043',
    entityTypeIds: ['Home'],
    tagName: 'home',
  ),
  EntitySubcategoryModel(id: 'home_maintenance', categoryId: 'home', name: 'home_maintenance', displayName: 'Home Maintenance', icon: 'home_repair_service', color: '#FF7043', entityTypeIds: ['HOME_MAINTENANCE'], tagName: 'home_maintenance',),
];

// Subcategories for garden
final List<EntitySubcategoryModel> gardenSubcategories = [
  EntitySubcategoryModel(
    id: 'garden',
    categoryId: 'garden',
    name: 'garden',
    displayName: 'Garden',
    icon: 'assets/images/categories/sub_garden.png', // Placeholder icon
    color: '#8BC34A',
    entityTypeIds: ['Garden'],
    tagName: 'garden',
  ),
  EntitySubcategoryModel(id: 'gardening', categoryId: 'garden', name: 'gardening', displayName: 'Gardening', icon: 'yard', color: '#8BC34A', entityTypeIds: ['GARDENING'], tagName: 'gardening',),
];

// Subcategories for food
final List<EntitySubcategoryModel> foodSubcategories = [
  EntitySubcategoryModel(
    id: 'food',
    categoryId: 'food',
    name: 'food',
    displayName: 'Food',
    icon: 'assets/images/categories/sub_food.png', // Placeholder icon
    color: '#FF9800',
    entityTypeIds: ['Food'],
    tagName: 'food',
  ),
  EntitySubcategoryModel(
    id: 'food_plan',
    categoryId: 'food',
    name: 'food_plan',
    displayName: 'Food Plan',
    icon: 'assets/images/categories/sub_food_plan.png', // Placeholder icon
    color: '#FF9800',
    entityTypeIds: ['FoodPlan'],
    tagName: 'food_plan',
  ),
];

// Subcategories for laundry
final List<EntitySubcategoryModel> laundrySubcategories = [
  EntitySubcategoryModel(
    id: 'clothing',
    categoryId: 'laundry',
    name: 'clothing',
    displayName: 'Clothing',
    icon: 'assets/images/categories/sub_clothing.png', // Placeholder icon
    color: '#00BCD4',
    entityTypeIds: ['Clothing'],
    tagName: 'clothing',
  ),
  EntitySubcategoryModel(
    id: 'laundry_plan',
    categoryId: 'laundry',
    name: 'laundry_plan',
    displayName: 'Laundry Plan',
    icon: 'assets/images/categories/sub_laundry_plan.png', // Placeholder icon
    color: '#00BCD4',
    entityTypeIds: ['LaundryPlan'],
    tagName: 'laundry_plan',
  ),
];

// Subcategories for finance
final List<EntitySubcategoryModel> financeSubcategories = [
  EntitySubcategoryModel(
    id: 'finance',
    categoryId: 'finance',
    name: 'finance',
    displayName: 'Finance',
    icon: 'assets/images/categories/sub_finance.png', // Placeholder icon
    color: '#FFCA28',
    entityTypeIds: ['Finance'],
    tagName: 'finance',
  ),
];

// Subcategories for transport
final List<EntitySubcategoryModel> transportSubcategories = [
  EntitySubcategoryModel(
    id: 'boat',
    categoryId: 'transport',
    name: 'boat',
    displayName: 'Boat',
    icon: 'assets/images/categories/sub_boat.png', // Placeholder icon
    color: '#607D8B',
    entityTypeIds: ['Boat'],
    tagName: 'boat',
  ),
  EntitySubcategoryModel(
    id: 'car',
    categoryId: 'transport',
    name: 'car',
    displayName: 'Car',
    icon: 'assets/images/categories/sub_car.png', // Placeholder icon
    color: '#607D8B',
    entityTypeIds: ['Car'],
    tagName: 'car',
  ),
  EntitySubcategoryModel(
    id: 'public_transport',
    categoryId: 'transport',
    name: 'public_transport',
    displayName: 'Public Transport',
    icon: 'assets/images/categories/sub_public_transport.png', // Placeholder icon
    color: '#607D8B',
    entityTypeIds: ['PublicTransport'],
    tagName: 'public_transport',
  ),
];

// Aggregated list of all default subcategories
final List<EntitySubcategoryModel> allDefaultSubcategories = [
  ...careerSubcategories,
  ...educationSubcategories,
  ...financeSubcategories,
  ...foodSubcategories,
  ...gardenSubcategories,
  ...healthBeautySubcategories,
  ...homeSubcategories,
  ...laundrySubcategories,
  ...petSubcategories,
  ...socialInterestsSubcategories,
  ...transportSubcategories,
  ...travelSubcategories,
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
};