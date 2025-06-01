import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_subentity_model.freezed.dart';
part 'auto_subentity_model.g.dart';

/// AutoSubentity system - automatically creates sub-entities for certain entity types
/// Based on the React app's AutoSubentity feature for Events
@freezed
class AutoSubentityTemplateModel with _$AutoSubentityTemplateModel {
  const factory AutoSubentityTemplateModel({
    required String id,
    required String parentEntityType,
    required String name,
    required String description,
    String? icon,
    String? color,
    required int priority,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AutoSubentityTemplateModel;

  factory AutoSubentityTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$AutoSubentityTemplateModelFromJson(json);
}

/// Instance of an auto-created sub-entity
@freezed
class AutoSubentityInstanceModel with _$AutoSubentityInstanceModel {
  const factory AutoSubentityInstanceModel({
    required String id,
    required String parentEntityId,
    required String templateId,
    required String name,
    String? notes,
    String? image,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AutoSubentityInstanceModel;

  factory AutoSubentityInstanceModel.fromJson(Map<String, dynamic> json) =>
      _$AutoSubentityInstanceModelFromJson(json);
}

/// Default templates for auto-creation (matching React app exactly)
const List<Map<String, dynamic>> defaultAutoSubentityTemplates = [
  {
    'id': 'event_food_cake',
    'parentEntityType': 'Event',
    'name': 'Food / Cake / Candles',
    'description': 'Plan food, cake, and candles for the event',
    'priority': 1,
  },
  {
    'id': 'event_activities_venue',
    'parentEntityType': 'Event',
    'name': 'Activities / Venue',
    'description': 'Plan activities and venue for the event',
    'priority': 2,
  },
  {
    'id': 'event_party_favours',
    'parentEntityType': 'Event',
    'name': 'Party Favours / Games',
    'description': 'Plan party favours and games for the event',
    'priority': 3,
  },
  {
    'id': 'event_gifts_wrapping',
    'parentEntityType': 'Event',
    'name': 'Gifts / Wrapping',
    'description': 'Plan gifts and wrapping for the event',
    'priority': 4,
  },
  {
    'id': 'event_music',
    'parentEntityType': 'Event',
    'name': 'Music',
    'description': 'Plan music for the event',
    'priority': 5,
  },
  {
    'id': 'event_decorations',
    'parentEntityType': 'Event',
    'name': 'Decorations',
    'description': 'Plan decorations for the event',
    'priority': 6,
  },
  // Holiday Plan auto-subentities
  {
    'id': 'holiday_plan_accommodation',
    'parentEntityType': 'HolidayPlan',
    'name': 'Accommodation',
    'description': 'Plan accommodation for the holiday',
    'priority': 1,
  },
  {
    'id': 'holiday_plan_transport',
    'parentEntityType': 'HolidayPlan',
    'name': 'Transport',
    'description': 'Plan transport for the holiday',
    'priority': 2,
  },
  {
    'id': 'holiday_plan_activities',
    'parentEntityType': 'HolidayPlan',
    'name': 'Activities',
    'description': 'Plan activities for the holiday',
    'priority': 3,
  },
  // Anniversary Plan auto-subentities
  {
    'id': 'anniversary_plan_gifts',
    'parentEntityType': 'AnniversaryPlan',
    'name': 'Gifts',
    'description': 'Plan gifts for the anniversary',
    'priority': 1,
  },
  {
    'id': 'anniversary_plan_celebration',
    'parentEntityType': 'AnniversaryPlan',
    'name': 'Celebration',
    'description': 'Plan celebration for the anniversary',
    'priority': 2,
  },
];
