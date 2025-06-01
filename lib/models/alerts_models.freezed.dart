// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerts_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) {
  return _AlertModel.fromJson(json);
}

/// @nodoc
mixin _$AlertModel {
  /// Unique identifier for the alert
  String get id => throw _privateConstructorUsedError;

  /// ID of the task this alert is for
  String get taskId => throw _privateConstructorUsedError;

  /// ID of the user this alert belongs to
  String get userId => throw _privateConstructorUsedError;

  /// Type of alert
  AlertType get type => throw _privateConstructorUsedError;

  /// Whether the alert has been read
  bool get read => throw _privateConstructorUsedError;

  /// Optional additional data for the alert
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Creation timestamp
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertModelCopyWith<AlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertModelCopyWith<$Res> {
  factory $AlertModelCopyWith(
          AlertModel value, $Res Function(AlertModel) then) =
      _$AlertModelCopyWithImpl<$Res, AlertModel>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      String userId,
      AlertType type,
      bool read,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$AlertModelCopyWithImpl<$Res, $Val extends AlertModel>
    implements $AlertModelCopyWith<$Res> {
  _$AlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? userId = null,
    Object? type = null,
    Object? read = null,
    Object? additionalData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$AlertModelImplCopyWith<$Res>
    implements $AlertModelCopyWith<$Res> {
  factory _$$AlertModelImplCopyWith(
          _$AlertModelImpl value, $Res Function(_$AlertModelImpl) then) =
      __$$AlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      String userId,
      AlertType type,
      bool read,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$AlertModelImplCopyWithImpl<$Res>
    extends _$AlertModelCopyWithImpl<$Res, _$AlertModelImpl>
    implements _$$AlertModelImplCopyWith<$Res> {
  __$$AlertModelImplCopyWithImpl(
      _$AlertModelImpl _value, $Res Function(_$AlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? userId = null,
    Object? type = null,
    Object? read = null,
    Object? additionalData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$AlertModelImpl implements _AlertModel {
  const _$AlertModelImpl(
      {required this.id,
      required this.taskId,
      required this.userId,
      required this.type,
      this.read = false,
      final Map<String, dynamic>? additionalData,
      required this.createdAt,
      required this.updatedAt})
      : _additionalData = additionalData;

  factory _$AlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertModelImplFromJson(json);

  /// Unique identifier for the alert
  @override
  final String id;

  /// ID of the task this alert is for
  @override
  final String taskId;

  /// ID of the user this alert belongs to
  @override
  final String userId;

  /// Type of alert
  @override
  final AlertType type;

  /// Whether the alert has been read
  @override
  @JsonKey()
  final bool read;

  /// Optional additional data for the alert
  final Map<String, dynamic>? _additionalData;

  /// Optional additional data for the alert
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Creation timestamp
  @override
  final DateTime createdAt;

  /// Last update timestamp
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AlertModel(id: $id, taskId: $taskId, userId: $userId, type: $type, read: $read, additionalData: $additionalData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.read, read) || other.read == read) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData) &&
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
      taskId,
      userId,
      type,
      read,
      const DeepCollectionEquality().hash(_additionalData),
      createdAt,
      updatedAt);

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertModelImplCopyWith<_$AlertModelImpl> get copyWith =>
      __$$AlertModelImplCopyWithImpl<_$AlertModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertModelImplToJson(
      this,
    );
  }
}

abstract class _AlertModel implements AlertModel {
  const factory _AlertModel(
      {required final String id,
      required final String taskId,
      required final String userId,
      required final AlertType type,
      final bool read,
      final Map<String, dynamic>? additionalData,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AlertModelImpl;

  factory _AlertModel.fromJson(Map<String, dynamic> json) =
      _$AlertModelImpl.fromJson;

  /// Unique identifier for the alert
  @override
  String get id;

  /// ID of the task this alert is for
  @override
  String get taskId;

  /// ID of the user this alert belongs to
  @override
  String get userId;

  /// Type of alert
  @override
  AlertType get type;

  /// Whether the alert has been read
  @override
  bool get read;

  /// Optional additional data for the alert
  @override
  Map<String, dynamic>? get additionalData;

  /// Creation timestamp
  @override
  DateTime get createdAt;

  /// Last update timestamp
  @override
  DateTime get updatedAt;

  /// Create a copy of AlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertModelImplCopyWith<_$AlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionAlertModel _$ActionAlertModelFromJson(Map<String, dynamic> json) {
  return _ActionAlertModel.fromJson(json);
}

/// @nodoc
mixin _$ActionAlertModel {
  /// Unique identifier for the action alert
  String get id => throw _privateConstructorUsedError;

  /// ID of the task action this alert is for
  String get actionId => throw _privateConstructorUsedError;

  /// ID of the user this alert belongs to
  String get userId => throw _privateConstructorUsedError;

  /// Type of alert
  AlertType get type => throw _privateConstructorUsedError;

  /// Whether the alert has been read
  bool get read => throw _privateConstructorUsedError;

  /// Optional additional data for the alert
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Creation timestamp
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ActionAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionAlertModelCopyWith<ActionAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionAlertModelCopyWith<$Res> {
  factory $ActionAlertModelCopyWith(
          ActionAlertModel value, $Res Function(ActionAlertModel) then) =
      _$ActionAlertModelCopyWithImpl<$Res, ActionAlertModel>;
  @useResult
  $Res call(
      {String id,
      String actionId,
      String userId,
      AlertType type,
      bool read,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ActionAlertModelCopyWithImpl<$Res, $Val extends ActionAlertModel>
    implements $ActionAlertModelCopyWith<$Res> {
  _$ActionAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actionId = null,
    Object? userId = null,
    Object? type = null,
    Object? read = null,
    Object? additionalData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionId: null == actionId
          ? _value.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$ActionAlertModelImplCopyWith<$Res>
    implements $ActionAlertModelCopyWith<$Res> {
  factory _$$ActionAlertModelImplCopyWith(_$ActionAlertModelImpl value,
          $Res Function(_$ActionAlertModelImpl) then) =
      __$$ActionAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String actionId,
      String userId,
      AlertType type,
      bool read,
      Map<String, dynamic>? additionalData,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ActionAlertModelImplCopyWithImpl<$Res>
    extends _$ActionAlertModelCopyWithImpl<$Res, _$ActionAlertModelImpl>
    implements _$$ActionAlertModelImplCopyWith<$Res> {
  __$$ActionAlertModelImplCopyWithImpl(_$ActionAlertModelImpl _value,
      $Res Function(_$ActionAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActionAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actionId = null,
    Object? userId = null,
    Object? type = null,
    Object? read = null,
    Object? additionalData = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ActionAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actionId: null == actionId
          ? _value.actionId
          : actionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertType,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$ActionAlertModelImpl implements _ActionAlertModel {
  const _$ActionAlertModelImpl(
      {required this.id,
      required this.actionId,
      required this.userId,
      required this.type,
      this.read = false,
      final Map<String, dynamic>? additionalData,
      required this.createdAt,
      required this.updatedAt})
      : _additionalData = additionalData;

  factory _$ActionAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionAlertModelImplFromJson(json);

  /// Unique identifier for the action alert
  @override
  final String id;

  /// ID of the task action this alert is for
  @override
  final String actionId;

  /// ID of the user this alert belongs to
  @override
  final String userId;

  /// Type of alert
  @override
  final AlertType type;

  /// Whether the alert has been read
  @override
  @JsonKey()
  final bool read;

  /// Optional additional data for the alert
  final Map<String, dynamic>? _additionalData;

  /// Optional additional data for the alert
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Creation timestamp
  @override
  final DateTime createdAt;

  /// Last update timestamp
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ActionAlertModel(id: $id, actionId: $actionId, userId: $userId, type: $type, read: $read, additionalData: $additionalData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.read, read) || other.read == read) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData) &&
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
      actionId,
      userId,
      type,
      read,
      const DeepCollectionEquality().hash(_additionalData),
      createdAt,
      updatedAt);

  /// Create a copy of ActionAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionAlertModelImplCopyWith<_$ActionAlertModelImpl> get copyWith =>
      __$$ActionAlertModelImplCopyWithImpl<_$ActionAlertModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionAlertModelImplToJson(
      this,
    );
  }
}

abstract class _ActionAlertModel implements ActionAlertModel {
  const factory _ActionAlertModel(
      {required final String id,
      required final String actionId,
      required final String userId,
      required final AlertType type,
      final bool read,
      final Map<String, dynamic>? additionalData,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ActionAlertModelImpl;

  factory _ActionAlertModel.fromJson(Map<String, dynamic> json) =
      _$ActionAlertModelImpl.fromJson;

  /// Unique identifier for the action alert
  @override
  String get id;

  /// ID of the task action this alert is for
  @override
  String get actionId;

  /// ID of the user this alert belongs to
  @override
  String get userId;

  /// Type of alert
  @override
  AlertType get type;

  /// Whether the alert has been read
  @override
  bool get read;

  /// Optional additional data for the alert
  @override
  Map<String, dynamic>? get additionalData;

  /// Creation timestamp
  @override
  DateTime get createdAt;

  /// Last update timestamp
  @override
  DateTime get updatedAt;

  /// Create a copy of ActionAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionAlertModelImplCopyWith<_$ActionAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertsData _$AlertsDataFromJson(Map<String, dynamic> json) {
  return _AlertsData.fromJson(json);
}

/// @nodoc
mixin _$AlertsData {
  /// Map of alert ID to alert
  Map<String, AlertModel> get alertsById => throw _privateConstructorUsedError;

  /// Map of task ID to list of alert IDs
  Map<String, List<String>> get alertsByTaskId =>
      throw _privateConstructorUsedError;

  /// Map of action alert ID to action alert
  Map<String, ActionAlertModel> get actionAlertsById =>
      throw _privateConstructorUsedError;

  /// Map of action ID to list of action alert IDs
  Map<String, List<String>> get actionAlertsByActionId =>
      throw _privateConstructorUsedError;

  /// Whether there are any unread alerts
  bool get hasUnreadAlerts => throw _privateConstructorUsedError;

  /// Serializes this AlertsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertsDataCopyWith<AlertsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertsDataCopyWith<$Res> {
  factory $AlertsDataCopyWith(
          AlertsData value, $Res Function(AlertsData) then) =
      _$AlertsDataCopyWithImpl<$Res, AlertsData>;
  @useResult
  $Res call(
      {Map<String, AlertModel> alertsById,
      Map<String, List<String>> alertsByTaskId,
      Map<String, ActionAlertModel> actionAlertsById,
      Map<String, List<String>> actionAlertsByActionId,
      bool hasUnreadAlerts});
}

/// @nodoc
class _$AlertsDataCopyWithImpl<$Res, $Val extends AlertsData>
    implements $AlertsDataCopyWith<$Res> {
  _$AlertsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertsById = null,
    Object? alertsByTaskId = null,
    Object? actionAlertsById = null,
    Object? actionAlertsByActionId = null,
    Object? hasUnreadAlerts = null,
  }) {
    return _then(_value.copyWith(
      alertsById: null == alertsById
          ? _value.alertsById
          : alertsById // ignore: cast_nullable_to_non_nullable
              as Map<String, AlertModel>,
      alertsByTaskId: null == alertsByTaskId
          ? _value.alertsByTaskId
          : alertsByTaskId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      actionAlertsById: null == actionAlertsById
          ? _value.actionAlertsById
          : actionAlertsById // ignore: cast_nullable_to_non_nullable
              as Map<String, ActionAlertModel>,
      actionAlertsByActionId: null == actionAlertsByActionId
          ? _value.actionAlertsByActionId
          : actionAlertsByActionId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      hasUnreadAlerts: null == hasUnreadAlerts
          ? _value.hasUnreadAlerts
          : hasUnreadAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertsDataImplCopyWith<$Res>
    implements $AlertsDataCopyWith<$Res> {
  factory _$$AlertsDataImplCopyWith(
          _$AlertsDataImpl value, $Res Function(_$AlertsDataImpl) then) =
      __$$AlertsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, AlertModel> alertsById,
      Map<String, List<String>> alertsByTaskId,
      Map<String, ActionAlertModel> actionAlertsById,
      Map<String, List<String>> actionAlertsByActionId,
      bool hasUnreadAlerts});
}

/// @nodoc
class __$$AlertsDataImplCopyWithImpl<$Res>
    extends _$AlertsDataCopyWithImpl<$Res, _$AlertsDataImpl>
    implements _$$AlertsDataImplCopyWith<$Res> {
  __$$AlertsDataImplCopyWithImpl(
      _$AlertsDataImpl _value, $Res Function(_$AlertsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertsById = null,
    Object? alertsByTaskId = null,
    Object? actionAlertsById = null,
    Object? actionAlertsByActionId = null,
    Object? hasUnreadAlerts = null,
  }) {
    return _then(_$AlertsDataImpl(
      alertsById: null == alertsById
          ? _value._alertsById
          : alertsById // ignore: cast_nullable_to_non_nullable
              as Map<String, AlertModel>,
      alertsByTaskId: null == alertsByTaskId
          ? _value._alertsByTaskId
          : alertsByTaskId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      actionAlertsById: null == actionAlertsById
          ? _value._actionAlertsById
          : actionAlertsById // ignore: cast_nullable_to_non_nullable
              as Map<String, ActionAlertModel>,
      actionAlertsByActionId: null == actionAlertsByActionId
          ? _value._actionAlertsByActionId
          : actionAlertsByActionId // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      hasUnreadAlerts: null == hasUnreadAlerts
          ? _value.hasUnreadAlerts
          : hasUnreadAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertsDataImpl implements _AlertsData {
  const _$AlertsDataImpl(
      {final Map<String, AlertModel> alertsById = const {},
      final Map<String, List<String>> alertsByTaskId = const {},
      final Map<String, ActionAlertModel> actionAlertsById = const {},
      final Map<String, List<String>> actionAlertsByActionId = const {},
      this.hasUnreadAlerts = false})
      : _alertsById = alertsById,
        _alertsByTaskId = alertsByTaskId,
        _actionAlertsById = actionAlertsById,
        _actionAlertsByActionId = actionAlertsByActionId;

  factory _$AlertsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertsDataImplFromJson(json);

  /// Map of alert ID to alert
  final Map<String, AlertModel> _alertsById;

  /// Map of alert ID to alert
  @override
  @JsonKey()
  Map<String, AlertModel> get alertsById {
    if (_alertsById is EqualUnmodifiableMapView) return _alertsById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_alertsById);
  }

  /// Map of task ID to list of alert IDs
  final Map<String, List<String>> _alertsByTaskId;

  /// Map of task ID to list of alert IDs
  @override
  @JsonKey()
  Map<String, List<String>> get alertsByTaskId {
    if (_alertsByTaskId is EqualUnmodifiableMapView) return _alertsByTaskId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_alertsByTaskId);
  }

  /// Map of action alert ID to action alert
  final Map<String, ActionAlertModel> _actionAlertsById;

  /// Map of action alert ID to action alert
  @override
  @JsonKey()
  Map<String, ActionAlertModel> get actionAlertsById {
    if (_actionAlertsById is EqualUnmodifiableMapView) return _actionAlertsById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionAlertsById);
  }

  /// Map of action ID to list of action alert IDs
  final Map<String, List<String>> _actionAlertsByActionId;

  /// Map of action ID to list of action alert IDs
  @override
  @JsonKey()
  Map<String, List<String>> get actionAlertsByActionId {
    if (_actionAlertsByActionId is EqualUnmodifiableMapView)
      return _actionAlertsByActionId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionAlertsByActionId);
  }

  /// Whether there are any unread alerts
  @override
  @JsonKey()
  final bool hasUnreadAlerts;

  @override
  String toString() {
    return 'AlertsData(alertsById: $alertsById, alertsByTaskId: $alertsByTaskId, actionAlertsById: $actionAlertsById, actionAlertsByActionId: $actionAlertsByActionId, hasUnreadAlerts: $hasUnreadAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertsDataImpl &&
            const DeepCollectionEquality()
                .equals(other._alertsById, _alertsById) &&
            const DeepCollectionEquality()
                .equals(other._alertsByTaskId, _alertsByTaskId) &&
            const DeepCollectionEquality()
                .equals(other._actionAlertsById, _actionAlertsById) &&
            const DeepCollectionEquality().equals(
                other._actionAlertsByActionId, _actionAlertsByActionId) &&
            (identical(other.hasUnreadAlerts, hasUnreadAlerts) ||
                other.hasUnreadAlerts == hasUnreadAlerts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_alertsById),
      const DeepCollectionEquality().hash(_alertsByTaskId),
      const DeepCollectionEquality().hash(_actionAlertsById),
      const DeepCollectionEquality().hash(_actionAlertsByActionId),
      hasUnreadAlerts);

  /// Create a copy of AlertsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertsDataImplCopyWith<_$AlertsDataImpl> get copyWith =>
      __$$AlertsDataImplCopyWithImpl<_$AlertsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertsDataImplToJson(
      this,
    );
  }
}

abstract class _AlertsData implements AlertsData {
  const factory _AlertsData(
      {final Map<String, AlertModel> alertsById,
      final Map<String, List<String>> alertsByTaskId,
      final Map<String, ActionAlertModel> actionAlertsById,
      final Map<String, List<String>> actionAlertsByActionId,
      final bool hasUnreadAlerts}) = _$AlertsDataImpl;

  factory _AlertsData.fromJson(Map<String, dynamic> json) =
      _$AlertsDataImpl.fromJson;

  /// Map of alert ID to alert
  @override
  Map<String, AlertModel> get alertsById;

  /// Map of task ID to list of alert IDs
  @override
  Map<String, List<String>> get alertsByTaskId;

  /// Map of action alert ID to action alert
  @override
  Map<String, ActionAlertModel> get actionAlertsById;

  /// Map of action ID to list of action alert IDs
  @override
  Map<String, List<String>> get actionAlertsByActionId;

  /// Whether there are any unread alerts
  @override
  bool get hasUnreadAlerts;

  /// Create a copy of AlertsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertsDataImplCopyWith<_$AlertsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
