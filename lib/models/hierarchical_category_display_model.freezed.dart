// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hierarchical_category_display_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HierarchicalCategoryDisplayModel {
  EntityCategory get category =>
      throw _privateConstructorUsedError; // Updated from EntityCategoryModel
  List<HierarchicalCategoryDisplayModel> get children =>
      throw _privateConstructorUsedError;

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HierarchicalCategoryDisplayModelCopyWith<HierarchicalCategoryDisplayModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HierarchicalCategoryDisplayModelCopyWith<$Res> {
  factory $HierarchicalCategoryDisplayModelCopyWith(
          HierarchicalCategoryDisplayModel value,
          $Res Function(HierarchicalCategoryDisplayModel) then) =
      _$HierarchicalCategoryDisplayModelCopyWithImpl<$Res,
          HierarchicalCategoryDisplayModel>;
  @useResult
  $Res call(
      {EntityCategory category,
      List<HierarchicalCategoryDisplayModel> children});

  $EntityCategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$HierarchicalCategoryDisplayModelCopyWithImpl<$Res,
        $Val extends HierarchicalCategoryDisplayModel>
    implements $HierarchicalCategoryDisplayModelCopyWith<$Res> {
  _$HierarchicalCategoryDisplayModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EntityCategory,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<HierarchicalCategoryDisplayModel>,
    ) as $Val);
  }

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EntityCategoryCopyWith<$Res> get category {
    return $EntityCategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HierarchicalCategoryDisplayModelImplCopyWith<$Res>
    implements $HierarchicalCategoryDisplayModelCopyWith<$Res> {
  factory _$$HierarchicalCategoryDisplayModelImplCopyWith(
          _$HierarchicalCategoryDisplayModelImpl value,
          $Res Function(_$HierarchicalCategoryDisplayModelImpl) then) =
      __$$HierarchicalCategoryDisplayModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EntityCategory category,
      List<HierarchicalCategoryDisplayModel> children});

  @override
  $EntityCategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$HierarchicalCategoryDisplayModelImplCopyWithImpl<$Res>
    extends _$HierarchicalCategoryDisplayModelCopyWithImpl<$Res,
        _$HierarchicalCategoryDisplayModelImpl>
    implements _$$HierarchicalCategoryDisplayModelImplCopyWith<$Res> {
  __$$HierarchicalCategoryDisplayModelImplCopyWithImpl(
      _$HierarchicalCategoryDisplayModelImpl _value,
      $Res Function(_$HierarchicalCategoryDisplayModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? children = null,
  }) {
    return _then(_$HierarchicalCategoryDisplayModelImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as EntityCategory,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<HierarchicalCategoryDisplayModel>,
    ));
  }
}

/// @nodoc

class _$HierarchicalCategoryDisplayModelImpl
    implements _HierarchicalCategoryDisplayModel {
  const _$HierarchicalCategoryDisplayModelImpl(
      {required this.category,
      required final List<HierarchicalCategoryDisplayModel> children})
      : _children = children;

  @override
  final EntityCategory category;
// Updated from EntityCategoryModel
  final List<HierarchicalCategoryDisplayModel> _children;
// Updated from EntityCategoryModel
  @override
  List<HierarchicalCategoryDisplayModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'HierarchicalCategoryDisplayModel(category: $category, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HierarchicalCategoryDisplayModelImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, category, const DeepCollectionEquality().hash(_children));

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HierarchicalCategoryDisplayModelImplCopyWith<
          _$HierarchicalCategoryDisplayModelImpl>
      get copyWith => __$$HierarchicalCategoryDisplayModelImplCopyWithImpl<
          _$HierarchicalCategoryDisplayModelImpl>(this, _$identity);
}

abstract class _HierarchicalCategoryDisplayModel
    implements HierarchicalCategoryDisplayModel {
  const factory _HierarchicalCategoryDisplayModel(
          {required final EntityCategory category,
          required final List<HierarchicalCategoryDisplayModel> children}) =
      _$HierarchicalCategoryDisplayModelImpl;

  @override
  EntityCategory get category; // Updated from EntityCategoryModel
  @override
  List<HierarchicalCategoryDisplayModel> get children;

  /// Create a copy of HierarchicalCategoryDisplayModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HierarchicalCategoryDisplayModelImplCopyWith<
          _$HierarchicalCategoryDisplayModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
