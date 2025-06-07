// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'career_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CareerGoal _$CareerGoalFromJson(Map<String, dynamic> json) {
  return _CareerGoal.fromJson(json);
}

/// @nodoc
mixin _$CareerGoal {
  String? get id => throw _privateConstructorUsedError; // UUID from Supabase
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_date')
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; // e.g., Not Started, In Progress, Achieved, On Hold
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this CareerGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CareerGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CareerGoalCopyWith<CareerGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CareerGoalCopyWith<$Res> {
  factory $CareerGoalCopyWith(
          CareerGoal value, $Res Function(CareerGoal) then) =
      _$CareerGoalCopyWithImpl<$Res, CareerGoal>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String title,
      String? description,
      @JsonKey(name: 'target_date') DateTime? targetDate,
      String? status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String resourceType});
}

/// @nodoc
class _$CareerGoalCopyWithImpl<$Res, $Val extends CareerGoal>
    implements $CareerGoalCopyWith<$Res> {
  _$CareerGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CareerGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? targetDate = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CareerGoalImplCopyWith<$Res>
    implements $CareerGoalCopyWith<$Res> {
  factory _$$CareerGoalImplCopyWith(
          _$CareerGoalImpl value, $Res Function(_$CareerGoalImpl) then) =
      __$$CareerGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String title,
      String? description,
      @JsonKey(name: 'target_date') DateTime? targetDate,
      String? status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String resourceType});
}

/// @nodoc
class __$$CareerGoalImplCopyWithImpl<$Res>
    extends _$CareerGoalCopyWithImpl<$Res, _$CareerGoalImpl>
    implements _$$CareerGoalImplCopyWith<$Res> {
  __$$CareerGoalImplCopyWithImpl(
      _$CareerGoalImpl _value, $Res Function(_$CareerGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of CareerGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? targetDate = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$CareerGoalImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CareerGoalImpl implements _CareerGoal {
  const _$CareerGoalImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      required this.title,
      this.description,
      @JsonKey(name: 'target_date') this.targetDate,
      this.status,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.resourceType = 'CareerGoal'});

  factory _$CareerGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$CareerGoalImplFromJson(json);

  @override
  final String? id;
// UUID from Supabase
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_date')
  final DateTime? targetDate;
  @override
  final String? status;
// e.g., Not Started, In Progress, Achieved, On Hold
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'CareerGoal(id: $id, userId: $userId, title: $title, description: $description, targetDate: $targetDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CareerGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, title, description,
      targetDate, status, createdAt, updatedAt, resourceType);

  /// Create a copy of CareerGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CareerGoalImplCopyWith<_$CareerGoalImpl> get copyWith =>
      __$$CareerGoalImplCopyWithImpl<_$CareerGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CareerGoalImplToJson(
      this,
    );
  }
}

abstract class _CareerGoal implements CareerGoal {
  const factory _CareerGoal(
      {final String? id,
      @JsonKey(name: 'user_id') final String? userId,
      required final String title,
      final String? description,
      @JsonKey(name: 'target_date') final DateTime? targetDate,
      final String? status,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final String resourceType}) = _$CareerGoalImpl;

  factory _CareerGoal.fromJson(Map<String, dynamic> json) =
      _$CareerGoalImpl.fromJson;

  @override
  String? get id; // UUID from Supabase
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_date')
  DateTime? get targetDate;
  @override
  String? get status; // e.g., Not Started, In Progress, Achieved, On Hold
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  String get resourceType;

  /// Create a copy of CareerGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CareerGoalImplCopyWith<_$CareerGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return _Employee.fromJson(json);
}

/// @nodoc
mixin _$Employee {
  String? get id => throw _privateConstructorUsedError; // UUID from Supabase
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_title')
  String get jobTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_current_job', defaultValue: true)
  bool? get isCurrentJob => throw _privateConstructorUsedError;
  String? get responsibilities => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_name')
  String? get managerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_email')
  String? get managerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_review_date')
  DateTime? get nextReviewDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get resourceType => throw _privateConstructorUsedError;

  /// Serializes this Employee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeCopyWith<Employee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeCopyWith<$Res> {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) then) =
      _$EmployeeCopyWithImpl<$Res, Employee>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'job_title') String jobTitle,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current_job', defaultValue: true) bool? isCurrentJob,
      String? responsibilities,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'manager_email') String? managerEmail,
      @JsonKey(name: 'next_review_date') DateTime? nextReviewDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String resourceType});
}

