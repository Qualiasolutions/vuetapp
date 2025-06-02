import 'package:vuet_app/models/entity_subcategory_model.dart';

// Define the default subcategories for each main category
// These match the structure from the documentation

// Pets subcategories
final List<EntitySubcategoryModel> petSubcategories = [
  EntitySubcategoryModel(
    id: 'pets_dogs',
    categoryId: 'pets',
    name: 'dogs',
    displayName: 'Dogs',
    icon: 'pets',
    color: '#8B4513',
    entityTypeIds: ['PET'],
    tagName: 'dog',
  ),
  EntitySubcategoryModel(
    id: 'pets_cats',
    categoryId: 'pets',
    name: 'cats',
    displayName: 'Cats',
    icon: 'pets',
    color: '#8B4513',
    entityTypeIds: ['PET'],
    tagName: 'cat',
  ),
  EntitySubcategoryModel(
    id: 'pets_birds',
    categoryId: 'pets',
    name: 'birds',
    displayName: 'Birds',
    icon: 'pets',
    color: '#8B4513',
    entityTypeIds: ['PET'],
    tagName: 'bird',
  ),
  EntitySubcategoryModel(
    id: 'pets_fish',
    categoryId: 'pets',
    name: 'fish',
    displayName: 'Fish',
    icon: 'pets',
    color: '#8B4513',
    entityTypeIds: ['PET'],
    tagName: 'fish',
  ),
  EntitySubcategoryModel(
    id: 'pets_other',
    categoryId: 'pets',
    name: 'other_pets',
    displayName: 'Other Pets',
    icon: 'pets',
    color: '#8B4513',
    entityTypeIds: ['PET'],
    tagName: 'other_pet',
  ),
];

// Social & Interests subcategories
final List<EntitySubcategoryModel> socialInterestsSubcategories = [
  EntitySubcategoryModel(
    id: 'social_plans',
    categoryId: 'social_interests',
    name: 'social_plans',
    displayName: 'Social Plans',
    icon: 'event',
    color: '#4682B4',
    entityTypeIds: ['SOCIAL_ACTIVITY'],
    tagName: 'social_plan',
  ),
  EntitySubcategoryModel(
    id: 'anniversaries',
    categoryId: 'social_interests',
    name: 'anniversaries',
    displayName: 'Anniversaries',
    icon: 'cake',
    color: '#4682B4',
    entityTypeIds: ['EVENT'],
    tagName: 'anniversary',
  ),
  EntitySubcategoryModel(
    id: 'events',
    categoryId: 'social_interests',
    name: 'events',
    displayName: 'Events',
    icon: 'celebration',
    color: '#4682B4',
    entityTypeIds: ['EVENT'],
    tagName: 'event',
  ),
  EntitySubcategoryModel(
    id: 'hobbies',
    categoryId: 'social_interests',
    name: 'hobbies',
    displayName: 'Hobbies',
    icon: 'emoji_events',
    color: '#4682B4',
    entityTypeIds: ['HOBBY'],
    tagName: 'hobby',
  ),
];

// Education & Career subcategories
final List<EntitySubcategoryModel> educationCareerSubcategories = [
  EntitySubcategoryModel(
    id: 'courses',
    categoryId: 'education_career',
    name: 'courses',
    displayName: 'Courses',
    icon: 'school',
    color: '#2E8B57',
    entityTypeIds: ['COURSE'],
    tagName: 'course',
  ),
  EntitySubcategoryModel(
    id: 'educational_goals',
    categoryId: 'education_career',
    name: 'educational_goals',
    displayName: 'Educational Goals',
    icon: 'emoji_events',
    color: '#2E8B57',
    entityTypeIds: ['GOAL'],
    tagName: 'educational_goal',
  ),
  EntitySubcategoryModel(
    id: 'careers',
    categoryId: 'education_career',
    name: 'careers',
    displayName: 'Careers',
    icon: 'work',
    color: '#2E8B57',
    entityTypeIds: ['CAREER'],
    tagName: 'career',
  ),
  EntitySubcategoryModel(
    id: 'professional_goals',
    categoryId: 'education_career',
    name: 'professional_goals',
    displayName: 'Professional Goals',
    icon: 'trending_up',
    color: '#2E8B57',
    entityTypeIds: ['GOAL'],
    tagName: 'professional_goal',
  ),
];

// Travel subcategories
final List<EntitySubcategoryModel> travelSubcategories = [
  EntitySubcategoryModel(
    id: 'trips',
    categoryId: 'travel',
    name: 'trips',
    displayName: 'Trips',
    icon: 'flight',
    color: '#FF8C00',
    entityTypeIds: ['TRIP'],
    tagName: 'trip',
  ),
  EntitySubcategoryModel(
    id: 'accommodations',
    categoryId: 'travel',
    name: 'accommodations',
    displayName: 'Accommodations',
    icon: 'hotel',
    color: '#FF8C00',
    entityTypeIds: ['ACCOMMODATION'],
    tagName: 'accommodation',
  ),
  EntitySubcategoryModel(
    id: 'attractions',
    categoryId: 'travel',
    name: 'attractions',
    displayName: 'Attractions',
    icon: 'photo_camera',
    color: '#FF8C00',
    entityTypeIds: ['PLACE'],
    tagName: 'attraction',
  ),
];

