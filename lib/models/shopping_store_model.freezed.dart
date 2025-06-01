// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_store_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingStoreModel _$ShoppingStoreModelFromJson(Map<String, dynamic> json) {
  return _ShoppingStoreModel.fromJson(json);
}

/// @nodoc
mixin _$ShoppingStoreModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get zipCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get familyId => throw _privateConstructorUsedError;
  List<String> get sharedWith =>
      throw _privateConstructorUsedError; // Store preferences
  Map<String, String> get aisleMapping =>
      throw _privateConstructorUsedError; // item category -> aisle number
  Map<String, dynamic> get storeLayout => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get chainName =>
      throw _privateConstructorUsedError; // e.g., "Walmart", "Target", "Kroger"
// Operating hours
  Map<String, String> get operatingHours =>
      throw _privateConstructorUsedError; // day -> hours (e.g., "monday" -> "8:00 AM - 10:00 PM")
// Store-specific settings
  bool get allowsPriceTracking => throw _privateConstructorUsedError;
  bool get supportsOnlineOrders => throw _privateConstructorUsedError;
  bool get supportsCurbsidePickup => throw _privateConstructorUsedError;
  bool get supportsDelivery => throw _privateConstructorUsedError; // Analytics
  int get totalVisits => throw _privateConstructorUsedError;
  DateTime? get lastVisited => throw _privateConstructorUsedError;
  double get averageSpentPerVisit =>
      throw _privateConstructorUsedError; // Metadata
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ShoppingStoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingStoreModelCopyWith<ShoppingStoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingStoreModelCopyWith<$Res> {
  factory $ShoppingStoreModelCopyWith(
          ShoppingStoreModel value, $Res Function(ShoppingStoreModel) then) =
      _$ShoppingStoreModelCopyWithImpl<$Res, ShoppingStoreModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      String? city,
      String? state,
      String? zipCode,
      String? country,
      String? phoneNumber,
      String? website,
      String? description,
      String createdBy,
      String? familyId,
      List<String> sharedWith,
      Map<String, String> aisleMapping,
      Map<String, dynamic> storeLayout,
      String? logoUrl,
      String? chainName,
      Map<String, String> operatingHours,
      bool allowsPriceTracking,
      bool supportsOnlineOrders,
      bool supportsCurbsidePickup,
      bool supportsDelivery,
      int totalVisits,
      DateTime? lastVisited,
      double averageSpentPerVisit,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ShoppingStoreModelCopyWithImpl<$Res, $Val extends ShoppingStoreModel>
    implements $ShoppingStoreModelCopyWith<$Res> {
  _$ShoppingStoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? phoneNumber = freezed,
    Object? website = freezed,
    Object? description = freezed,
    Object? createdBy = null,
    Object? familyId = freezed,
    Object? sharedWith = null,
    Object? aisleMapping = null,
    Object? storeLayout = null,
    Object? logoUrl = freezed,
    Object? chainName = freezed,
    Object? operatingHours = null,
    Object? allowsPriceTracking = null,
    Object? supportsOnlineOrders = null,
    Object? supportsCurbsidePickup = null,
    Object? supportsDelivery = null,
    Object? totalVisits = null,
    Object? lastVisited = freezed,
    Object? averageSpentPerVisit = null,
    Object? metadata = null,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aisleMapping: null == aisleMapping
          ? _value.aisleMapping
          : aisleMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      storeLayout: null == storeLayout
          ? _value.storeLayout
          : storeLayout // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      chainName: freezed == chainName
          ? _value.chainName
          : chainName // ignore: cast_nullable_to_non_nullable
              as String?,
      operatingHours: null == operatingHours
          ? _value.operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      allowsPriceTracking: null == allowsPriceTracking
          ? _value.allowsPriceTracking
          : allowsPriceTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsOnlineOrders: null == supportsOnlineOrders
          ? _value.supportsOnlineOrders
          : supportsOnlineOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsCurbsidePickup: null == supportsCurbsidePickup
          ? _value.supportsCurbsidePickup
          : supportsCurbsidePickup // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDelivery: null == supportsDelivery
          ? _value.supportsDelivery
          : supportsDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      totalVisits: null == totalVisits
          ? _value.totalVisits
          : totalVisits // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisited: freezed == lastVisited
          ? _value.lastVisited
          : lastVisited // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      averageSpentPerVisit: null == averageSpentPerVisit
          ? _value.averageSpentPerVisit
          : averageSpentPerVisit // ignore: cast_nullable_to_non_nullable
              as double,
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
abstract class _$$ShoppingStoreModelImplCopyWith<$Res>
    implements $ShoppingStoreModelCopyWith<$Res> {
  factory _$$ShoppingStoreModelImplCopyWith(_$ShoppingStoreModelImpl value,
          $Res Function(_$ShoppingStoreModelImpl) then) =
      __$$ShoppingStoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      String? city,
      String? state,
      String? zipCode,
      String? country,
      String? phoneNumber,
      String? website,
      String? description,
      String createdBy,
      String? familyId,
      List<String> sharedWith,
      Map<String, String> aisleMapping,
      Map<String, dynamic> storeLayout,
      String? logoUrl,
      String? chainName,
      Map<String, String> operatingHours,
      bool allowsPriceTracking,
      bool supportsOnlineOrders,
      bool supportsCurbsidePickup,
      bool supportsDelivery,
      int totalVisits,
      DateTime? lastVisited,
      double averageSpentPerVisit,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ShoppingStoreModelImplCopyWithImpl<$Res>
    extends _$ShoppingStoreModelCopyWithImpl<$Res, _$ShoppingStoreModelImpl>
    implements _$$ShoppingStoreModelImplCopyWith<$Res> {
  __$$ShoppingStoreModelImplCopyWithImpl(_$ShoppingStoreModelImpl _value,
      $Res Function(_$ShoppingStoreModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShoppingStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? phoneNumber = freezed,
    Object? website = freezed,
    Object? description = freezed,
    Object? createdBy = null,
    Object? familyId = freezed,
    Object? sharedWith = null,
    Object? aisleMapping = null,
    Object? storeLayout = null,
    Object? logoUrl = freezed,
    Object? chainName = freezed,
    Object? operatingHours = null,
    Object? allowsPriceTracking = null,
    Object? supportsOnlineOrders = null,
    Object? supportsCurbsidePickup = null,
    Object? supportsDelivery = null,
    Object? totalVisits = null,
    Object? lastVisited = freezed,
    Object? averageSpentPerVisit = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ShoppingStoreModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value._sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      aisleMapping: null == aisleMapping
          ? _value._aisleMapping
          : aisleMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      storeLayout: null == storeLayout
          ? _value._storeLayout
          : storeLayout // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      chainName: freezed == chainName
          ? _value.chainName
          : chainName // ignore: cast_nullable_to_non_nullable
              as String?,
      operatingHours: null == operatingHours
          ? _value._operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      allowsPriceTracking: null == allowsPriceTracking
          ? _value.allowsPriceTracking
          : allowsPriceTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsOnlineOrders: null == supportsOnlineOrders
          ? _value.supportsOnlineOrders
          : supportsOnlineOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsCurbsidePickup: null == supportsCurbsidePickup
          ? _value.supportsCurbsidePickup
          : supportsCurbsidePickup // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDelivery: null == supportsDelivery
          ? _value.supportsDelivery
          : supportsDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      totalVisits: null == totalVisits
          ? _value.totalVisits
          : totalVisits // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisited: freezed == lastVisited
          ? _value.lastVisited
          : lastVisited // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      averageSpentPerVisit: null == averageSpentPerVisit
          ? _value.averageSpentPerVisit
          : averageSpentPerVisit // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$ShoppingStoreModelImpl implements _ShoppingStoreModel {
  const _$ShoppingStoreModelImpl(
      {required this.id,
      required this.name,
      this.address,
      this.city,
      this.state,
      this.zipCode,
      this.country,
      this.phoneNumber,
      this.website,
      this.description,
      required this.createdBy,
      this.familyId,
      final List<String> sharedWith = const [],
      final Map<String, String> aisleMapping = const {},
      final Map<String, dynamic> storeLayout = const {},
      this.logoUrl,
      this.chainName,
      final Map<String, String> operatingHours = const {},
      this.allowsPriceTracking = false,
      this.supportsOnlineOrders = false,
      this.supportsCurbsidePickup = false,
      this.supportsDelivery = false,
      this.totalVisits = 0,
      this.lastVisited,
      this.averageSpentPerVisit = 0.0,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      required this.updatedAt})
      : _sharedWith = sharedWith,
        _aisleMapping = aisleMapping,
        _storeLayout = storeLayout,
        _operatingHours = operatingHours,
        _metadata = metadata;

  factory _$ShoppingStoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingStoreModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? zipCode;
  @override
  final String? country;
  @override
  final String? phoneNumber;
  @override
  final String? website;
  @override
  final String? description;
  @override
  final String createdBy;
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

// Store preferences
  final Map<String, String> _aisleMapping;
// Store preferences
  @override
  @JsonKey()
  Map<String, String> get aisleMapping {
    if (_aisleMapping is EqualUnmodifiableMapView) return _aisleMapping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_aisleMapping);
  }

// item category -> aisle number
  final Map<String, dynamic> _storeLayout;
// item category -> aisle number
  @override
  @JsonKey()
  Map<String, dynamic> get storeLayout {
    if (_storeLayout is EqualUnmodifiableMapView) return _storeLayout;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storeLayout);
  }

  @override
  final String? logoUrl;
  @override
  final String? chainName;
// e.g., "Walmart", "Target", "Kroger"
// Operating hours
  final Map<String, String> _operatingHours;
// e.g., "Walmart", "Target", "Kroger"
// Operating hours
  @override
  @JsonKey()
  Map<String, String> get operatingHours {
    if (_operatingHours is EqualUnmodifiableMapView) return _operatingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_operatingHours);
  }

// day -> hours (e.g., "monday" -> "8:00 AM - 10:00 PM")
// Store-specific settings
  @override
  @JsonKey()
  final bool allowsPriceTracking;
  @override
  @JsonKey()
  final bool supportsOnlineOrders;
  @override
  @JsonKey()
  final bool supportsCurbsidePickup;
  @override
  @JsonKey()
  final bool supportsDelivery;
// Analytics
  @override
  @JsonKey()
  final int totalVisits;
  @override
  final DateTime? lastVisited;
  @override
  @JsonKey()
  final double averageSpentPerVisit;
// Metadata
  final Map<String, dynamic> _metadata;
// Metadata
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
    return 'ShoppingStoreModel(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, phoneNumber: $phoneNumber, website: $website, description: $description, createdBy: $createdBy, familyId: $familyId, sharedWith: $sharedWith, aisleMapping: $aisleMapping, storeLayout: $storeLayout, logoUrl: $logoUrl, chainName: $chainName, operatingHours: $operatingHours, allowsPriceTracking: $allowsPriceTracking, supportsOnlineOrders: $supportsOnlineOrders, supportsCurbsidePickup: $supportsCurbsidePickup, supportsDelivery: $supportsDelivery, totalVisits: $totalVisits, lastVisited: $lastVisited, averageSpentPerVisit: $averageSpentPerVisit, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingStoreModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            const DeepCollectionEquality()
                .equals(other._sharedWith, _sharedWith) &&
            const DeepCollectionEquality()
                .equals(other._aisleMapping, _aisleMapping) &&
            const DeepCollectionEquality()
                .equals(other._storeLayout, _storeLayout) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.chainName, chainName) ||
                other.chainName == chainName) &&
            const DeepCollectionEquality()
                .equals(other._operatingHours, _operatingHours) &&
            (identical(other.allowsPriceTracking, allowsPriceTracking) ||
                other.allowsPriceTracking == allowsPriceTracking) &&
            (identical(other.supportsOnlineOrders, supportsOnlineOrders) ||
                other.supportsOnlineOrders == supportsOnlineOrders) &&
            (identical(other.supportsCurbsidePickup, supportsCurbsidePickup) ||
                other.supportsCurbsidePickup == supportsCurbsidePickup) &&
            (identical(other.supportsDelivery, supportsDelivery) ||
                other.supportsDelivery == supportsDelivery) &&
            (identical(other.totalVisits, totalVisits) ||
                other.totalVisits == totalVisits) &&
            (identical(other.lastVisited, lastVisited) ||
                other.lastVisited == lastVisited) &&
            (identical(other.averageSpentPerVisit, averageSpentPerVisit) ||
                other.averageSpentPerVisit == averageSpentPerVisit) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        address,
        city,
        state,
        zipCode,
        country,
        phoneNumber,
        website,
        description,
        createdBy,
        familyId,
        const DeepCollectionEquality().hash(_sharedWith),
        const DeepCollectionEquality().hash(_aisleMapping),
        const DeepCollectionEquality().hash(_storeLayout),
        logoUrl,
        chainName,
        const DeepCollectionEquality().hash(_operatingHours),
        allowsPriceTracking,
        supportsOnlineOrders,
        supportsCurbsidePickup,
        supportsDelivery,
        totalVisits,
        lastVisited,
        averageSpentPerVisit,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ShoppingStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingStoreModelImplCopyWith<_$ShoppingStoreModelImpl> get copyWith =>
      __$$ShoppingStoreModelImplCopyWithImpl<_$ShoppingStoreModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingStoreModelImplToJson(
      this,
    );
  }
}

