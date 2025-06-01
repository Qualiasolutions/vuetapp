// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListModel _$ListModelFromJson(Map<String, dynamic> json) {
  return _ListModel.fromJson(json);
}

/// @nodoc
mixin _$ListModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // Maps to user_id in database
  String? get familyId => throw _privateConstructorUsedError;
  List<String> get sharedWith => throw _privateConstructorUsedError;
  List<ListSublist> get sublists => throw _privateConstructorUsedError;
  bool get isTemplate => throw _privateConstructorUsedError;
  String? get templateCategory => throw _privateConstructorUsedError;
  bool get isShoppingList => throw _privateConstructorUsedError;
  String? get shoppingStoreId => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get completedItems => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  bool get isDelegated => throw _privateConstructorUsedError;
  String? get delegatedTo => throw _privateConstructorUsedError;
  DateTime? get delegatedAt => throw _privateConstructorUsedError;
  String? get delegationNote => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastAccessedAt =>
      throw _privateConstructorUsedError; // NEW MODERNIZED FIELDS from database schema
  String? get listCategoryId =>
      throw _privateConstructorUsedError; // References list_categories table
  String? get templateId =>
      throw _privateConstructorUsedError; // References list_templates table
  bool get createdFromTemplate => throw _privateConstructorUsedError;
  double get completionPercentage =>
      throw _privateConstructorUsedError; // Auto-calculated in DB
  String? get listType =>
      throw _privateConstructorUsedError; // 'planning' | 'shopping' | 'delegated'
  String get visibility =>
      throw _privateConstructorUsedError; // 'private' | 'family' | 'public'
  bool get isFavorite => throw _privateConstructorUsedError;
  Map<String, dynamic> get reminderSettings =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get settings =>
      throw _privateConstructorUsedError; // Keep legacy fields for backward compatibility during migration
  String? get categoryId =>
      throw _privateConstructorUsedError; // Legacy field - maps to category_id in DB
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this ListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListModelCopyWith<ListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListModelCopyWith<$Res> {
  factory $ListModelCopyWith(ListModel value, $Res Function(ListModel) then) =
      _$ListModelCopyWithImpl<$Res, ListModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String ownerId,
      String userId,
      String? familyId,
      List<String> sharedWith,
      List<ListSublist> sublists,
      bool isTemplate,
      String? templateCategory,
      bool isShoppingList,
      String? shoppingStoreId,
      int totalItems,
      int completedItems,
      bool isArchived,
      bool isDelegated,
      String? delegatedTo,
      DateTime? delegatedAt,
      String? delegationNote,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastAccessedAt,
      String? listCategoryId,
      String? templateId,
      bool createdFromTemplate,
      double completionPercentage,
      String? listType,
      String visibility,
      bool isFavorite,
      Map<String, dynamic> reminderSettings,
      Map<String, dynamic> settings,
      String? categoryId,
      String? type});
}

