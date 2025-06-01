import 'package:freezed_annotation/freezed_annotation.dart';
import 'list_sublist_model.dart';

part 'list_template_model.freezed.dart';
part 'list_template_model.g.dart';

@freezed
class ListTemplateModel with _$ListTemplateModel {
  const factory ListTemplateModel({
    required String id,
    required String name,
    String? description,
    required String categoryId,
    String? icon,
    String? color,
    @Default([]) List<ListSublist> sublists,
    @Default([]) List<String> tags,
    @Default(0) int popularity,
    @Default(false) bool isPremium,
    @Default(false) bool isSystemTemplate,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ListTemplateModel;

  factory ListTemplateModel.fromJson(Map<String, dynamic> json) => 
      _$ListTemplateModelFromJson(json);
}

// Predefined templates for each category
class ListTemplates {
  static const List<ListTemplateModel> defaultTemplates = [
    // Pets Templates
    ListTemplateModel(
      id: 'pets-care-weekly',
      name: 'Weekly Pet Care',
      description: 'Essential weekly tasks for pet care',
      categoryId: 'pets',
      icon: 'pets',
      isSystemTemplate: true,
      tags: ['weekly', 'care', 'routine'],
      popularity: 95,
    ),
    ListTemplateModel(
      id: 'new-pet-checklist',
      name: 'New Pet Checklist',
      description: 'Everything you need when getting a new pet',
      categoryId: 'pets',
      icon: 'checklist',
      isSystemTemplate: true,
      tags: ['new', 'setup', 'supplies'],
      popularity: 87,
    ),
    
    // Travel Templates
    ListTemplateModel(
      id: 'vacation-packing',
      name: 'Vacation Packing List',
      description: 'Complete packing checklist for vacation travel',
      categoryId: 'travel',
      icon: 'luggage',
      isSystemTemplate: true,
      tags: ['packing', 'vacation', 'checklist'],
      popularity: 92,
    ),
    ListTemplateModel(
      id: 'business-travel',
      name: 'Business Travel Essentials',
      description: 'Professional travel preparation checklist',
      categoryId: 'travel',
      icon: 'business_center',
      isSystemTemplate: true,
      tags: ['business', 'professional', 'travel'],
      popularity: 78,
    ),
    
    // Home Templates
    ListTemplateModel(
      id: 'spring-cleaning',
      name: 'Spring Cleaning Checklist',
      description: 'Comprehensive spring cleaning tasks',
      categoryId: 'home',
      icon: 'cleaning_services',
      isSystemTemplate: true,
      tags: ['cleaning', 'seasonal', 'maintenance'],
      popularity: 89,
    ),
    ListTemplateModel(
      id: 'moving-checklist',
      name: 'Moving Checklist',
      description: 'Complete moving and relocation checklist',
      categoryId: 'home',
      icon: 'moving',
      isSystemTemplate: true,
      tags: ['moving', 'relocation', 'checklist'],
      popularity: 84,
    ),
    
    // Health & Beauty Templates
    ListTemplateModel(
      id: 'morning-routine',
      name: 'Morning Beauty Routine',
      description: 'Daily morning skincare and beauty routine',
      categoryId: 'health-beauty',
      icon: 'face_retouching_natural',
      isSystemTemplate: true,
      tags: ['morning', 'skincare', 'routine'],
      popularity: 91,
    ),
    ListTemplateModel(
      id: 'workout-plan',
      name: 'Weekly Workout Plan',
      description: 'Structured weekly fitness routine',
      categoryId: 'health-beauty',
      icon: 'fitness_center',
      isSystemTemplate: true,
      tags: ['fitness', 'weekly', 'health'],
      popularity: 85,
    ),
    
    // Career Templates
    ListTemplateModel(
      id: 'job-search',
      name: 'Job Search Action Plan',
      description: 'Systematic approach to job searching',
      categoryId: 'career',
      icon: 'work_outline',
      isSystemTemplate: true,
      tags: ['job', 'search', 'career'],
      popularity: 88,
    ),
    ListTemplateModel(
      id: 'project-launch',
      name: 'Project Launch Checklist',
      description: 'Steps for successful project launches',
      categoryId: 'career',
      icon: 'rocket_launch',
      isSystemTemplate: true,
      tags: ['project', 'launch', 'work'],
      popularity: 82,
    ),
  ];
  
  static List<ListTemplateModel> getTemplatesForCategory(String categoryId) {
    return defaultTemplates.where((template) => 
        template.categoryId == categoryId).toList();
  }
  
  static List<ListTemplateModel> getPopularTemplates({int limit = 5}) {
    var templates = List<ListTemplateModel>.from(defaultTemplates);
    templates.sort((a, b) => b.popularity.compareTo(a.popularity));
    return templates.take(limit).toList();
  }
} 