// Health & Beauty subcategories
final List<EntitySubcategoryModel> healthBeautySubcategories = [
  EntitySubcategoryModel(
    id: 'fitness',
    categoryId: 'health_beauty',
    name: 'fitness',
    displayName: 'Fitness',
    icon: 'fitness_center',
    color: '#9370DB',
    entityTypeIds: ['FITNESS_ACTIVITY'],
    tagName: 'fitness',
  ),
  EntitySubcategoryModel(
    id: 'medical',
    categoryId: 'health_beauty',
    name: 'medical',
    displayName: 'Medical',
    icon: 'local_hospital',
    color: '#9370DB',
    entityTypeIds: ['MEDICAL'],
    tagName: 'medical',
  ),
  EntitySubcategoryModel(
    id: 'beauty',
    categoryId: 'health_beauty',
    name: 'beauty',
    displayName: 'Beauty',
    icon: 'spa',
    color: '#9370DB',
    entityTypeIds: ['BEAUTY'],
    tagName: 'beauty',
  ),
];

// Home & Garden subcategories
final List<EntitySubcategoryModel> homeGardenSubcategories = [
  EntitySubcategoryModel(
    id: 'home_maintenance',
    categoryId: 'home_garden',
    name: 'home_maintenance',
    displayName: 'Home Maintenance',
    icon: 'home_repair_service',
    color: '#3CB371',
    entityTypeIds: ['HOME_MAINTENANCE'],
    tagName: 'home_maintenance',
  ),
  EntitySubcategoryModel(
    id: 'gardening',
    categoryId: 'home_garden',
    name: 'gardening',
    displayName: 'Gardening',
    icon: 'yard',
    color: '#3CB371',
    entityTypeIds: ['GARDENING'],
    tagName: 'gardening',
  ),
  EntitySubcategoryModel(
    id: 'cooking',
    categoryId: 'home_garden',
    name: 'cooking',
    displayName: 'Cooking',
    icon: 'restaurant',
    color: '#3CB371',
    entityTypeIds: ['COOKING'],
    tagName: 'cooking',
  ),
  EntitySubcategoryModel(
    id: 'cleaning',
    categoryId: 'home_garden',
    name: 'cleaning',
    displayName: 'Cleaning',
    icon: 'cleaning_services',
    color: '#3CB371',
    entityTypeIds: ['CLEANING'],
    tagName: 'cleaning',
  ),
];

// Finance subcategories
final List<EntitySubcategoryModel> financeSubcategories = [
  EntitySubcategoryModel(
    id: 'accounts',
    categoryId: 'finance',
    name: 'accounts',
    displayName: 'Accounts',
    icon: 'account_balance',
    color: '#6A5ACD',
    entityTypeIds: ['FINANCIAL_ACCOUNT'],
    tagName: 'account',
  ),
  EntitySubcategoryModel(
    id: 'budgeting',
    categoryId: 'finance',
    name: 'budgeting',
    displayName: 'Budgeting',
    icon: 'savings',
    color: '#6A5ACD',
    entityTypeIds: ['BUDGET'],
    tagName: 'budget',
  ),
  EntitySubcategoryModel(
    id: 'investments',
    categoryId: 'finance',
    name: 'investments',
    displayName: 'Investments',
    icon: 'trending_up',
    color: '#6A5ACD',
    entityTypeIds: ['INVESTMENT'],
    tagName: 'investment',
  ),
];

// Transport subcategories
final List<EntitySubcategoryModel> transportSubcategories = [
  EntitySubcategoryModel(
    id: 'vehicles',
    categoryId: 'transport',
    name: 'vehicles',
    displayName: 'Vehicles',
    icon: 'directions_car',
    color: '#CD5C5C',
    entityTypeIds: ['VEHICLE'],
    tagName: 'vehicle',
  ),
  EntitySubcategoryModel(
    id: 'public_transport',
    categoryId: 'transport',
    name: 'public_transport',
    displayName: 'Public Transport',
    icon: 'directions_bus',
    color: '#CD5C5C',
    entityTypeIds: ['PUBLIC_TRANSPORT'],
    tagName: 'public_transport',
  ),
];

// Map of all subcategories by category ID for easy access
final Map<String, List<EntitySubcategoryModel>> allSubcategories = {
  'pets': petSubcategories,
  'social_interests': socialInterestsSubcategories,
  'education_career': educationCareerSubcategories,
  'travel': travelSubcategories,
  'health_beauty': healthBeautySubcategories,
  'home_garden': homeGardenSubcategories,
  'finance': financeSubcategories,
  'transport': transportSubcategories,
}; 