/// @nodoc
class _$ListModelCopyWithImpl<$Res, $Val extends ListModel>
    implements $ListModelCopyWith<$Res> {
  _$ListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? userId = null,
    Object? familyId = freezed,
    Object? sharedWith = null,
    Object? sublists = null,
    Object? isTemplate = null,
    Object? templateCategory = freezed,
    Object? isShoppingList = null,
    Object? shoppingStoreId = freezed,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? isArchived = null,
    Object? isDelegated = null,
    Object? delegatedTo = freezed,
    Object? delegatedAt = freezed,
    Object? delegationNote = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastAccessedAt = freezed,
    Object? listCategoryId = freezed,
    Object? templateId = freezed,
    Object? createdFromTemplate = null,
    Object? completionPercentage = null,
    Object? listType = freezed,
    Object? visibility = null,
    Object? isFavorite = null,
    Object? reminderSettings = null,
    Object? settings = null,
    Object? categoryId = freezed,
    Object? type = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sublists: null == sublists
          ? _value.sublists
          : sublists // ignore: cast_nullable_to_non_nullable
              as List<ListSublist>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      templateCategory: freezed == templateCategory
          ? _value.templateCategory
          : templateCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isShoppingList: null == isShoppingList
          ? _value.isShoppingList
          : isShoppingList // ignore: cast_nullable_to_non_nullable
              as bool,
      shoppingStoreId: freezed == shoppingStoreId
          ? _value.shoppingStoreId
          : shoppingStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelegated: null == isDelegated
          ? _value.isDelegated
          : isDelegated // ignore: cast_nullable_to_non_nullable
              as bool,
      delegatedTo: freezed == delegatedTo
          ? _value.delegatedTo
          : delegatedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedAt: freezed == delegatedAt
          ? _value.delegatedAt
          : delegatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      delegationNote: freezed == delegationNote
          ? _value.delegationNote
          : delegationNote // ignore: cast_nullable_to_non_nullable
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
      lastAccessedAt: freezed == lastAccessedAt
          ? _value.lastAccessedAt
          : lastAccessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      listCategoryId: freezed == listCategoryId
          ? _value.listCategoryId
          : listCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdFromTemplate: null == createdFromTemplate
          ? _value.createdFromTemplate
          : createdFromTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      listType: freezed == listType
          ? _value.listType
          : listType // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSettings: null == reminderSettings
          ? _value.reminderSettings
          : reminderSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListModelImplCopyWith<$Res>
    implements $ListModelCopyWith<$Res> {
  factory _$$ListModelImplCopyWith(
          _$ListModelImpl value, $Res Function(_$ListModelImpl) then) =
      __$$ListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String ownerId,
      String userId,
      String? familyId,
      List<String> sharedWith,
      List<ListSublist> sublists,
      bool isTemplate,
      String? templateCategory,
      bool isShoppingList,
      String? shoppingStoreId,
      int totalItems,
      int completedItems,
      bool isArchived,
      bool isDelegated,
      String? delegatedTo,
      DateTime? delegatedAt,
      String? delegationNote,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastAccessedAt,
      String? listCategoryId,
      String? templateId,
      bool createdFromTemplate,
      double completionPercentage,
      String? listType,
      String visibility,
      bool isFavorite,
      Map<String, dynamic> reminderSettings,
      Map<String, dynamic> settings,
      String? categoryId,
      String? type});
}

/// @nodoc
class __$$ListModelImplCopyWithImpl<$Res>
    extends _$ListModelCopyWithImpl<$Res, _$ListModelImpl>
    implements _$$ListModelImplCopyWith<$Res> {
  __$$ListModelImplCopyWithImpl(
      _$ListModelImpl _value, $Res Function(_$ListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? userId = null,
    Object? familyId = freezed,
    Object? sharedWith = null,
    Object? sublists = null,
    Object? isTemplate = null,
    Object? templateCategory = freezed,
    Object? isShoppingList = null,
    Object? shoppingStoreId = freezed,
    Object? totalItems = null,
    Object? completedItems = null,
    Object? isArchived = null,
    Object? isDelegated = null,
    Object? delegatedTo = freezed,
    Object? delegatedAt = freezed,
    Object? delegationNote = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastAccessedAt = freezed,
    Object? listCategoryId = freezed,
    Object? templateId = freezed,
    Object? createdFromTemplate = null,
    Object? completionPercentage = null,
    Object? listType = freezed,
    Object? visibility = null,
    Object? isFavorite = null,
    Object? reminderSettings = null,
    Object? settings = null,
    Object? categoryId = freezed,
    Object? type = freezed,
  }) {
    return _then(_$ListModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value._sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sublists: null == sublists
          ? _value._sublists
          : sublists // ignore: cast_nullable_to_non_nullable
              as List<ListSublist>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      templateCategory: freezed == templateCategory
          ? _value.templateCategory
          : templateCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isShoppingList: null == isShoppingList
          ? _value.isShoppingList
          : isShoppingList // ignore: cast_nullable_to_non_nullable
              as bool,
      shoppingStoreId: freezed == shoppingStoreId
          ? _value.shoppingStoreId
          : shoppingStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      completedItems: null == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelegated: null == isDelegated
          ? _value.isDelegated
          : isDelegated // ignore: cast_nullable_to_non_nullable
              as bool,
      delegatedTo: freezed == delegatedTo
          ? _value.delegatedTo
          : delegatedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      delegatedAt: freezed == delegatedAt
          ? _value.delegatedAt
          : delegatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      delegationNote: freezed == delegationNote
          ? _value.delegationNote
          : delegationNote // ignore: cast_nullable_to_non_nullable
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
      lastAccessedAt: freezed == lastAccessedAt
          ? _value.lastAccessedAt
          : lastAccessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      listCategoryId: freezed == listCategoryId
          ? _value.listCategoryId
          : listCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdFromTemplate: null == createdFromTemplate
          ? _value.createdFromTemplate
          : createdFromTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      listType: freezed == listType
          ? _value.listType
          : listType // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSettings: null == reminderSettings
          ? _value._reminderSettings
          : reminderSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListModelImpl implements _ListModel {
  const _$ListModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.ownerId,
      required this.userId,
      this.familyId,
      final List<String> sharedWith = const [],
      final List<ListSublist> sublists = const [],
      this.isTemplate = false,
      this.templateCategory,
      this.isShoppingList = false,
      this.shoppingStoreId,
      this.totalItems = 0,
      this.completedItems = 0,
      this.isArchived = false,
      this.isDelegated = false,
      this.delegatedTo,
      this.delegatedAt,
      this.delegationNote,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      required this.updatedAt,
      this.lastAccessedAt,
      this.listCategoryId,
      this.templateId,
      this.createdFromTemplate = false,
      this.completionPercentage = 0.0,
      this.listType,
      this.visibility = 'private',
      this.isFavorite = false,
      final Map<String, dynamic> reminderSettings = const {},
      final Map<String, dynamic> settings = const {},
      this.categoryId,
      this.type})
      : _sharedWith = sharedWith,
        _sublists = sublists,
        _metadata = metadata,
        _reminderSettings = reminderSettings,
        _settings = settings;

  factory _$ListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String ownerId;
  @override
  final String userId;
// Maps to user_id in database
  @override
  final String? familyId;
  final List<String> _sharedWith;
  @override
  @JsonKey()
  List<String> get sharedWith {
    if (_sharedWith is EqualUnmodifiableListView) return _sharedWith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWith);
  }

  final List<ListSublist> _sublists;
  @override
  @JsonKey()
  List<ListSublist> get sublists {
    if (_sublists is EqualUnmodifiableListView) return _sublists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sublists);
  }

  @override
  @JsonKey()
  final bool isTemplate;
  @override
  final String? templateCategory;
  @override
  @JsonKey()
  final bool isShoppingList;
  @override
  final String? shoppingStoreId;
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final int completedItems;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isDelegated;
  @override
  final String? delegatedTo;
  @override
  final DateTime? delegatedAt;
  @override
  final String? delegationNote;
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
  final DateTime? lastAccessedAt;
