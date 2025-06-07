import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_entities.freezed.dart';
part 'education_entities.g.dart';

@freezed
class School with _$School {
  const factory School({
    required String id, // Corresponds to entities.id
    @Default('School') String entityType,
    required String name,
    String? address,
    String? phoneNumber,
    String? email,
    String? website,
    // Specific fields from school_entities table
    // Assuming owner_id, created_at, updated_at are handled by the generic entity or repository
    String? notes, // from entities table
    required DateTime createdAt,
    required DateTime updatedAt,
    String? ownerId, // from entities table
  }) = _School;

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
}

@freezed
class Student with _$Student {
  const factory Student({
    required String id, // Corresponds to entities.id
    @Default('Student') String entityType,
    required String firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? schoolId, // FK to entities.id of a School entity
    String? gradeLevel,
    String? studentIdNumber,
    // Specific fields from student_entities table
    String? notes, // from entities table
    required DateTime createdAt,
    required DateTime updatedAt,
    String? ownerId, // from entities table
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
}

@freezed
class AcademicPlan with _$AcademicPlan {
  const factory AcademicPlan({
    required String id, // Corresponds to entities.id
    @Default('AcademicPlan') String entityType,
    String? studentId, // FK to entities.id of a Student entity
    required String planName,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    List<String>? goals, // Simplified from JSONB for now
    // Specific fields from academic_plan_entities table
    String? notes, // from entities table
    required DateTime createdAt,
    required DateTime updatedAt,
    String? ownerId, // from entities table
  }) = _AcademicPlan;

  factory AcademicPlan.fromJson(Map<String, dynamic> json) => _$AcademicPlanFromJson(json);
}

@freezed
class SchoolTerm with _$SchoolTerm {
  const factory SchoolTerm({
    required String id, // Corresponds to entities.id
    @Default('SchoolTerm') String entityType,
    String? schoolId, // FK to entities.id of a School entity
    required String termName,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    // Specific fields from school_term_entities table
    String? notes, // from entities table
    required DateTime createdAt,
    required DateTime updatedAt,
    String? ownerId, // from entities table
  }) = _SchoolTerm;

  factory SchoolTerm.fromJson(Map<String, dynamic> json) => _$SchoolTermFromJson(json);
}

@freezed
class SchoolBreak with _$SchoolBreak {
  const factory SchoolBreak({
    required String id, // Corresponds to entities.id
    @Default('SchoolBreak') String entityType,
    String? schoolId, // FK to entities.id of a School entity (or could be linked to term)
    required String breakName,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    // Specific fields from school_break_entities table
    String? notes, // from entities table
    required DateTime createdAt,
    required DateTime updatedAt,
    String? ownerId, // from entities table
  }) = _SchoolBreak;

  factory SchoolBreak.fromJson(Map<String, dynamic> json) => _$SchoolBreakFromJson(json);
}
