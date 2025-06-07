// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allEntityCategoriesHash() =>
    r'e4c4be4c31aea273e7943740ee57df7374d54266';

/// See also [allEntityCategories].
@ProviderFor(allEntityCategories)
final allEntityCategoriesProvider =
    AutoDisposeFutureProvider<List<EntityCategory>>.internal(
  allEntityCategories,
  name: r'allEntityCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allEntityCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllEntityCategoriesRef
    = AutoDisposeFutureProviderRef<List<EntityCategory>>;
String _$entitySubcategoriesHash() =>
    r'f880870e6b9434f88d6e1d23db6658aa9ce77a79';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [entitySubcategories].
@ProviderFor(entitySubcategories)
const entitySubcategoriesProvider = EntitySubcategoriesFamily();

/// See also [entitySubcategories].
class EntitySubcategoriesFamily
    extends Family<AsyncValue<List<EntitySubcategoryModel>>> {
  /// See also [entitySubcategories].
  const EntitySubcategoriesFamily();

  /// See also [entitySubcategories].
  EntitySubcategoriesProvider call(
    String categoryId,
  ) {
    return EntitySubcategoriesProvider(
      categoryId,
    );
  }

  @override
  EntitySubcategoriesProvider getProviderOverride(
    covariant EntitySubcategoriesProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'entitySubcategoriesProvider';
}

/// See also [entitySubcategories].
class EntitySubcategoriesProvider
    extends AutoDisposeFutureProvider<List<EntitySubcategoryModel>> {
  /// See also [entitySubcategories].
  EntitySubcategoriesProvider(
    String categoryId,
  ) : this._internal(
          (ref) => entitySubcategories(
            ref as EntitySubcategoriesRef,
            categoryId,
          ),
          from: entitySubcategoriesProvider,
          name: r'entitySubcategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$entitySubcategoriesHash,
          dependencies: EntitySubcategoriesFamily._dependencies,
          allTransitiveDependencies:
              EntitySubcategoriesFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  EntitySubcategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<EntitySubcategoryModel>> Function(
            EntitySubcategoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EntitySubcategoriesProvider._internal(
        (ref) => create(ref as EntitySubcategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<EntitySubcategoryModel>>
      createElement() {
    return _EntitySubcategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EntitySubcategoriesProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EntitySubcategoriesRef
    on AutoDisposeFutureProviderRef<List<EntitySubcategoryModel>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _EntitySubcategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<EntitySubcategoryModel>>
    with EntitySubcategoriesRef {
  _EntitySubcategoriesProviderElement(super.provider);

  @override
  String get categoryId => (origin as EntitySubcategoriesProvider).categoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
