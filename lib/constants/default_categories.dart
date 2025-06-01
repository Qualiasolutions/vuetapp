import 'package:vuet_app/models/entity_category_model.dart';

// Defines the default, global categories for the application.
// These match the categories from the original React app exactly.

final List<EntityCategoryModel> defaultCategories = [
  EntityCategoryModel(
    id: 'pets',
    name: 'Pets',
    icon: 'assets/images/categories/pets.png',
    color: '#8D6E63', // Brown Accent
    ownerId: null,
    priority: 1,
    description: 'Manage pet care, appointments, and all pet-related information.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests',
    name: 'Social & Interests',
    icon: 'assets/images/categories/social.png',
    color: '#EC407A', // Pink Accent
    ownerId: null,
    priority: 2,
    description: 'Organize events, hobbies, social plans, anniversaries, and contacts.',
    isProfessional: false,
  ),
  // Subcategories for Social & Interests
  EntityCategoryModel(
    id: 'social_interests_social_plans',
    name: 'Social Plans',
    parentId: 'social_interests',
    icon: 'assets/images/categories/social_plans.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 1,
    description: 'Manage your social plans and engagements.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_anniversaries',
    name: 'Anniversaries',
    parentId: 'social_interests',
    icon: 'assets/images/categories/anniversaries.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 2,
    description: 'Keep track of important anniversaries.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_national_holidays',
    name: 'National Holidays',
    parentId: 'social_interests',
    icon: 'assets/images/categories/national_holidays.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 3,
    description: 'View upcoming national holidays.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_events',
    name: 'Events',
    parentId: 'social_interests',
    icon: 'assets/images/categories/events.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 4,
    description: 'Organize and track various events.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_hobbies',
    name: 'Hobbies',
    parentId: 'social_interests',
    icon: 'assets/images/categories/hobbies.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 5,
    description: 'Manage your hobbies and related activities.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_social_media',
    name: 'Social Media',
    parentId: 'social_interests',
    icon: 'assets/images/categories/social_media.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 6,
    description: 'Keep track of social media profiles and information.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'social_interests_my_social_information',
    name: 'My Social Information',
    parentId: 'social_interests',
    icon: 'assets/images/categories/social_information.png', // Placeholder icon
    color: '#EC407A', // Pink Accent (same as parent)
    ownerId: null,
    priority: 7,
    description: 'Manage your public social information.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'education',
    name: 'Education',
    icon: 'assets/images/categories/education.png',
    color: '#26A69A', // Teal Accent
    ownerId: null,
    priority: 3,
    description: 'Organize learning materials, courses, academic plans, and educational goals.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'career',
    name: 'Career',
    icon: 'assets/images/categories/career.png',
    color: '#42A5F5', // Blue Accent
    ownerId: null,
    priority: 4,
    description: 'Organize professional tasks, career goals, and job-related information.',
    isProfessional: true,
  ),
  EntityCategoryModel(
    id: 'travel',
    name: 'Travel',
    icon: 'assets/images/categories/travel.png',
    color: '#7E57C2', // Deep Purple Accent
    ownerId: null,
    priority: 5,
    description: 'Plan trips, manage bookings, and keep track of travel-related information.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'health_beauty',
    name: 'Health & Beauty',
    icon: 'assets/images/categories/health.png',
    color: '#66BB6A', // Green Accent
    ownerId: null,
    priority: 6,
    description: 'Track health, wellness, appointments, and fitness goals.',
    isProfessional: false,
  ),
  // Subcategories for Health & Beauty
  EntityCategoryModel(
    id: 'health_beauty_patients',
    name: 'Patients',
    parentId: 'health_beauty',
    icon: 'assets/images/categories/patients.png', // Placeholder icon
    color: '#66BB6A', // Green Accent (same as parent)
    ownerId: null,
    priority: 1,
    description: 'Manage patient profiles and information.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'health_beauty_appointments',
    name: 'Appointments',
    parentId: 'health_beauty',
    icon: 'assets/images/categories/appointments.png', // Placeholder icon
    color: '#66BB6A', // Green Accent (same as parent)
    ownerId: null,
    priority: 2,
    description: 'Track medical and beauty appointments.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'health_beauty_goals',
    name: 'Health Goals',
    parentId: 'health_beauty',
    icon: 'assets/images/categories/health_goals.png', // Placeholder icon
    color: '#66BB6A', // Green Accent (same as parent)
    ownerId: null,
    priority: 3,
    description: 'Set and track health and wellness goals.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'home',
    name: 'Home',
    icon: 'assets/images/categories/home.png',
    color: '#FF7043', // Deep Orange Accent
    ownerId: null, 
    priority: 7,
    description: 'Manage home-related tasks, items, and projects.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'garden',
    name: 'Garden',
    icon: 'assets/images/categories/garden.png',
    color: '#8BC34A', // Light Green
    ownerId: null,
    priority: 8,
    description: 'Plan garden projects, manage plants, and track gardening activities.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'food',
    name: 'Food',
    icon: 'assets/images/categories/food.png',
    color: '#FF9800', // Orange
    ownerId: null,
    priority: 9,
    description: 'Plan meals, manage recipes, and track food-related activities.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'laundry',
    name: 'Laundry',
    icon: 'assets/images/categories/laundry.png',
    color: '#00BCD4', // Cyan
    ownerId: null,
    priority: 10,
    description: 'Manage laundry schedules, clothing care, and dry cleaning.',
    isProfessional: false,
  ),
  EntityCategoryModel(
    id: 'finance',
    name: 'Finance',
    icon: 'assets/images/categories/finance.png',
    color: '#FFCA28', // Amber Accent
    ownerId: null,
    priority: 11,
    description: 'Manage financial accounts, budgets, investments, and expenses.',
    isProfessional: false, 
  ),
  EntityCategoryModel(
    id: 'transport',
    name: 'Transport',
    icon: 'assets/images/categories/transport.png',
    color: '#607D8B', // Blue Grey
    ownerId: null,
    priority: 12,
    description: 'Manage vehicles, public transport, and travel arrangements.',
    isProfessional: false,
  ),
];
