// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingStoreModelImpl _$$ShoppingStoreModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingStoreModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      familyId: json['familyId'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aisleMapping: (json['aisleMapping'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      storeLayout: json['storeLayout'] as Map<String, dynamic>? ?? const {},
      logoUrl: json['logoUrl'] as String?,
      chainName: json['chainName'] as String?,
      operatingHours: (json['operatingHours'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      allowsPriceTracking: json['allowsPriceTracking'] as bool? ?? false,
      supportsOnlineOrders: json['supportsOnlineOrders'] as bool? ?? false,
      supportsCurbsidePickup: json['supportsCurbsidePickup'] as bool? ?? false,
      supportsDelivery: json['supportsDelivery'] as bool? ?? false,
      totalVisits: (json['totalVisits'] as num?)?.toInt() ?? 0,
      lastVisited: json['lastVisited'] == null
          ? null
          : DateTime.parse(json['lastVisited'] as String),
      averageSpentPerVisit:
          (json['averageSpentPerVisit'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ShoppingStoreModelImplToJson(
        _$ShoppingStoreModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'phoneNumber': instance.phoneNumber,
      'website': instance.website,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'familyId': instance.familyId,
      'sharedWith': instance.sharedWith,
      'aisleMapping': instance.aisleMapping,
      'storeLayout': instance.storeLayout,
      'logoUrl': instance.logoUrl,
      'chainName': instance.chainName,
      'operatingHours': instance.operatingHours,
      'allowsPriceTracking': instance.allowsPriceTracking,
      'supportsOnlineOrders': instance.supportsOnlineOrders,
      'supportsCurbsidePickup': instance.supportsCurbsidePickup,
      'supportsDelivery': instance.supportsDelivery,
      'totalVisits': instance.totalVisits,
      'lastVisited': instance.lastVisited?.toIso8601String(),
      'averageSpentPerVisit': instance.averageSpentPerVisit,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
