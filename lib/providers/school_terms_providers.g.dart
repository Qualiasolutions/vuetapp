// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_terms_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$schoolTermsDataHash() => r'24795b07f71b47a2c66490dee8534df96dc70ea0';

/// See also [schoolTermsData].
@ProviderFor(schoolTermsData)
final schoolTermsDataProvider =
    AutoDisposeFutureProvider<SchoolTermsData>.internal(
  schoolTermsData,
  name: r'schoolTermsDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$schoolTermsDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SchoolTermsDataRef = AutoDisposeFutureProviderRef<SchoolTermsData>;
String _$schoolYearsHash() => r'dcd8e9cad5c664e9b408ae656c8de15521f0d60a';

/// See also [schoolYears].
@ProviderFor(schoolYears)
final schoolYearsProvider =
    AutoDisposeFutureProvider<List<SchoolYearModel>>.internal(
  schoolYears,
  name: r'schoolYearsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$schoolYearsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SchoolYearsRef = AutoDisposeFutureProviderRef<List<SchoolYearModel>>;
String _$schoolTermsForYearHash() =>
    r'c7eafc8caffec36efcfe0e0acf8d245722e69413';

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

/// See also [schoolTermsForYear].
@ProviderFor(schoolTermsForYear)
const schoolTermsForYearProvider = SchoolTermsForYearFamily();

/// See also [schoolTermsForYear].
class SchoolTermsForYearFamily
    extends Family<AsyncValue<List<SchoolTermModel>>> {
  /// See also [schoolTermsForYear].
  const SchoolTermsForYearFamily();

  /// See also [schoolTermsForYear].
  SchoolTermsForYearProvider call(
    String schoolYearId,
  ) {
    return SchoolTermsForYearProvider(
      schoolYearId,
    );
  }

  @override
  SchoolTermsForYearProvider getProviderOverride(
    covariant SchoolTermsForYearProvider provider,
  ) {
    return call(
      provider.schoolYearId,
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
  String? get name => r'schoolTermsForYearProvider';
}

/// See also [schoolTermsForYear].
class SchoolTermsForYearProvider
    extends AutoDisposeFutureProvider<List<SchoolTermModel>> {
  /// See also [schoolTermsForYear].
  SchoolTermsForYearProvider(
    String schoolYearId,
  ) : this._internal(
          (ref) => schoolTermsForYear(
            ref as SchoolTermsForYearRef,
            schoolYearId,
          ),
          from: schoolTermsForYearProvider,
          name: r'schoolTermsForYearProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$schoolTermsForYearHash,
          dependencies: SchoolTermsForYearFamily._dependencies,
          allTransitiveDependencies:
              SchoolTermsForYearFamily._allTransitiveDependencies,
          schoolYearId: schoolYearId,
        );

  SchoolTermsForYearProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.schoolYearId,
  }) : super.internal();

  final String schoolYearId;

  @override
  Override overrideWith(
    FutureOr<List<SchoolTermModel>> Function(SchoolTermsForYearRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SchoolTermsForYearProvider._internal(
        (ref) => create(ref as SchoolTermsForYearRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        schoolYearId: schoolYearId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SchoolTermModel>> createElement() {
    return _SchoolTermsForYearProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SchoolTermsForYearProvider &&
        other.schoolYearId == schoolYearId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, schoolYearId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SchoolTermsForYearRef
    on AutoDisposeFutureProviderRef<List<SchoolTermModel>> {
  /// The parameter `schoolYearId` of this provider.
  String get schoolYearId;
}

class _SchoolTermsForYearProviderElement
    extends AutoDisposeFutureProviderElement<List<SchoolTermModel>>
    with SchoolTermsForYearRef {
  _SchoolTermsForYearProviderElement(super.provider);

  @override
  String get schoolYearId =>
      (origin as SchoolTermsForYearProvider).schoolYearId;
}

String _$schoolBreaksForYearHash() =>
    r'ba6bc6cf17765ee0640a66c24835496a5ef8e14f';

/// See also [schoolBreaksForYear].
@ProviderFor(schoolBreaksForYear)
const schoolBreaksForYearProvider = SchoolBreaksForYearFamily();

/// See also [schoolBreaksForYear].
class SchoolBreaksForYearFamily
    extends Family<AsyncValue<List<SchoolBreakModel>>> {
  /// See also [schoolBreaksForYear].
  const SchoolBreaksForYearFamily();

  /// See also [schoolBreaksForYear].
  SchoolBreaksForYearProvider call(
    String schoolYearId,
  ) {
    return SchoolBreaksForYearProvider(
      schoolYearId,
    );
  }

  @override
  SchoolBreaksForYearProvider getProviderOverride(
    covariant SchoolBreaksForYearProvider provider,
  ) {
    return call(
      provider.schoolYearId,
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
  String? get name => r'schoolBreaksForYearProvider';
}

/// See also [schoolBreaksForYear].
class SchoolBreaksForYearProvider
    extends AutoDisposeFutureProvider<List<SchoolBreakModel>> {
  /// See also [schoolBreaksForYear].
  SchoolBreaksForYearProvider(
    String schoolYearId,
  ) : this._internal(
          (ref) => schoolBreaksForYear(
            ref as SchoolBreaksForYearRef,
            schoolYearId,
          ),
          from: schoolBreaksForYearProvider,
          name: r'schoolBreaksForYearProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$schoolBreaksForYearHash,
          dependencies: SchoolBreaksForYearFamily._dependencies,
          allTransitiveDependencies:
              SchoolBreaksForYearFamily._allTransitiveDependencies,
          schoolYearId: schoolYearId,
        );

  SchoolBreaksForYearProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.schoolYearId,
  }) : super.internal();

  final String schoolYearId;

  @override
  Override overrideWith(
    FutureOr<List<SchoolBreakModel>> Function(SchoolBreaksForYearRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SchoolBreaksForYearProvider._internal(
        (ref) => create(ref as SchoolBreaksForYearRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        schoolYearId: schoolYearId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SchoolBreakModel>> createElement() {
    return _SchoolBreaksForYearProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SchoolBreaksForYearProvider &&
        other.schoolYearId == schoolYearId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, schoolYearId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SchoolBreaksForYearRef
    on AutoDisposeFutureProviderRef<List<SchoolBreakModel>> {
  /// The parameter `schoolYearId` of this provider.
  String get schoolYearId;
}

class _SchoolBreaksForYearProviderElement
    extends AutoDisposeFutureProviderElement<List<SchoolBreakModel>>
    with SchoolBreaksForYearRef {
  _SchoolBreaksForYearProviderElement(super.provider);

  @override
  String get schoolYearId =>
      (origin as SchoolBreaksForYearProvider).schoolYearId;
}

String _$calendarSchoolYearsHash() =>
    r'0ba6200d303175ea55fb503867e883e11b20bc87';

/// See also [calendarSchoolYears].
@ProviderFor(calendarSchoolYears)
final calendarSchoolYearsProvider =
    AutoDisposeFutureProvider<List<SchoolYearModel>>.internal(
  calendarSchoolYears,
  name: r'calendarSchoolYearsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarSchoolYearsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalendarSchoolYearsRef
    = AutoDisposeFutureProviderRef<List<SchoolYearModel>>;
String _$calendarSchoolTermsHash() =>
    r'a1073d0e6b06f318a5f30af625ebc082a597388b';

/// See also [calendarSchoolTerms].
@ProviderFor(calendarSchoolTerms)
const calendarSchoolTermsProvider = CalendarSchoolTermsFamily();

/// See also [calendarSchoolTerms].
class CalendarSchoolTermsFamily
    extends Family<AsyncValue<List<SchoolTermModel>>> {
  /// See also [calendarSchoolTerms].
  const CalendarSchoolTermsFamily();

  /// See also [calendarSchoolTerms].
  CalendarSchoolTermsProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return CalendarSchoolTermsProvider(
      startDate,
      endDate,
    );
  }

  @override
  CalendarSchoolTermsProvider getProviderOverride(
    covariant CalendarSchoolTermsProvider provider,
  ) {
    return call(
      provider.startDate,
      provider.endDate,
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
  String? get name => r'calendarSchoolTermsProvider';
}

/// See also [calendarSchoolTerms].
class CalendarSchoolTermsProvider
    extends AutoDisposeFutureProvider<List<SchoolTermModel>> {
  /// See also [calendarSchoolTerms].
  CalendarSchoolTermsProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => calendarSchoolTerms(
            ref as CalendarSchoolTermsRef,
            startDate,
            endDate,
          ),
          from: calendarSchoolTermsProvider,
          name: r'calendarSchoolTermsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calendarSchoolTermsHash,
          dependencies: CalendarSchoolTermsFamily._dependencies,
          allTransitiveDependencies:
              CalendarSchoolTermsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  CalendarSchoolTermsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<List<SchoolTermModel>> Function(CalendarSchoolTermsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalendarSchoolTermsProvider._internal(
        (ref) => create(ref as CalendarSchoolTermsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SchoolTermModel>> createElement() {
    return _CalendarSchoolTermsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarSchoolTermsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalendarSchoolTermsRef
    on AutoDisposeFutureProviderRef<List<SchoolTermModel>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _CalendarSchoolTermsProviderElement
    extends AutoDisposeFutureProviderElement<List<SchoolTermModel>>
    with CalendarSchoolTermsRef {
  _CalendarSchoolTermsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as CalendarSchoolTermsProvider).startDate;
  @override
  DateTime get endDate => (origin as CalendarSchoolTermsProvider).endDate;
}

String _$calendarSchoolBreaksHash() =>
    r'febf021e367f1ab1897e09d11cd01d70c1de1628';

/// See also [calendarSchoolBreaks].
@ProviderFor(calendarSchoolBreaks)
const calendarSchoolBreaksProvider = CalendarSchoolBreaksFamily();

/// See also [calendarSchoolBreaks].
class CalendarSchoolBreaksFamily
    extends Family<AsyncValue<List<SchoolBreakModel>>> {
  /// See also [calendarSchoolBreaks].
  const CalendarSchoolBreaksFamily();

  /// See also [calendarSchoolBreaks].
  CalendarSchoolBreaksProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return CalendarSchoolBreaksProvider(
      startDate,
      endDate,
    );
  }

  @override
  CalendarSchoolBreaksProvider getProviderOverride(
    covariant CalendarSchoolBreaksProvider provider,
  ) {
    return call(
      provider.startDate,
      provider.endDate,
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
  String? get name => r'calendarSchoolBreaksProvider';
}

/// See also [calendarSchoolBreaks].
class CalendarSchoolBreaksProvider
    extends AutoDisposeFutureProvider<List<SchoolBreakModel>> {
  /// See also [calendarSchoolBreaks].
  CalendarSchoolBreaksProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => calendarSchoolBreaks(
            ref as CalendarSchoolBreaksRef,
            startDate,
            endDate,
          ),
          from: calendarSchoolBreaksProvider,
          name: r'calendarSchoolBreaksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calendarSchoolBreaksHash,
          dependencies: CalendarSchoolBreaksFamily._dependencies,
          allTransitiveDependencies:
              CalendarSchoolBreaksFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  CalendarSchoolBreaksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<List<SchoolBreakModel>> Function(CalendarSchoolBreaksRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalendarSchoolBreaksProvider._internal(
        (ref) => create(ref as CalendarSchoolBreaksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SchoolBreakModel>> createElement() {
    return _CalendarSchoolBreaksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarSchoolBreaksProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalendarSchoolBreaksRef
    on AutoDisposeFutureProviderRef<List<SchoolBreakModel>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _CalendarSchoolBreaksProviderElement
    extends AutoDisposeFutureProviderElement<List<SchoolBreakModel>>
    with CalendarSchoolBreaksRef {
  _CalendarSchoolBreaksProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as CalendarSchoolBreaksProvider).startDate;
  @override
  DateTime get endDate => (origin as CalendarSchoolBreaksProvider).endDate;
}

String _$schoolYearByIdHash() => r'52bd9c55b9fd051fe137f12724ad667eeddefe16';

/// See also [schoolYearById].
@ProviderFor(schoolYearById)
const schoolYearByIdProvider = SchoolYearByIdFamily();

/// See also [schoolYearById].
class SchoolYearByIdFamily extends Family<AsyncValue<SchoolYearModel?>> {
  /// See also [schoolYearById].
  const SchoolYearByIdFamily();

  /// See also [schoolYearById].
  SchoolYearByIdProvider call(
    String id,
  ) {
    return SchoolYearByIdProvider(
      id,
    );
  }

  @override
  SchoolYearByIdProvider getProviderOverride(
    covariant SchoolYearByIdProvider provider,
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
  String? get name => r'schoolYearByIdProvider';
}

/// See also [schoolYearById].
class SchoolYearByIdProvider
    extends AutoDisposeFutureProvider<SchoolYearModel?> {
  /// See also [schoolYearById].
  SchoolYearByIdProvider(
    String id,
  ) : this._internal(
          (ref) => schoolYearById(
            ref as SchoolYearByIdRef,
            id,
          ),
          from: schoolYearByIdProvider,
          name: r'schoolYearByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$schoolYearByIdHash,
          dependencies: SchoolYearByIdFamily._dependencies,
          allTransitiveDependencies:
              SchoolYearByIdFamily._allTransitiveDependencies,
          id: id,
        );

  SchoolYearByIdProvider._internal(
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
    FutureOr<SchoolYearModel?> Function(SchoolYearByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SchoolYearByIdProvider._internal(
        (ref) => create(ref as SchoolYearByIdRef),
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
  AutoDisposeFutureProviderElement<SchoolYearModel?> createElement() {
    return _SchoolYearByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SchoolYearByIdProvider && other.id == id;
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
mixin SchoolYearByIdRef on AutoDisposeFutureProviderRef<SchoolYearModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SchoolYearByIdProviderElement
    extends AutoDisposeFutureProviderElement<SchoolYearModel?>
    with SchoolYearByIdRef {
  _SchoolYearByIdProviderElement(super.provider);

  @override
  String get id => (origin as SchoolYearByIdProvider).id;
}

String _$schoolTermByIdHash() => r'52cde1ddd97df3008d381147d0a4b90c58477664';

/// See also [schoolTermById].
@ProviderFor(schoolTermById)
const schoolTermByIdProvider = SchoolTermByIdFamily();

/// See also [schoolTermById].
class SchoolTermByIdFamily extends Family<AsyncValue<SchoolTermModel?>> {
  /// See also [schoolTermById].
  const SchoolTermByIdFamily();

  /// See also [schoolTermById].
  SchoolTermByIdProvider call(
    String id,
  ) {
    return SchoolTermByIdProvider(
      id,
    );
  }

  @override
  SchoolTermByIdProvider getProviderOverride(
    covariant SchoolTermByIdProvider provider,
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
  String? get name => r'schoolTermByIdProvider';
}

/// See also [schoolTermById].
class SchoolTermByIdProvider
    extends AutoDisposeFutureProvider<SchoolTermModel?> {
  /// See also [schoolTermById].
  SchoolTermByIdProvider(
    String id,
  ) : this._internal(
          (ref) => schoolTermById(
            ref as SchoolTermByIdRef,
            id,
          ),
          from: schoolTermByIdProvider,
          name: r'schoolTermByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$schoolTermByIdHash,
          dependencies: SchoolTermByIdFamily._dependencies,
          allTransitiveDependencies:
              SchoolTermByIdFamily._allTransitiveDependencies,
          id: id,
        );

  SchoolTermByIdProvider._internal(
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
    FutureOr<SchoolTermModel?> Function(SchoolTermByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SchoolTermByIdProvider._internal(
        (ref) => create(ref as SchoolTermByIdRef),
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
  AutoDisposeFutureProviderElement<SchoolTermModel?> createElement() {
    return _SchoolTermByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SchoolTermByIdProvider && other.id == id;
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
mixin SchoolTermByIdRef on AutoDisposeFutureProviderRef<SchoolTermModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SchoolTermByIdProviderElement
    extends AutoDisposeFutureProviderElement<SchoolTermModel?>
    with SchoolTermByIdRef {
  _SchoolTermByIdProviderElement(super.provider);

  @override
  String get id => (origin as SchoolTermByIdProvider).id;
}

String _$schoolBreakByIdHash() => r'57e47e66602f8e4611f81b31104b1f934eb3fd55';

/// See also [schoolBreakById].
@ProviderFor(schoolBreakById)
const schoolBreakByIdProvider = SchoolBreakByIdFamily();

/// See also [schoolBreakById].
class SchoolBreakByIdFamily extends Family<AsyncValue<SchoolBreakModel?>> {
  /// See also [schoolBreakById].
  const SchoolBreakByIdFamily();

  /// See also [schoolBreakById].
  SchoolBreakByIdProvider call(
    String id,
  ) {
    return SchoolBreakByIdProvider(
      id,
    );
  }

  @override
  SchoolBreakByIdProvider getProviderOverride(
    covariant SchoolBreakByIdProvider provider,
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
  String? get name => r'schoolBreakByIdProvider';
}

/// See also [schoolBreakById].
class SchoolBreakByIdProvider
    extends AutoDisposeFutureProvider<SchoolBreakModel?> {
  /// See also [schoolBreakById].
  SchoolBreakByIdProvider(
    String id,
  ) : this._internal(
          (ref) => schoolBreakById(
            ref as SchoolBreakByIdRef,
            id,
          ),
          from: schoolBreakByIdProvider,
          name: r'schoolBreakByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$schoolBreakByIdHash,
          dependencies: SchoolBreakByIdFamily._dependencies,
          allTransitiveDependencies:
              SchoolBreakByIdFamily._allTransitiveDependencies,
          id: id,
        );

  SchoolBreakByIdProvider._internal(
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
    FutureOr<SchoolBreakModel?> Function(SchoolBreakByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SchoolBreakByIdProvider._internal(
        (ref) => create(ref as SchoolBreakByIdRef),
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
  AutoDisposeFutureProviderElement<SchoolBreakModel?> createElement() {
    return _SchoolBreakByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SchoolBreakByIdProvider && other.id == id;
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
mixin SchoolBreakByIdRef on AutoDisposeFutureProviderRef<SchoolBreakModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SchoolBreakByIdProviderElement
    extends AutoDisposeFutureProviderElement<SchoolBreakModel?>
    with SchoolBreakByIdRef {
  _SchoolBreakByIdProviderElement(super.provider);

  @override
  String get id => (origin as SchoolBreakByIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