// NEW MODERNIZED FIELDS from database schema
  @override
  final String? listCategoryId;
// References list_categories table
  @override
  final String? templateId;
// References list_templates table
  @override
  @JsonKey()
  final bool createdFromTemplate;
  @override
  @JsonKey()
  final double completionPercentage;
// Auto-calculated in DB
  @override
  final String? listType;
// 'planning' | 'shopping' | 'delegated'
  @override
  @JsonKey()
  final String visibility;
// 'private' | 'family' | 'public'
  @override
  @JsonKey()
  final bool isFavorite;
  final Map<String, dynamic> _reminderSettings;
  @override
  @JsonKey()
  Map<String, dynamic> get reminderSettings {
    if (_reminderSettings is EqualUnmodifiableMapView) return _reminderSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reminderSettings);
  }

  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

// Keep legacy fields for backward compatibility during migration
  @override
  final String? categoryId;
// Legacy field - maps to category_id in DB
  @override
  final String? type;

  @override
  String toString() {
    return 'ListModel(id: $id, name: $name, description: $description, ownerId: $ownerId, userId: $userId, familyId: $familyId, sharedWith: $sharedWith, sublists: $sublists, isTemplate: $isTemplate, templateCategory: $templateCategory, isShoppingList: $isShoppingList, shoppingStoreId: $shoppingStoreId, totalItems: $totalItems, completedItems: $completedItems, isArchived: $isArchived, isDelegated: $isDelegated, delegatedTo: $delegatedTo, delegatedAt: $delegatedAt, delegationNote: $delegationNote, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, lastAccessedAt: $lastAccessedAt, listCategoryId: $listCategoryId, templateId: $templateId, createdFromTemplate: $createdFromTemplate, completionPercentage: $completionPercentage, listType: $listType, visibility: $visibility, isFavorite: $isFavorite, reminderSettings: $reminderSettings, settings: $settings, categoryId: $categoryId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            const DeepCollectionEquality()
                .equals(other._sharedWith, _sharedWith) &&
            const DeepCollectionEquality().equals(other._sublists, _sublists) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.templateCategory, templateCategory) ||
                other.templateCategory == templateCategory) &&
            (identical(other.isShoppingList, isShoppingList) ||
                other.isShoppingList == isShoppingList) &&
            (identical(other.shoppingStoreId, shoppingStoreId) ||
                other.shoppingStoreId == shoppingStoreId) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.completedItems, completedItems) ||
                other.completedItems == completedItems) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isDelegated, isDelegated) ||
                other.isDelegated == isDelegated) &&
            (identical(other.delegatedTo, delegatedTo) ||
                other.delegatedTo == delegatedTo) &&
            (identical(other.delegatedAt, delegatedAt) ||
                other.delegatedAt == delegatedAt) &&
            (identical(other.delegationNote, delegationNote) ||
                other.delegationNote == delegationNote) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastAccessedAt, lastAccessedAt) ||
                other.lastAccessedAt == lastAccessedAt) &&
            (identical(other.listCategoryId, listCategoryId) ||
                other.listCategoryId == listCategoryId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.createdFromTemplate, createdFromTemplate) ||
                other.createdFromTemplate == createdFromTemplate) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.listType, listType) ||
                other.listType == listType) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            const DeepCollectionEquality()
                .equals(other._reminderSettings, _reminderSettings) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        ownerId,
        userId,
        familyId,
        const DeepCollectionEquality().hash(_sharedWith),
        const DeepCollectionEquality().hash(_sublists),
        isTemplate,
        templateCategory,
        isShoppingList,
        shoppingStoreId,
        totalItems,
        completedItems,
        isArchived,
        isDelegated,
        delegatedTo,
        delegatedAt,
        delegationNote,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt,
        lastAccessedAt,
        listCategoryId,
        templateId,
        createdFromTemplate,
        completionPercentage,
        listType,
        visibility,
        isFavorite,
        const DeepCollectionEquality().hash(_reminderSettings),
        const DeepCollectionEquality().hash(_settings),
        categoryId,
        type
      ]);

  /// Create a copy of ListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListModelImplCopyWith<_$ListModelImpl> get copyWith =>
      __$$ListModelImplCopyWithImpl<_$ListModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListModelImplToJson(
      this,
    );
  }
}

