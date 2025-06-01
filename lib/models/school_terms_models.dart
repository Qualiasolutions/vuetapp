import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_terms_models.freezed.dart';
part 'school_terms_models.g.dart';

/// School year model representing an academic year
@freezed
class SchoolYearModel with _$SchoolYearModel {
  const factory SchoolYearModel({
    /// Unique identifier for the school year
    required String id,
    
    /// Start date of the school year
    @JsonKey(name: 'start_date') required DateTime startDate,
    
    /// End date of the school year
    @JsonKey(name: 'end_date') required DateTime endDate,
    
    /// ID of the school this year belongs to
    @JsonKey(name: 'school_id') required String schoolId,
    
    /// Year label (e.g., "2023/2024")
    required String year,
    
    /// Whether to show this year on calendars
    @JsonKey(name: 'show_on_calendars') @Default(false) bool showOnCalendars,
    
    /// User ID who owns this school year
    @JsonKey(name: 'user_id') required String userId,
    
    /// Creation timestamp
    @JsonKey(name: 'created_at') required DateTime createdAt,
    
    /// Last update timestamp
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SchoolYearModel;

  factory SchoolYearModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolYearModelFromJson(json);
}

/// School term model representing a term within a school year
@freezed
class SchoolTermModel with _$SchoolTermModel {
  const factory SchoolTermModel({
    /// Unique identifier for the school term
    required String id,
    
    /// Name of the term (e.g., "Fall Term", "Spring Semester")
    required String name,
    
    /// Start date of the term
    @JsonKey(name: 'start_date') required DateTime startDate,
    
    /// End date of the term
    @JsonKey(name: 'end_date') required DateTime endDate,
    
    /// ID of the school year this term belongs to
    @JsonKey(name: 'school_year_id') required String schoolYearId,
    
    /// Whether to show this term on calendars
    @JsonKey(name: 'show_on_calendars') @Default(false) bool showOnCalendars,
    
    /// Whether to show only start and end dates (not the full duration)
    @JsonKey(name: 'show_only_start_and_end') @Default(true) bool showOnlyStartAndEnd,
    
    /// User ID who owns this school term
    @JsonKey(name: 'user_id') required String userId,
    
    /// Creation timestamp
    @JsonKey(name: 'created_at') required DateTime createdAt,
    
    /// Last update timestamp
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SchoolTermModel;

  factory SchoolTermModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolTermModelFromJson(json);
}

/// School break model representing a break within a school year
@freezed
class SchoolBreakModel with _$SchoolBreakModel {
  const factory SchoolBreakModel({
    /// Unique identifier for the school break
    required String id,
    
    /// Name of the break (e.g., "Winter Break", "Spring Break")
    required String name,
    
    /// Start date of the break
    @JsonKey(name: 'start_date') required DateTime startDate,
    
    /// End date of the break
    @JsonKey(name: 'end_date') required DateTime endDate,
    
    /// ID of the school year this break belongs to
    @JsonKey(name: 'school_year_id') required String schoolYearId,
    
    /// Whether to show this break on calendars
    @JsonKey(name: 'show_on_calendars') @Default(false) bool showOnCalendars,
    
    /// User ID who owns this school break
    @JsonKey(name: 'user_id') required String userId,
    
    /// Creation timestamp
    @JsonKey(name: 'created_at') required DateTime createdAt,
    
    /// Last update timestamp
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SchoolBreakModel;

  factory SchoolBreakModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolBreakModelFromJson(json);
}

/// Combined model for organizing school terms data
@freezed
class SchoolTermsData with _$SchoolTermsData {
  const factory SchoolTermsData({
    /// Map of school year ID to school year
    @Default({}) Map<String, SchoolYearModel> schoolYearsById,
    
    /// Map of school year ID to list of terms
    @Default({}) Map<String, List<SchoolTermModel>> termsByYearId,
    
    /// Map of school year ID to list of breaks
    @Default({}) Map<String, List<SchoolBreakModel>> breaksByYearId,
    
    /// Map of term ID to term
    @Default({}) Map<String, SchoolTermModel> termsById,
    
    /// Map of break ID to break
    @Default({}) Map<String, SchoolBreakModel> breaksById,
  }) = _SchoolTermsData;

  factory SchoolTermsData.fromJson(Map<String, dynamic> json) =>
      _$SchoolTermsDataFromJson(json);
}

/// Enum for different school term types
enum SchoolTermType {
  /// Regular academic term/semester
  term,
  
  /// Summer session
  summer,
  
  /// Intersession/winter session
  intersession,
  
  /// Quarter system term
  quarter,
} 