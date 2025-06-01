import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_category_model.freezed.dart';
part 'list_category_model.g.dart';

@freezed
class ListCategoryModel with _$ListCategoryModel {
  const factory ListCategoryModel({
    required String id,
    required String name,
    required String icon,
    required String color,
    String? description,
    @Default(0) int order,
    @Default(true) bool isActive,
    @Default(false) bool isCustom,
    @Default([]) List<String> suggestedTemplates,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ListCategoryModel;

  factory ListCategoryModel.fromJson(Map<String, dynamic> json) => 
      _$ListCategoryModelFromJson(json);
}

// Predefined categories matching the old design
class ListCategories {
  static const List<ListCategoryModel> defaultCategories = [
    ListCategoryModel(
      id: 'pets',
      name: 'Pets',
      icon: 'pets',
      color: '#FF6B35',
      description: 'Pet care, training, and supplies',
      order: 1,
    ),
    ListCategoryModel(
      id: 'social-interests',
      name: 'Social & Interests',
      icon: 'group',
      color: '#4ECDC4',
      description: 'Hobbies, social activities, and personal interests',
      order: 2,
    ),
    ListCategoryModel(
      id: 'education',
      name: 'Education',
      icon: 'school',
      color: '#45B7D1',
      description: 'Learning goals, courses, and academic tasks',
      order: 3,
    ),
    ListCategoryModel(
      id: 'career',
      name: 'Career',
      icon: 'work',
      color: '#96CEB4',
      description: 'Professional development and work tasks',
      order: 4,
    ),
    ListCategoryModel(
      id: 'travel',
      name: 'Travel',
      icon: 'flight',
      color: '#FFEAA7',
      description: 'Trip planning, itineraries, and travel preparations',
      order: 5,
    ),
    ListCategoryModel(
      id: 'health-beauty',
      name: 'Health & Beauty',
      icon: 'spa',
      color: '#DDA0DD',
      description: 'Health goals, beauty routines, and wellness',
      order: 6,
    ),
    ListCategoryModel(
      id: 'home',
      name: 'Home',
      icon: 'home',
      color: '#98D8C8',
      description: 'Home improvement, maintenance, and organization',
      order: 7,
    ),
    ListCategoryModel(
      id: 'garden',
      name: 'Garden',
      icon: 'yard',
      color: '#A8E6CF',
      description: 'Gardening tasks, plant care, and outdoor projects',
      order: 8,
    ),
    ListCategoryModel(
      id: 'food',
      name: 'Food',
      icon: 'restaurant',
      color: '#FFB3BA',
      description: 'Meal planning, recipes, and food-related tasks',
      order: 9,
    ),
    ListCategoryModel(
      id: 'clothing-laundry',
      name: 'Clothing & Laundry',
      icon: 'checkroom',
      color: '#BFBFBF',
      description: 'Wardrobe management and laundry tasks',
      order: 10,
    ),
  ];
} 