abstract class _ListModel implements ListModel {
  const factory _ListModel(
      {required final String id,
      required final String name,
      final String? description,
      required final String ownerId,
      required final String userId,
      final String? familyId,
      final List<String> sharedWith,
      final List<ListSublist> sublists,
      final bool isTemplate,
      final String? templateCategory,
      final bool isShoppingList,
      final String? shoppingStoreId,
      final int totalItems,
      final int completedItems,
      final bool isArchived,
      final bool isDelegated,
      final String? delegatedTo,
      final DateTime? delegatedAt,
      final String? delegationNote,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? lastAccessedAt,
      final String? listCategoryId,
      final String? templateId,
      final bool createdFromTemplate,
      final double completionPercentage,
      final String? listType,
      final String visibility,
      final bool isFavorite,
      final Map<String, dynamic> reminderSettings,
      final Map<String, dynamic> settings,
      final String? categoryId,
      final String? type}) = _$ListModelImpl;

  factory _ListModel.fromJson(Map<String, dynamic> json) =
      _$ListModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get ownerId;
  @override
  String get userId; // Maps to user_id in database
  @override
  String? get familyId;
  @override
  List<String> get sharedWith;
  @override
  List<ListSublist> get sublists;
  @override
  bool get isTemplate;
  @override
  String? get templateCategory;
  @override
  bool get isShoppingList;
  @override
  String? get shoppingStoreId;
  @override
  int get totalItems;
  @override
  int get completedItems;
  @override
  bool get isArchived;
  @override
  bool get isDelegated;
  @override
  String? get delegatedTo;
  @override
  DateTime? get delegatedAt;
  @override
  String? get delegationNote;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastAccessedAt; // NEW MODERNIZED FIELDS from database schema
  @override
  String? get listCategoryId; // References list_categories table
  @override
  String? get templateId; // References list_templates table
  @override
  bool get createdFromTemplate;
  @override
  double get completionPercentage; // Auto-calculated in DB
  @override
  String? get listType; // 'planning' | 'shopping' | 'delegated'
  @override
  String get visibility; // 'private' | 'family' | 'public'
  @override
  bool get isFavorite;
  @override
  Map<String, dynamic> get reminderSettings;
  @override
  Map<String, dynamic>
      get settings; // Keep legacy fields for backward compatibility during migration
  @override
  String? get categoryId; // Legacy field - maps to category_id in DB
  @override
  String? get type;

  /// Create a copy of ListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListModelImplCopyWith<_$ListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
