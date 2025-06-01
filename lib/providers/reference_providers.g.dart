// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$referencesHash() => r'295be8c5e3566bd82022ab182a78884bf5b707cf';

/// Provider for all references
///
/// Copied from [references].
@ProviderFor(references)
final referencesProvider =
    AutoDisposeFutureProvider<List<ReferenceModel>>.internal(
  references,
  name: r'referencesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$referencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReferencesRef = AutoDisposeFutureProviderRef<List<ReferenceModel>>;
String _$referenceGroupsHash() => r'0d5fb408ab5cbeb30cd28303be6333c34339eb2f';

/// Provider for all reference groups
///
/// Copied from [referenceGroups].
@ProviderFor(referenceGroups)
final referenceGroupsProvider =
    AutoDisposeFutureProvider<List<ReferenceGroupModel>>.internal(
  referenceGroups,
  name: r'referenceGroupsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$referenceGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReferenceGroupsRef
    = AutoDisposeFutureProviderRef<List<ReferenceGroupModel>>;
String _$referencesByGroupHash() => r'f00d0975008db2580dc7fbf3ccdd1f88863dc114';

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

/// Provider for references by group ID
///
/// Copied from [referencesByGroup].
@ProviderFor(referencesByGroup)
const referencesByGroupProvider = ReferencesByGroupFamily();

/// Provider for references by group ID
///
/// Copied from [referencesByGroup].
class ReferencesByGroupFamily extends Family<AsyncValue<List<ReferenceModel>>> {
  /// Provider for references by group ID
  ///
  /// Copied from [referencesByGroup].
  const ReferencesByGroupFamily();

  /// Provider for references by group ID
  ///
  /// Copied from [referencesByGroup].
  ReferencesByGroupProvider call(
    String groupId,
  ) {
    return ReferencesByGroupProvider(
      groupId,
    );
  }

  @override
  ReferencesByGroupProvider getProviderOverride(
    covariant ReferencesByGroupProvider provider,
  ) {
    return call(
      provider.groupId,
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
  String? get name => r'referencesByGroupProvider';
}

/// Provider for references by group ID
///
/// Copied from [referencesByGroup].
class ReferencesByGroupProvider
    extends AutoDisposeFutureProvider<List<ReferenceModel>> {
  /// Provider for references by group ID
  ///
  /// Copied from [referencesByGroup].
  ReferencesByGroupProvider(
    String groupId,
  ) : this._internal(
          (ref) => referencesByGroup(
            ref as ReferencesByGroupRef,
            groupId,
          ),
          from: referencesByGroupProvider,
          name: r'referencesByGroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$referencesByGroupHash,
          dependencies: ReferencesByGroupFamily._dependencies,
          allTransitiveDependencies:
              ReferencesByGroupFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  ReferencesByGroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    FutureOr<List<ReferenceModel>> Function(ReferencesByGroupRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReferencesByGroupProvider._internal(
        (ref) => create(ref as ReferencesByGroupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReferenceModel>> createElement() {
    return _ReferencesByGroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReferencesByGroupProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReferencesByGroupRef
    on AutoDisposeFutureProviderRef<List<ReferenceModel>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _ReferencesByGroupProviderElement
    extends AutoDisposeFutureProviderElement<List<ReferenceModel>>
    with ReferencesByGroupRef {
  _ReferencesByGroupProviderElement(super.provider);

  @override
  String get groupId => (origin as ReferencesByGroupProvider).groupId;
}

String _$referencesByEntityHash() =>
    r'c1f596a17c2e20de597dc90645992bbaad407a37';

/// Provider for references by entity ID
///
/// Copied from [referencesByEntity].
@ProviderFor(referencesByEntity)
const referencesByEntityProvider = ReferencesByEntityFamily();

/// Provider for references by entity ID
///
/// Copied from [referencesByEntity].
class ReferencesByEntityFamily
    extends Family<AsyncValue<List<ReferenceModel>>> {
  /// Provider for references by entity ID
  ///
  /// Copied from [referencesByEntity].
  const ReferencesByEntityFamily();

  /// Provider for references by entity ID
  ///
  /// Copied from [referencesByEntity].
  ReferencesByEntityProvider call(
    String entityId,
  ) {
    return ReferencesByEntityProvider(
      entityId,
    );
  }

  @override
  ReferencesByEntityProvider getProviderOverride(
    covariant ReferencesByEntityProvider provider,
  ) {
    return call(
      provider.entityId,
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
  String? get name => r'referencesByEntityProvider';
}

/// Provider for references by entity ID
///
/// Copied from [referencesByEntity].
class ReferencesByEntityProvider
    extends AutoDisposeFutureProvider<List<ReferenceModel>> {
  /// Provider for references by entity ID
  ///
  /// Copied from [referencesByEntity].
  ReferencesByEntityProvider(
    String entityId,
  ) : this._internal(
          (ref) => referencesByEntity(
            ref as ReferencesByEntityRef,
            entityId,
          ),
          from: referencesByEntityProvider,
          name: r'referencesByEntityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$referencesByEntityHash,
          dependencies: ReferencesByEntityFamily._dependencies,
          allTransitiveDependencies:
              ReferencesByEntityFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  ReferencesByEntityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityId,
  }) : super.internal();

  final String entityId;

  @override
  Override overrideWith(
    FutureOr<List<ReferenceModel>> Function(ReferencesByEntityRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReferencesByEntityProvider._internal(
        (ref) => create(ref as ReferencesByEntityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityId: entityId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReferenceModel>> createElement() {
    return _ReferencesByEntityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReferencesByEntityProvider && other.entityId == entityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReferencesByEntityRef
    on AutoDisposeFutureProviderRef<List<ReferenceModel>> {
  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _ReferencesByEntityProviderElement
    extends AutoDisposeFutureProviderElement<List<ReferenceModel>>
    with ReferencesByEntityRef {
  _ReferencesByEntityProviderElement(super.provider);

  @override
  String get entityId => (origin as ReferencesByEntityProvider).entityId;
}

String _$referenceByIdHash() => r'835f45979bdcba4d71125ede6c4ee06021bcc591';

/// Provider for a specific reference by ID
///
/// Copied from [referenceById].
@ProviderFor(referenceById)
const referenceByIdProvider = ReferenceByIdFamily();

/// Provider for a specific reference by ID
///
/// Copied from [referenceById].
class ReferenceByIdFamily extends Family<AsyncValue<ReferenceModel?>> {
  /// Provider for a specific reference by ID
  ///
  /// Copied from [referenceById].
  const ReferenceByIdFamily();

  /// Provider for a specific reference by ID
  ///
  /// Copied from [referenceById].
  ReferenceByIdProvider call(
    String id,
  ) {
    return ReferenceByIdProvider(
      id,
    );
  }

  @override
  ReferenceByIdProvider getProviderOverride(
    covariant ReferenceByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'referenceByIdProvider';
}

/// Provider for a specific reference by ID
///
/// Copied from [referenceById].
class ReferenceByIdProvider extends AutoDisposeFutureProvider<ReferenceModel?> {
  /// Provider for a specific reference by ID
  ///
  /// Copied from [referenceById].
  ReferenceByIdProvider(
    String id,
  ) : this._internal(
          (ref) => referenceById(
            ref as ReferenceByIdRef,
            id,
          ),
          from: referenceByIdProvider,
          name: r'referenceByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$referenceByIdHash,
          dependencies: ReferenceByIdFamily._dependencies,
          allTransitiveDependencies:
              ReferenceByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ReferenceByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ReferenceModel?> Function(ReferenceByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReferenceByIdProvider._internal(
        (ref) => create(ref as ReferenceByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReferenceModel?> createElement() {
    return _ReferenceByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReferenceByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReferenceByIdRef on AutoDisposeFutureProviderRef<ReferenceModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReferenceByIdProviderElement
    extends AutoDisposeFutureProviderElement<ReferenceModel?>
    with ReferenceByIdRef {
  _ReferenceByIdProviderElement(super.provider);

  @override
  String get id => (origin as ReferenceByIdProvider).id;
}

String _$referenceGroupByIdHash() =>
    r'c0c98ee9c13cb04109024f6e5939d4067a777c1e';

/// Provider for a specific reference group by ID
///
/// Copied from [referenceGroupById].
@ProviderFor(referenceGroupById)
const referenceGroupByIdProvider = ReferenceGroupByIdFamily();

/// Provider for a specific reference group by ID
///
/// Copied from [referenceGroupById].
class ReferenceGroupByIdFamily
    extends Family<AsyncValue<ReferenceGroupModel?>> {
  /// Provider for a specific reference group by ID
  ///
  /// Copied from [referenceGroupById].
  const ReferenceGroupByIdFamily();

  /// Provider for a specific reference group by ID
  ///
  /// Copied from [referenceGroupById].
  ReferenceGroupByIdProvider call(
    String id,
  ) {
    return ReferenceGroupByIdProvider(
      id,
    );
  }

  @override
  ReferenceGroupByIdProvider getProviderOverride(
    covariant ReferenceGroupByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'referenceGroupByIdProvider';
}

/// Provider for a specific reference group by ID
///
/// Copied from [referenceGroupById].
class ReferenceGroupByIdProvider
    extends AutoDisposeFutureProvider<ReferenceGroupModel?> {
  /// Provider for a specific reference group by ID
  ///
  /// Copied from [referenceGroupById].
  ReferenceGroupByIdProvider(
    String id,
  ) : this._internal(
          (ref) => referenceGroupById(
            ref as ReferenceGroupByIdRef,
            id,
          ),
          from: referenceGroupByIdProvider,
          name: r'referenceGroupByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$referenceGroupByIdHash,
          dependencies: ReferenceGroupByIdFamily._dependencies,
          allTransitiveDependencies:
              ReferenceGroupByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ReferenceGroupByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ReferenceGroupModel?> Function(ReferenceGroupByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReferenceGroupByIdProvider._internal(
        (ref) => create(ref as ReferenceGroupByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReferenceGroupModel?> createElement() {
    return _ReferenceGroupByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReferenceGroupByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReferenceGroupByIdRef
    on AutoDisposeFutureProviderRef<ReferenceGroupModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReferenceGroupByIdProviderElement
    extends AutoDisposeFutureProviderElement<ReferenceGroupModel?>
    with ReferenceGroupByIdRef {
  _ReferenceGroupByIdProviderElement(super.provider);

  @override
  String get id => (origin as ReferenceGroupByIdProvider).id;
}

String _$referenceNotifierHash() => r'0b6afb72f5b60b5a62e3aa3690ee01ff26dbad48';

/// Notifier for managing reference CRUD operations
///
/// Copied from [ReferenceNotifier].
@ProviderFor(ReferenceNotifier)
final referenceNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReferenceNotifier, void>.internal(
  ReferenceNotifier.new,
  name: r'referenceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$referenceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReferenceNotifier = AutoDisposeAsyncNotifier<void>;
String _$referenceGroupNotifierHash() =>
    r'16491afbf1787fd7544a6296b984d055424c820e';

/// Notifier for managing reference group CRUD operations
///
/// Copied from [ReferenceGroupNotifier].
@ProviderFor(ReferenceGroupNotifier)
final referenceGroupNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReferenceGroupNotifier, void>.internal(
  ReferenceGroupNotifier.new,
  name: r'referenceGroupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$referenceGroupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReferenceGroupNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
