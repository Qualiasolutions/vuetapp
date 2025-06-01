// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school_terms_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchoolYearModel _$SchoolYearModelFromJson(Map<String, dynamic> json) {
  return _SchoolYearModel.fromJson(json);
}

/// @nodoc
mixin _$SchoolYearModel {
  /// Unique identifier for the school year
  String get id => throw _privateConstructorUsedError;

  /// Start date of the school year
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;

  /// End date of the school year
  @JsonKey(name: 'end_date')
  DateTime get endDate => throw _privateConstructorUsedError;

  /// ID of the school this year belongs to
  @JsonKey(name: 'school_id')
  String get schoolId => throw _privateConstructorUsedError;

  /// Year label (e.g., "2023/2024")
  String get year => throw _privateConstructorUsedError;

  /// Whether to show this year on calendars
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars => throw _privateConstructorUsedError;

  /// User ID who owns this school year
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// Creation timestamp
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SchoolYearModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolYearModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolYearModelCopyWith<SchoolYearModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolYearModelCopyWith<$Res> {
  factory $SchoolYearModelCopyWith(
          SchoolYearModel value, $Res Function(SchoolYearModel) then) =
      _$SchoolYearModelCopyWithImpl<$Res, SchoolYearModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_id') String schoolId,
      String year,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SchoolYearModelCopyWithImpl<$Res, $Val extends SchoolYearModel>
    implements $SchoolYearModelCopyWith<$Res> {
  _$SchoolYearModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolYearModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolId = null,
    Object? year = null,
    Object? showOnCalendars = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolId: null == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolYearModelImplCopyWith<$Res>
    implements $SchoolYearModelCopyWith<$Res> {
  factory _$$SchoolYearModelImplCopyWith(_$SchoolYearModelImpl value,
          $Res Function(_$SchoolYearModelImpl) then) =
      __$$SchoolYearModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_id') String schoolId,
      String year,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SchoolYearModelImplCopyWithImpl<$Res>
    extends _$SchoolYearModelCopyWithImpl<$Res, _$SchoolYearModelImpl>
    implements _$$SchoolYearModelImplCopyWith<$Res> {
  __$$SchoolYearModelImplCopyWithImpl(
      _$SchoolYearModelImpl _value, $Res Function(_$SchoolYearModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolYearModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolId = null,
    Object? year = null,
    Object? showOnCalendars = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SchoolYearModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolId: null == schoolId
          ? _value.schoolId
          : schoolId // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolYearModelImpl implements _SchoolYearModel {
  const _$SchoolYearModelImpl(
      {required this.id,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'school_id') required this.schoolId,
      required this.year,
      @JsonKey(name: 'show_on_calendars') this.showOnCalendars = false,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SchoolYearModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolYearModelImplFromJson(json);

  /// Unique identifier for the school year
  @override
  final String id;

  /// Start date of the school year
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;

  /// End date of the school year
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  /// ID of the school this year belongs to
  @override
  @JsonKey(name: 'school_id')
  final String schoolId;

  /// Year label (e.g., "2023/2024")
  @override
  final String year;

  /// Whether to show this year on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  final bool showOnCalendars;

  /// User ID who owns this school year
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SchoolYearModel(id: $id, startDate: $startDate, endDate: $endDate, schoolId: $schoolId, year: $year, showOnCalendars: $showOnCalendars, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolYearModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.schoolId, schoolId) ||
                other.schoolId == schoolId) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.showOnCalendars, showOnCalendars) ||
                other.showOnCalendars == showOnCalendars) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startDate, endDate, schoolId,
      year, showOnCalendars, userId, createdAt, updatedAt);

  /// Create a copy of SchoolYearModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolYearModelImplCopyWith<_$SchoolYearModelImpl> get copyWith =>
      __$$SchoolYearModelImplCopyWithImpl<_$SchoolYearModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolYearModelImplToJson(
      this,
    );
  }
}

abstract class _SchoolYearModel implements SchoolYearModel {
  const factory _SchoolYearModel(
          {required final String id,
          @JsonKey(name: 'start_date') required final DateTime startDate,
          @JsonKey(name: 'end_date') required final DateTime endDate,
          @JsonKey(name: 'school_id') required final String schoolId,
          required final String year,
          @JsonKey(name: 'show_on_calendars') final bool showOnCalendars,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$SchoolYearModelImpl;

  factory _SchoolYearModel.fromJson(Map<String, dynamic> json) =
      _$SchoolYearModelImpl.fromJson;

  /// Unique identifier for the school year
  @override
  String get id;

  /// Start date of the school year
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;

  /// End date of the school year
  @override
  @JsonKey(name: 'end_date')
  DateTime get endDate;

  /// ID of the school this year belongs to
  @override
  @JsonKey(name: 'school_id')
  String get schoolId;

  /// Year label (e.g., "2023/2024")
  @override
  String get year;

  /// Whether to show this year on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars;

  /// User ID who owns this school year
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SchoolYearModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolYearModelImplCopyWith<_$SchoolYearModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchoolTermModel _$SchoolTermModelFromJson(Map<String, dynamic> json) {
  return _SchoolTermModel.fromJson(json);
}

/// @nodoc
mixin _$SchoolTermModel {
  /// Unique identifier for the school term
  String get id => throw _privateConstructorUsedError;

  /// Name of the term (e.g., "Fall Term", "Spring Semester")
  String get name => throw _privateConstructorUsedError;

  /// Start date of the term
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;

  /// End date of the term
  @JsonKey(name: 'end_date')
  DateTime get endDate => throw _privateConstructorUsedError;

  /// ID of the school year this term belongs to
  @JsonKey(name: 'school_year_id')
  String get schoolYearId => throw _privateConstructorUsedError;

  /// Whether to show this term on calendars
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars => throw _privateConstructorUsedError;

  /// Whether to show only start and end dates (not the full duration)
  @JsonKey(name: 'show_only_start_and_end')
  bool get showOnlyStartAndEnd => throw _privateConstructorUsedError;

  /// User ID who owns this school term
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// Creation timestamp
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SchoolTermModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolTermModelCopyWith<SchoolTermModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolTermModelCopyWith<$Res> {
  factory $SchoolTermModelCopyWith(
          SchoolTermModel value, $Res Function(SchoolTermModel) then) =
      _$SchoolTermModelCopyWithImpl<$Res, SchoolTermModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_year_id') String schoolYearId,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'show_only_start_and_end') bool showOnlyStartAndEnd,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SchoolTermModelCopyWithImpl<$Res, $Val extends SchoolTermModel>
    implements $SchoolTermModelCopyWith<$Res> {
  _$SchoolTermModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolYearId = null,
    Object? showOnCalendars = null,
    Object? showOnlyStartAndEnd = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolYearId: null == schoolYearId
          ? _value.schoolYearId
          : schoolYearId // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnlyStartAndEnd: null == showOnlyStartAndEnd
          ? _value.showOnlyStartAndEnd
          : showOnlyStartAndEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolTermModelImplCopyWith<$Res>
    implements $SchoolTermModelCopyWith<$Res> {
  factory _$$SchoolTermModelImplCopyWith(_$SchoolTermModelImpl value,
          $Res Function(_$SchoolTermModelImpl) then) =
      __$$SchoolTermModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_year_id') String schoolYearId,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'show_only_start_and_end') bool showOnlyStartAndEnd,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SchoolTermModelImplCopyWithImpl<$Res>
    extends _$SchoolTermModelCopyWithImpl<$Res, _$SchoolTermModelImpl>
    implements _$$SchoolTermModelImplCopyWith<$Res> {
  __$$SchoolTermModelImplCopyWithImpl(
      _$SchoolTermModelImpl _value, $Res Function(_$SchoolTermModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolTermModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolYearId = null,
    Object? showOnCalendars = null,
    Object? showOnlyStartAndEnd = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SchoolTermModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolYearId: null == schoolYearId
          ? _value.schoolYearId
          : schoolYearId // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnlyStartAndEnd: null == showOnlyStartAndEnd
          ? _value.showOnlyStartAndEnd
          : showOnlyStartAndEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolTermModelImpl implements _SchoolTermModel {
  const _$SchoolTermModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'school_year_id') required this.schoolYearId,
      @JsonKey(name: 'show_on_calendars') this.showOnCalendars = false,
      @JsonKey(name: 'show_only_start_and_end') this.showOnlyStartAndEnd = true,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SchoolTermModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolTermModelImplFromJson(json);

  /// Unique identifier for the school term
  @override
  final String id;

  /// Name of the term (e.g., "Fall Term", "Spring Semester")
  @override
  final String name;

  /// Start date of the term
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;

  /// End date of the term
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  /// ID of the school year this term belongs to
  @override
  @JsonKey(name: 'school_year_id')
  final String schoolYearId;

  /// Whether to show this term on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  final bool showOnCalendars;

  /// Whether to show only start and end dates (not the full duration)
  @override
  @JsonKey(name: 'show_only_start_and_end')
  final bool showOnlyStartAndEnd;

  /// User ID who owns this school term
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SchoolTermModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, schoolYearId: $schoolYearId, showOnCalendars: $showOnCalendars, showOnlyStartAndEnd: $showOnlyStartAndEnd, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolTermModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.schoolYearId, schoolYearId) ||
                other.schoolYearId == schoolYearId) &&
            (identical(other.showOnCalendars, showOnCalendars) ||
                other.showOnCalendars == showOnCalendars) &&
            (identical(other.showOnlyStartAndEnd, showOnlyStartAndEnd) ||
                other.showOnlyStartAndEnd == showOnlyStartAndEnd) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      startDate,
      endDate,
      schoolYearId,
      showOnCalendars,
      showOnlyStartAndEnd,
      userId,
      createdAt,
      updatedAt);

  /// Create a copy of SchoolTermModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolTermModelImplCopyWith<_$SchoolTermModelImpl> get copyWith =>
      __$$SchoolTermModelImplCopyWithImpl<_$SchoolTermModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolTermModelImplToJson(
      this,
    );
  }
}

abstract class _SchoolTermModel implements SchoolTermModel {
  const factory _SchoolTermModel(
      {required final String id,
      required final String name,
      @JsonKey(name: 'start_date') required final DateTime startDate,
      @JsonKey(name: 'end_date') required final DateTime endDate,
      @JsonKey(name: 'school_year_id') required final String schoolYearId,
      @JsonKey(name: 'show_on_calendars') final bool showOnCalendars,
      @JsonKey(name: 'show_only_start_and_end') final bool showOnlyStartAndEnd,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$SchoolTermModelImpl;

  factory _SchoolTermModel.fromJson(Map<String, dynamic> json) =
      _$SchoolTermModelImpl.fromJson;

  /// Unique identifier for the school term
  @override
  String get id;

  /// Name of the term (e.g., "Fall Term", "Spring Semester")
  @override
  String get name;

  /// Start date of the term
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;

  /// End date of the term
  @override
  @JsonKey(name: 'end_date')
  DateTime get endDate;

  /// ID of the school year this term belongs to
  @override
  @JsonKey(name: 'school_year_id')
  String get schoolYearId;

  /// Whether to show this term on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars;

  /// Whether to show only start and end dates (not the full duration)
  @override
  @JsonKey(name: 'show_only_start_and_end')
  bool get showOnlyStartAndEnd;

  /// User ID who owns this school term
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SchoolTermModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolTermModelImplCopyWith<_$SchoolTermModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchoolBreakModel _$SchoolBreakModelFromJson(Map<String, dynamic> json) {
  return _SchoolBreakModel.fromJson(json);
}

/// @nodoc
mixin _$SchoolBreakModel {
  /// Unique identifier for the school break
  String get id => throw _privateConstructorUsedError;

  /// Name of the break (e.g., "Winter Break", "Spring Break")
  String get name => throw _privateConstructorUsedError;

  /// Start date of the break
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;

  /// End date of the break
  @JsonKey(name: 'end_date')
  DateTime get endDate => throw _privateConstructorUsedError;

  /// ID of the school year this break belongs to
  @JsonKey(name: 'school_year_id')
  String get schoolYearId => throw _privateConstructorUsedError;

  /// Whether to show this break on calendars
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars => throw _privateConstructorUsedError;

  /// User ID who owns this school break
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// Creation timestamp
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SchoolBreakModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolBreakModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolBreakModelCopyWith<SchoolBreakModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolBreakModelCopyWith<$Res> {
  factory $SchoolBreakModelCopyWith(
          SchoolBreakModel value, $Res Function(SchoolBreakModel) then) =
      _$SchoolBreakModelCopyWithImpl<$Res, SchoolBreakModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_year_id') String schoolYearId,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SchoolBreakModelCopyWithImpl<$Res, $Val extends SchoolBreakModel>
    implements $SchoolBreakModelCopyWith<$Res> {
  _$SchoolBreakModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolBreakModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolYearId = null,
    Object? showOnCalendars = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolYearId: null == schoolYearId
          ? _value.schoolYearId
          : schoolYearId // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolBreakModelImplCopyWith<$Res>
    implements $SchoolBreakModelCopyWith<$Res> {
  factory _$$SchoolBreakModelImplCopyWith(_$SchoolBreakModelImpl value,
          $Res Function(_$SchoolBreakModelImpl) then) =
      __$$SchoolBreakModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'school_year_id') String schoolYearId,
      @JsonKey(name: 'show_on_calendars') bool showOnCalendars,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SchoolBreakModelImplCopyWithImpl<$Res>
    extends _$SchoolBreakModelCopyWithImpl<$Res, _$SchoolBreakModelImpl>
    implements _$$SchoolBreakModelImplCopyWith<$Res> {
  __$$SchoolBreakModelImplCopyWithImpl(_$SchoolBreakModelImpl _value,
      $Res Function(_$SchoolBreakModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolBreakModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? schoolYearId = null,
    Object? showOnCalendars = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SchoolBreakModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schoolYearId: null == schoolYearId
          ? _value.schoolYearId
          : schoolYearId // ignore: cast_nullable_to_non_nullable
              as String,
      showOnCalendars: null == showOnCalendars
          ? _value.showOnCalendars
          : showOnCalendars // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolBreakModelImpl implements _SchoolBreakModel {
  const _$SchoolBreakModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'school_year_id') required this.schoolYearId,
      @JsonKey(name: 'show_on_calendars') this.showOnCalendars = false,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SchoolBreakModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolBreakModelImplFromJson(json);

  /// Unique identifier for the school break
  @override
  final String id;

  /// Name of the break (e.g., "Winter Break", "Spring Break")
  @override
  final String name;

  /// Start date of the break
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;

  /// End date of the break
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  /// ID of the school year this break belongs to
  @override
  @JsonKey(name: 'school_year_id')
  final String schoolYearId;

  /// Whether to show this break on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  final bool showOnCalendars;

  /// User ID who owns this school break
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SchoolBreakModel(id: $id, name: $name, startDate: $startDate, endDate: $endDate, schoolYearId: $schoolYearId, showOnCalendars: $showOnCalendars, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolBreakModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.schoolYearId, schoolYearId) ||
                other.schoolYearId == schoolYearId) &&
            (identical(other.showOnCalendars, showOnCalendars) ||
                other.showOnCalendars == showOnCalendars) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, startDate, endDate,
      schoolYearId, showOnCalendars, userId, createdAt, updatedAt);

  /// Create a copy of SchoolBreakModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolBreakModelImplCopyWith<_$SchoolBreakModelImpl> get copyWith =>
      __$$SchoolBreakModelImplCopyWithImpl<_$SchoolBreakModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolBreakModelImplToJson(
      this,
    );
  }
}

abstract class _SchoolBreakModel implements SchoolBreakModel {
  const factory _SchoolBreakModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'start_date') required final DateTime startDate,
          @JsonKey(name: 'end_date') required final DateTime endDate,
          @JsonKey(name: 'school_year_id') required final String schoolYearId,
          @JsonKey(name: 'show_on_calendars') final bool showOnCalendars,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$SchoolBreakModelImpl;

  factory _SchoolBreakModel.fromJson(Map<String, dynamic> json) =
      _$SchoolBreakModelImpl.fromJson;

  /// Unique identifier for the school break
  @override
  String get id;

  /// Name of the break (e.g., "Winter Break", "Spring Break")
  @override
  String get name;

  /// Start date of the break
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;

  /// End date of the break
  @override
  @JsonKey(name: 'end_date')
  DateTime get endDate;

  /// ID of the school year this break belongs to
  @override
  @JsonKey(name: 'school_year_id')
  String get schoolYearId;

  /// Whether to show this break on calendars
  @override
  @JsonKey(name: 'show_on_calendars')
  bool get showOnCalendars;

  /// User ID who owns this school break
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// Creation timestamp
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Last update timestamp
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SchoolBreakModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolBreakModelImplCopyWith<_$SchoolBreakModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchoolTermsData _$SchoolTermsDataFromJson(Map<String, dynamic> json) {
  return _SchoolTermsData.fromJson(json);
}

/// @nodoc
mixin _$SchoolTermsData {
  /// Map of school year ID to school year
  Map<String, SchoolYearModel> get schoolYearsById =>
      throw _privateConstructorUsedError;

  /// Map of school year ID to list of terms
  Map<String, List<SchoolTermModel>> get termsByYearId =>
      throw _privateConstructorUsedError;

  /// Map of school year ID to list of breaks
  Map<String, List<SchoolBreakModel>> get breaksByYearId =>
      throw _privateConstructorUsedError;

  /// Map of term ID to term
  Map<String, SchoolTermModel> get termsById =>
      throw _privateConstructorUsedError;

  /// Map of break ID to break
  Map<String, SchoolBreakModel> get breaksById =>
      throw _privateConstructorUsedError;

  /// Serializes this SchoolTermsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolTermsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolTermsDataCopyWith<SchoolTermsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolTermsDataCopyWith<$Res> {
  factory $SchoolTermsDataCopyWith(
          SchoolTermsData value, $Res Function(SchoolTermsData) then) =
      _$SchoolTermsDataCopyWithImpl<$Res, SchoolTermsData>;
  @useResult
  $Res call(
      {Map<String, SchoolYearModel> schoolYearsById,
      Map<String, List<SchoolTermModel>> termsByYearId,
      Map<String, List<SchoolBreakModel>> breaksByYearId,
      Map<String, SchoolTermModel> termsById,
      Map<String, SchoolBreakModel> breaksById});
}

/// @nodoc
class _$SchoolTermsDataCopyWithImpl<$Res, $Val extends SchoolTermsData>
    implements $SchoolTermsDataCopyWith<$Res> {
  _$SchoolTermsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolTermsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schoolYearsById = null,
    Object? termsByYearId = null,
    Object? breaksByYearId = null,
    Object? termsById = null,
    Object? breaksById = null,
  }) {
    return _then(_value.copyWith(
      schoolYearsById: null == schoolYearsById
          ? _value.schoolYearsById
          : schoolYearsById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolYearModel>,
      termsByYearId: null == termsByYearId
          ? _value.termsByYearId
          : termsByYearId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SchoolTermModel>>,
      breaksByYearId: null == breaksByYearId
          ? _value.breaksByYearId
          : breaksByYearId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SchoolBreakModel>>,
      termsById: null == termsById
          ? _value.termsById
          : termsById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolTermModel>,
      breaksById: null == breaksById
          ? _value.breaksById
          : breaksById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolBreakModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchoolTermsDataImplCopyWith<$Res>
    implements $SchoolTermsDataCopyWith<$Res> {
  factory _$$SchoolTermsDataImplCopyWith(_$SchoolTermsDataImpl value,
          $Res Function(_$SchoolTermsDataImpl) then) =
      __$$SchoolTermsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, SchoolYearModel> schoolYearsById,
      Map<String, List<SchoolTermModel>> termsByYearId,
      Map<String, List<SchoolBreakModel>> breaksByYearId,
      Map<String, SchoolTermModel> termsById,
      Map<String, SchoolBreakModel> breaksById});
}

/// @nodoc
class __$$SchoolTermsDataImplCopyWithImpl<$Res>
    extends _$SchoolTermsDataCopyWithImpl<$Res, _$SchoolTermsDataImpl>
    implements _$$SchoolTermsDataImplCopyWith<$Res> {
  __$$SchoolTermsDataImplCopyWithImpl(
      _$SchoolTermsDataImpl _value, $Res Function(_$SchoolTermsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchoolTermsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schoolYearsById = null,
    Object? termsByYearId = null,
    Object? breaksByYearId = null,
    Object? termsById = null,
    Object? breaksById = null,
  }) {
    return _then(_$SchoolTermsDataImpl(
      schoolYearsById: null == schoolYearsById
          ? _value._schoolYearsById
          : schoolYearsById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolYearModel>,
      termsByYearId: null == termsByYearId
          ? _value._termsByYearId
          : termsByYearId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SchoolTermModel>>,
      breaksByYearId: null == breaksByYearId
          ? _value._breaksByYearId
          : breaksByYearId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<SchoolBreakModel>>,
      termsById: null == termsById
          ? _value._termsById
          : termsById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolTermModel>,
      breaksById: null == breaksById
          ? _value._breaksById
          : breaksById // ignore: cast_nullable_to_non_nullable
              as Map<String, SchoolBreakModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchoolTermsDataImpl implements _SchoolTermsData {
  const _$SchoolTermsDataImpl(
      {final Map<String, SchoolYearModel> schoolYearsById = const {},
      final Map<String, List<SchoolTermModel>> termsByYearId = const {},
      final Map<String, List<SchoolBreakModel>> breaksByYearId = const {},
      final Map<String, SchoolTermModel> termsById = const {},
      final Map<String, SchoolBreakModel> breaksById = const {}})
      : _schoolYearsById = schoolYearsById,
        _termsByYearId = termsByYearId,
        _breaksByYearId = breaksByYearId,
        _termsById = termsById,
        _breaksById = breaksById;

  factory _$SchoolTermsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolTermsDataImplFromJson(json);

  /// Map of school year ID to school year
  final Map<String, SchoolYearModel> _schoolYearsById;

  /// Map of school year ID to school year
  @override
  @JsonKey()
  Map<String, SchoolYearModel> get schoolYearsById {
    if (_schoolYearsById is EqualUnmodifiableMapView) return _schoolYearsById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_schoolYearsById);
  }

  /// Map of school year ID to list of terms
  final Map<String, List<SchoolTermModel>> _termsByYearId;

  /// Map of school year ID to list of terms
  @override
  @JsonKey()
  Map<String, List<SchoolTermModel>> get termsByYearId {
    if (_termsByYearId is EqualUnmodifiableMapView) return _termsByYearId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_termsByYearId);
  }

  /// Map of school year ID to list of breaks
  final Map<String, List<SchoolBreakModel>> _breaksByYearId;

  /// Map of school year ID to list of breaks
  @override
  @JsonKey()
  Map<String, List<SchoolBreakModel>> get breaksByYearId {
    if (_breaksByYearId is EqualUnmodifiableMapView) return _breaksByYearId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_breaksByYearId);
  }

  /// Map of term ID to term
  final Map<String, SchoolTermModel> _termsById;

  /// Map of term ID to term
  @override
  @JsonKey()
  Map<String, SchoolTermModel> get termsById {
    if (_termsById is EqualUnmodifiableMapView) return _termsById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_termsById);
  }

  /// Map of break ID to break
  final Map<String, SchoolBreakModel> _breaksById;

  /// Map of break ID to break
  @override
  @JsonKey()
  Map<String, SchoolBreakModel> get breaksById {
    if (_breaksById is EqualUnmodifiableMapView) return _breaksById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_breaksById);
  }

  @override
  String toString() {
    return 'SchoolTermsData(schoolYearsById: $schoolYearsById, termsByYearId: $termsByYearId, breaksByYearId: $breaksByYearId, termsById: $termsById, breaksById: $breaksById)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolTermsDataImpl &&
            const DeepCollectionEquality()
                .equals(other._schoolYearsById, _schoolYearsById) &&
            const DeepCollectionEquality()
                .equals(other._termsByYearId, _termsByYearId) &&
            const DeepCollectionEquality()
                .equals(other._breaksByYearId, _breaksByYearId) &&
            const DeepCollectionEquality()
                .equals(other._termsById, _termsById) &&
            const DeepCollectionEquality()
                .equals(other._breaksById, _breaksById));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_schoolYearsById),
      const DeepCollectionEquality().hash(_termsByYearId),
      const DeepCollectionEquality().hash(_breaksByYearId),
      const DeepCollectionEquality().hash(_termsById),
      const DeepCollectionEquality().hash(_breaksById));

  /// Create a copy of SchoolTermsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolTermsDataImplCopyWith<_$SchoolTermsDataImpl> get copyWith =>
      __$$SchoolTermsDataImplCopyWithImpl<_$SchoolTermsDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolTermsDataImplToJson(
      this,
    );
  }
}

abstract class _SchoolTermsData implements SchoolTermsData {
  const factory _SchoolTermsData(
      {final Map<String, SchoolYearModel> schoolYearsById,
      final Map<String, List<SchoolTermModel>> termsByYearId,
      final Map<String, List<SchoolBreakModel>> breaksByYearId,
      final Map<String, SchoolTermModel> termsById,
      final Map<String, SchoolBreakModel> breaksById}) = _$SchoolTermsDataImpl;

  factory _SchoolTermsData.fromJson(Map<String, dynamic> json) =
      _$SchoolTermsDataImpl.fromJson;

  /// Map of school year ID to school year
  @override
  Map<String, SchoolYearModel> get schoolYearsById;

  /// Map of school year ID to list of terms
  @override
  Map<String, List<SchoolTermModel>> get termsByYearId;

  /// Map of school year ID to list of breaks
  @override
  Map<String, List<SchoolBreakModel>> get breaksByYearId;

  /// Map of term ID to term
  @override
  Map<String, SchoolTermModel> get termsById;

  /// Map of break ID to break
  @override
  Map<String, SchoolBreakModel> get breaksById;

  /// Create a copy of SchoolTermsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolTermsDataImplCopyWith<_$SchoolTermsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