abstract class _ShoppingStoreModel implements ShoppingStoreModel {
  const factory _ShoppingStoreModel(
      {required final String id,
      required final String name,
      final String? address,
      final String? city,
      final String? state,
      final String? zipCode,
      final String? country,
      final String? phoneNumber,
      final String? website,
      final String? description,
      required final String createdBy,
      final String? familyId,
      final List<String> sharedWith,
      final Map<String, String> aisleMapping,
      final Map<String, dynamic> storeLayout,
      final String? logoUrl,
      final String? chainName,
      final Map<String, String> operatingHours,
      final bool allowsPriceTracking,
      final bool supportsOnlineOrders,
      final bool supportsCurbsidePickup,
      final bool supportsDelivery,
      final int totalVisits,
      final DateTime? lastVisited,
      final double averageSpentPerVisit,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ShoppingStoreModelImpl;

  factory _ShoppingStoreModel.fromJson(Map<String, dynamic> json) =
      _$ShoppingStoreModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get zipCode;
  @override
  String? get country;
  @override
  String? get phoneNumber;
  @override
  String? get website;
  @override
  String? get description;
  @override
  String get createdBy;
  @override
  String? get familyId;
  @override
  List<String> get sharedWith; // Store preferences
  @override
  Map<String, String> get aisleMapping; // item category -> aisle number
  @override
  Map<String, dynamic> get storeLayout;
  @override
  String? get logoUrl;
  @override
  String? get chainName; // e.g., "Walmart", "Target", "Kroger"
// Operating hours
  @override
  Map<String, String>
      get operatingHours; // day -> hours (e.g., "monday" -> "8:00 AM - 10:00 PM")
// Store-specific settings
  @override
  bool get allowsPriceTracking;
  @override
  bool get supportsOnlineOrders;
  @override
  bool get supportsCurbsidePickup;
  @override
  bool get supportsDelivery; // Analytics
  @override
  int get totalVisits;
  @override
  DateTime? get lastVisited;
  @override
  double get averageSpentPerVisit; // Metadata
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ShoppingStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingStoreModelImplCopyWith<_$ShoppingStoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
