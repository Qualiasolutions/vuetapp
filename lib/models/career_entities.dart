import 'package:freezed_annotation/freezed_annotation.dart';

part 'career_entities.freezed.dart';
part 'career_entities.g.dart';

@freezed
class CareerGoal with _$CareerGoal {
  const factory CareerGoal({
    String? id, // UUID from Supabase
    @JsonKey(name: 'user_id') String? userId,
    required String title,
    String? description,
    @JsonKey(name: 'target_date') DateTime? targetDate,
    String? status, // e.g., Not Started, In Progress, Achieved, On Hold
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default('CareerGoal') String resourceType,
  }) = _CareerGoal;

  factory CareerGoal.fromJson(Map<String, dynamic> json) => _$CareerGoalFromJson(json);
}

@freezed
class Employee with _$Employee {
  const factory Employee({
    String? id, // UUID from Supabase
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'job_title') required String jobTitle,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'is_current_job', defaultValue: true) bool? isCurrentJob,
    String? responsibilities,
    @JsonKey(name: 'manager_name') String? managerName,
    @JsonKey(name: 'manager_email') String? managerEmail,
    @JsonKey(name: 'next_review_date') DateTime? nextReviewDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default('Employee') String resourceType,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}
