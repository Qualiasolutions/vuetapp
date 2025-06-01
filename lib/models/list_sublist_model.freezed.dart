// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_sublist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListSublist _$ListSublistFromJson(Map<String, dynamic> json) {
  return _ListSublist.fromJson(json);
}

/// @nodoc
mixin _$ListSublist {
  String get id => throw _privateConstructorUsedError;
  String get listId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  double get completionPercentage =>
      throw _privateConstructorUsedError; // Auto-calculated in DB
  int get totalItems => throw _privateConstructorUsedError;
  int get completedItems => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Note: items are not stored in the sublists table in DB, they reference sublist_id
// This field is for convenience when working with the model in the app
  List<ListItemModel> get items =>
      throw _privateConstructorUsedError; // Legacy fields for backward compatibility
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this ListSublist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListSublist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListSublistCopyWith<ListSublist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListSublistCopyWith<$Res> {
  factory $ListSublistCopyWith(
          ListSublist value, $Res Function(ListSublist) then) =
      _$ListSublistCopyWithImpl<$Res, ListSublist>;
  @useResult
  $Res call(
      {String id,
      String listId,
      String title,
      String? description,
      int sortOrder,
      bool isCompleted,
      double completionPercentage,
      int totalItems,
      int completedItems,
      String? color,
      String? icon,
      DateTime createdAt,
      DateTime updatedAt,
      List<ListItemModel> items,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ListSublistCopyWithImpl<$Res, $Val extends ListSublist>
    implements $ListSublistCopyWith<$Res> {
  _$ListSublistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListSublist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isCompleted = null,
    Object? completionPercentage = null,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
    Object? metadata = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ListItemModel>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListSublistImplCopyWith<$Res>
    implements $ListSublistCopyWith<$Res> {
  factory _$$ListSublistImplCopyWith(
          _$ListSublistImpl value, $Res Function(_$ListSublistImpl) then) =
      __$$ListSublistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String listId,
      String title,
      String? description,
      int sortOrder,
      bool isCompleted,
      double completionPercentage,
      int totalItems,
      int completedItems,
      String? color,
      String? icon,
      DateTime createdAt,
      DateTime updatedAt,
      List<ListItemModel> items,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ListSublistImplCopyWithImpl<$Res>
    extends _$ListSublistCopyWithImpl<$Res, _$ListSublistImpl>
    implements _$$ListSublistImplCopyWith<$Res> {
  __$$ListSublistImplCopyWithImpl(
      _$ListSublistImpl _value, $Res Function(_$ListSublistImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListSublist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isCompleted = null,
    Object? completionPercentage = null,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? color = freezed,
    Object? icon = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
    Object? metadata = null,
  }) {
    return _then(_$ListSublistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ListItemModel>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListSublistImpl implements _ListSublist {
  const _$ListSublistImpl(
      {required this.id,
      required this.listId,
      required this.title,
      this.description,
      this.sortOrder = 0,
      this.isCompleted = false,
      this.completionPercentage = 0.0,
      this.totalItems = 0,
      this.completedItems = 0,
      this.color,
      this.icon,
      required this.createdAt,
      required this.updatedAt,
      final List<ListItemModel> items = const [],
      final Map<String, dynamic> metadata = const {}})
      : _items = items,
        _metadata = metadata;

  factory _$ListSublistImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListSublistImplFromJson(json);

  @override
  final String id;
  @override
  final String listId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final double completionPercentage;
// Auto-calculated in DB
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final int completedItems;
  @override
  final String? color;
  @override
  final String? icon;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Note: items are not stored in the sublists table in DB, they reference sublist_id
// This field is for convenience when working with the model in the app
  final List<ListItemModel> _items;
// Note: items are not stored in the sublists table in DB, they reference sublist_id
// This field is for convenience when working with the model in the app
  @override
  @JsonKey()
  List<ListItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

// Legacy fields for backward compatibility
  final Map<String, dynamic> _metadata;
// Legacy fields for backward compatibility
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ListSublist(id: $id, listId: $listId, title: $title, description: $description, sortOrder: $sortOrder, isCompleted: $isCompleted, completionPercentage: $completionPercentage, totalItems: $totalItems, completedItems: $completedItems, color: $color, icon: $icon, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListSublistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.completedItems, completedItems) ||
                other.completedItems == completedItems) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      listId,
      title,
      description,
      sortOrder,
      isCompleted,
      completionPercentage,
      totalItems,
      completedItems,
      color,
      icon,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ListSublist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListSublistImplCopyWith<_$ListSublistImpl> get copyWith =>
      __$$ListSublistImplCopyWithImpl<_$ListSublistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListSublistImplToJson(
      this,
    );
  }
}

abstract class _ListSublist implements ListSublist {
  const factory _ListSublist(
      {required final String id,
      required final String listId,
      required final String title,
      final String? description,
      final int sortOrder,
      final bool isCompleted,
      final double completionPercentage,
      final int totalItems,
      final int completedItems,
      final String? color,
      final String? icon,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<ListItemModel> items,
      final Map<String, dynamic> metadata}) = _$ListSublistImpl;

  factory _ListSublist.fromJson(Map<String, dynamic> json) =
      _$ListSublistImpl.fromJson;

  @override
  String get id;
  @override
  String get listId;
  @override
  String get title;
  @override
  String? get description;
  @override
  int get sortOrder;
  @override
  bool get isCompleted;
  @override
  double get completionPercentage; // Auto-calculated in DB
  @override
  int get totalItems;
  @override
  int get completedItems;
  @override
  String? get color;
  @override
  String? get icon;
  @override
  DateTime get createdAt;
  @override
  DateTime
      get updatedAt; // Note: items are not stored in the sublists table in DB, they reference sublist_id
// This field is for convenience when working with the model in the app
  @override
  List<ListItemModel> get items; // Legacy fields for backward compatibility
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of ListSublist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListSublistImplCopyWith<_$ListSublistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