/// @nodoc
class _$EmployeeCopyWithImpl<$Res, $Val extends Employee>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? companyName = null,
    Object? jobTitle = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrentJob = freezed,
    Object? responsibilities = freezed,
    Object? managerName = freezed,
    Object? managerEmail = freezed,
    Object? nextReviewDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? resourceType = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrentJob: freezed == isCurrentJob
          ? _value.isCurrentJob
          : isCurrentJob // ignore: cast_nullable_to_non_nullable
              as bool?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      managerEmail: freezed == managerEmail
          ? _value.managerEmail
          : managerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      nextReviewDate: freezed == nextReviewDate
          ? _value.nextReviewDate
          : nextReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeImplCopyWith<$Res>
    implements $EmployeeCopyWith<$Res> {
  factory _$$EmployeeImplCopyWith(
          _$EmployeeImpl value, $Res Function(_$EmployeeImpl) then) =
      __$$EmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'job_title') String jobTitle,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current_job', defaultValue: true) bool? isCurrentJob,
      String? responsibilities,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'manager_email') String? managerEmail,
      @JsonKey(name: 'next_review_date') DateTime? nextReviewDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      String resourceType});
}

/// @nodoc
class __$$EmployeeImplCopyWithImpl<$Res>
    extends _$EmployeeCopyWithImpl<$Res, _$EmployeeImpl>
    implements _$$EmployeeImplCopyWith<$Res> {
  __$$EmployeeImplCopyWithImpl(
      _$EmployeeImpl _value, $Res Function(_$EmployeeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? companyName = null,
    Object? jobTitle = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrentJob = freezed,
    Object? responsibilities = freezed,
    Object? managerName = freezed,
    Object? managerEmail = freezed,
    Object? nextReviewDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? resourceType = null,
  }) {
    return _then(_$EmployeeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrentJob: freezed == isCurrentJob
          ? _value.isCurrentJob
          : isCurrentJob // ignore: cast_nullable_to_non_nullable
              as bool?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      managerEmail: freezed == managerEmail
          ? _value.managerEmail
          : managerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      nextReviewDate: freezed == nextReviewDate
          ? _value.nextReviewDate
          : nextReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeImpl implements _Employee {
  const _$EmployeeImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'company_name') required this.companyName,
      @JsonKey(name: 'job_title') required this.jobTitle,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'is_current_job', defaultValue: true) this.isCurrentJob,
      this.responsibilities,
      @JsonKey(name: 'manager_name') this.managerName,
      @JsonKey(name: 'manager_email') this.managerEmail,
      @JsonKey(name: 'next_review_date') this.nextReviewDate,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.resourceType = 'Employee'});

  factory _$EmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeImplFromJson(json);

  @override
  final String? id;
// UUID from Supabase
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'job_title')
  final String jobTitle;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'is_current_job', defaultValue: true)
  final bool? isCurrentJob;
  @override
  final String? responsibilities;
  @override
  @JsonKey(name: 'manager_name')
  final String? managerName;
  @override
  @JsonKey(name: 'manager_email')
  final String? managerEmail;
  @override
  @JsonKey(name: 'next_review_date')
  final DateTime? nextReviewDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final String resourceType;

  @override
  String toString() {
    return 'Employee(id: $id, userId: $userId, companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate, endDate: $endDate, isCurrentJob: $isCurrentJob, responsibilities: $responsibilities, managerName: $managerName, managerEmail: $managerEmail, nextReviewDate: $nextReviewDate, createdAt: $createdAt, updatedAt: $updatedAt, resourceType: $resourceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrentJob, isCurrentJob) ||
                other.isCurrentJob == isCurrentJob) &&
            (identical(other.responsibilities, responsibilities) ||
                other.responsibilities == responsibilities) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.managerEmail, managerEmail) ||
                other.managerEmail == managerEmail) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      companyName,
      jobTitle,
      startDate,
      endDate,
      isCurrentJob,
      responsibilities,
      managerName,
      managerEmail,
      nextReviewDate,
      createdAt,
      updatedAt,
      resourceType);

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      __$$EmployeeImplCopyWithImpl<_$EmployeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeImplToJson(
      this,
    );
  }
}

abstract class _Employee implements Employee {
  const factory _Employee(
      {final String? id,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'company_name') required final String companyName,
      @JsonKey(name: 'job_title') required final String jobTitle,
      @JsonKey(name: 'start_date') final DateTime? startDate,
      @JsonKey(name: 'end_date') final DateTime? endDate,
      @JsonKey(name: 'is_current_job', defaultValue: true)
      final bool? isCurrentJob,
      final String? responsibilities,
      @JsonKey(name: 'manager_name') final String? managerName,
      @JsonKey(name: 'manager_email') final String? managerEmail,
      @JsonKey(name: 'next_review_date') final DateTime? nextReviewDate,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final String resourceType}) = _$EmployeeImpl;

  factory _Employee.fromJson(Map<String, dynamic> json) =
      _$EmployeeImpl.fromJson;

  @override
  String? get id; // UUID from Supabase
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'job_title')
  String get jobTitle;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'is_current_job', defaultValue: true)
  bool? get isCurrentJob;
  @override
  String? get responsibilities;
  @override
  @JsonKey(name: 'manager_name')
  String? get managerName;
  @override
  @JsonKey(name: 'manager_email')
  String? get managerEmail;
  @override
  @JsonKey(name: 'next_review_date')
  DateTime? get nextReviewDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  String get resourceType;

  /// Create a copy of Employee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
