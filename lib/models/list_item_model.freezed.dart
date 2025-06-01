// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListItemModel _$ListItemModelFromJson(Map<String, dynamic> json) {
  return _ListItemModel.fromJson(json);
}

/// @nodoc
mixin _$ListItemModel {
  String get id => throw _privateConstructorUsedError;
  String get listId => throw _privateConstructorUsedError;
  String? get sublistId =>
      throw _privateConstructorUsedError; // For hierarchy support
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// ID of the task this list item is linked to (for bidirectional sync)
  String? get linkedTaskId => throw _privateConstructorUsedError;

  /// Whether this list item was converted from a task
  bool get isConvertedFromTask => throw _privateConstructorUsedError;

  /// Shopping-specific fields
  double? get price => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ListItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListItemModelCopyWith<ListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListItemModelCopyWith<$Res> {
  factory $ListItemModelCopyWith(
          ListItemModel value, $Res Function(ListItemModel) then) =
      _$ListItemModelCopyWithImpl<$Res, ListItemModel>;
  @useResult
  $Res call(
      {String id,
      String listId,
      String? sublistId,
      String name,
      String? description,
      bool isCompleted,
      int? quantity,
      int sortOrder,
      String? linkedTaskId,
      bool isConvertedFromTask,
      double? price,
      String? storeId,
      String? brand,
      String? notes,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ListItemModelCopyWithImpl<$Res, $Val extends ListItemModel>
    implements $ListItemModelCopyWith<$Res> {
  _$ListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? sublistId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? quantity = freezed,
    Object? sortOrder = null,
    Object? linkedTaskId = freezed,
    Object? isConvertedFromTask = null,
    Object? price = freezed,
    Object? storeId = freezed,
    Object? brand = freezed,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      sublistId: freezed == sublistId
          ? _value.sublistId
          : sublistId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      linkedTaskId: freezed == linkedTaskId
          ? _value.linkedTaskId
          : linkedTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      isConvertedFromTask: null == isConvertedFromTask
          ? _value.isConvertedFromTask
          : isConvertedFromTask // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
abstract class _$$ListItemModelImplCopyWith<$Res>
    implements $ListItemModelCopyWith<$Res> {
  factory _$$ListItemModelImplCopyWith(
          _$ListItemModelImpl value, $Res Function(_$ListItemModelImpl) then) =
      __$$ListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String listId,
      String? sublistId,
      String name,
      String? description,
      bool isCompleted,
      int? quantity,
      int sortOrder,
      String? linkedTaskId,
      bool isConvertedFromTask,
      double? price,
      String? storeId,
      String? brand,
      String? notes,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ListItemModelImplCopyWithImpl<$Res>
    extends _$ListItemModelCopyWithImpl<$Res, _$ListItemModelImpl>
    implements _$$ListItemModelImplCopyWith<$Res> {
  __$$ListItemModelImplCopyWithImpl(
      _$ListItemModelImpl _value, $Res Function(_$ListItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? sublistId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? isCompleted = null,
    Object? quantity = freezed,
    Object? sortOrder = null,
    Object? linkedTaskId = freezed,
    Object? isConvertedFromTask = null,
    Object? price = freezed,
    Object? storeId = freezed,
    Object? brand = freezed,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ListItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      sublistId: freezed == sublistId
          ? _value.sublistId
          : sublistId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      linkedTaskId: freezed == linkedTaskId
          ? _value.linkedTaskId
          : linkedTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      isConvertedFromTask: null == isConvertedFromTask
          ? _value.isConvertedFromTask
          : isConvertedFromTask // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
class _$ListItemModelImpl implements _ListItemModel {
  const _$ListItemModelImpl(
      {required this.id,
      required this.listId,
      this.sublistId,
      required this.name,
      this.description,
      this.isCompleted = false,
      this.quantity,
      this.sortOrder = 0,
      this.linkedTaskId,
      this.isConvertedFromTask = false,
      this.price,
      this.storeId,
      this.brand,
      this.notes,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      required this.updatedAt})
      : _metadata = metadata;

  factory _$ListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String listId;
  @override
  final String? sublistId;
// For hierarchy support
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final int? quantity;
  @override
  @JsonKey()
  final int sortOrder;

  /// ID of the task this list item is linked to (for bidirectional sync)
  @override
  final String? linkedTaskId;

  /// Whether this list item was converted from a task
  @override
  @JsonKey()
  final bool isConvertedFromTask;

  /// Shopping-specific fields
  @override
  final double? price;
  @override
  final String? storeId;
  @override
  final String? brand;
  @override
  final String? notes;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ListItemModel(id: $id, listId: $listId, sublistId: $sublistId, name: $name, description: $description, isCompleted: $isCompleted, quantity: $quantity, sortOrder: $sortOrder, linkedTaskId: $linkedTaskId, isConvertedFromTask: $isConvertedFromTask, price: $price, storeId: $storeId, brand: $brand, notes: $notes, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.sublistId, sublistId) ||
                other.sublistId == sublistId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.linkedTaskId, linkedTaskId) ||
                other.linkedTaskId == linkedTaskId) &&
            (identical(other.isConvertedFromTask, isConvertedFromTask) ||
                other.isConvertedFromTask == isConvertedFromTask) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
      listId,
      sublistId,
      name,
      description,
      isCompleted,
      quantity,
      sortOrder,
      linkedTaskId,
      isConvertedFromTask,
      price,
      storeId,
      brand,
      notes,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of ListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListItemModelImplCopyWith<_$ListItemModelImpl> get copyWith =>
      __$$ListItemModelImplCopyWithImpl<_$ListItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListItemModelImplToJson(
      this,
    );
  }
}

abstract class _ListItemModel implements ListItemModel {
  const factory _ListItemModel(
      {required final String id,
      required final String listId,
      final String? sublistId,
      required final String name,
      final String? description,
      final bool isCompleted,
      final int? quantity,
      final int sortOrder,
      final String? linkedTaskId,
      final bool isConvertedFromTask,
      final double? price,
      final String? storeId,
      final String? brand,
      final String? notes,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ListItemModelImpl;

  factory _ListItemModel.fromJson(Map<String, dynamic> json) =
      _$ListItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get listId;
  @override
  String? get sublistId; // For hierarchy support
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isCompleted;
  @override
  int? get quantity;
  @override
  int get sortOrder;

  /// ID of the task this list item is linked to (for bidirectional sync)
  @override
  String? get linkedTaskId;

  /// Whether this list item was converted from a task
  @override
  bool get isConvertedFromTask;

  /// Shopping-specific fields
  @override
  double? get price;
  @override
  String? get storeId;
  @override
  String? get brand;
  @override
  String? get notes;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ListItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListItemModelImplCopyWith<_$ListItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
