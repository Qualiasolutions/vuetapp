// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListTemplateModel _$ListTemplateModelFromJson(Map<String, dynamic> json) {
  return _ListTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$ListTemplateModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  List<ListSublist> get sublists => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get popularity => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isSystemTemplate => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ListTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListTemplateModelCopyWith<ListTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListTemplateModelCopyWith<$Res> {
  factory $ListTemplateModelCopyWith(
          ListTemplateModel value, $Res Function(ListTemplateModel) then) =
      _$ListTemplateModelCopyWithImpl<$Res, ListTemplateModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String categoryId,
      String? icon,
      String? color,
      List<ListSublist> sublists,
      List<String> tags,
      int popularity,
      bool isPremium,
      bool isSystemTemplate,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ListTemplateModelCopyWithImpl<$Res, $Val extends ListTemplateModel>
    implements $ListTemplateModelCopyWith<$Res> {
  _$ListTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? sublists = null,
    Object? tags = null,
    Object? popularity = null,
    Object? isPremium = null,
    Object? isSystemTemplate = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sublists: null == sublists
          ? _value.sublists
          : sublists // ignore: cast_nullable_to_non_nullable
              as List<ListSublist>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemTemplate: null == isSystemTemplate
          ? _value.isSystemTemplate
          : isSystemTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListTemplateModelImplCopyWith<$Res>
    implements $ListTemplateModelCopyWith<$Res> {
  factory _$$ListTemplateModelImplCopyWith(_$ListTemplateModelImpl value,
          $Res Function(_$ListTemplateModelImpl) then) =
      __$$ListTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String categoryId,
      String? icon,
      String? color,
      List<ListSublist> sublists,
      List<String> tags,
      int popularity,
      bool isPremium,
      bool isSystemTemplate,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ListTemplateModelImplCopyWithImpl<$Res>
    extends _$ListTemplateModelCopyWithImpl<$Res, _$ListTemplateModelImpl>
    implements _$$ListTemplateModelImplCopyWith<$Res> {
  __$$ListTemplateModelImplCopyWithImpl(_$ListTemplateModelImpl _value,
      $Res Function(_$ListTemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? sublists = null,
    Object? tags = null,
    Object? popularity = null,
    Object? isPremium = null,
    Object? isSystemTemplate = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ListTemplateModelImpl(
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
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sublists: null == sublists
          ? _value._sublists
          : sublists // ignore: cast_nullable_to_non_nullable
              as List<ListSublist>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemTemplate: null == isSystemTemplate
          ? _value.isSystemTemplate
          : isSystemTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListTemplateModelImpl implements _ListTemplateModel {
  const _$ListTemplateModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.categoryId,
      this.icon,
      this.color,
      final List<ListSublist> sublists = const [],
      final List<String> tags = const [],
      this.popularity = 0,
      this.isPremium = false,
      this.isSystemTemplate = false,
      this.createdBy,
      this.createdAt,
      this.updatedAt})
      : _sublists = sublists,
        _tags = tags;

  factory _$ListTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListTemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String categoryId;
  @override
  final String? icon;
  @override
  final String? color;
  final List<ListSublist> _sublists;
  @override
  @JsonKey()
  List<ListSublist> get sublists {
    if (_sublists is EqualUnmodifiableListView) return _sublists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sublists);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int popularity;
  @override
  @JsonKey()
  final bool isPremium;
  @override
  @JsonKey()
  final bool isSystemTemplate;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ListTemplateModel(id: $id, name: $name, description: $description, categoryId: $categoryId, icon: $icon, color: $color, sublists: $sublists, tags: $tags, popularity: $popularity, isPremium: $isPremium, isSystemTemplate: $isSystemTemplate, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListTemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._sublists, _sublists) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isSystemTemplate, isSystemTemplate) ||
                other.isSystemTemplate == isSystemTemplate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
      description,
      categoryId,
      icon,
      color,
      const DeepCollectionEquality().hash(_sublists),
      const DeepCollectionEquality().hash(_tags),
      popularity,
      isPremium,
      isSystemTemplate,
      createdBy,
      createdAt,
      updatedAt);

  /// Create a copy of ListTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListTemplateModelImplCopyWith<_$ListTemplateModelImpl> get copyWith =>
      __$$ListTemplateModelImplCopyWithImpl<_$ListTemplateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _ListTemplateModel implements ListTemplateModel {
  const factory _ListTemplateModel(
      {required final String id,
      required final String name,
      final String? description,
      required final String categoryId,
      final String? icon,
      final String? color,
      final List<ListSublist> sublists,
      final List<String> tags,
      final int popularity,
      final bool isPremium,
      final bool isSystemTemplate,
      final String? createdBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ListTemplateModelImpl;

  factory _ListTemplateModel.fromJson(Map<String, dynamic> json) =
      _$ListTemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get categoryId;
  @override
  String? get icon;
  @override
  String? get color;
  @override
  List<ListSublist> get sublists;
  @override
  List<String> get tags;
  @override
  int get popularity;
  @override
  bool get isPremium;
  @override
  bool get isSystemTemplate;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ListTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListTemplateModelImplCopyWith<_$ListTemplateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
