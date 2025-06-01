import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'shopping_store_model.freezed.dart';
part 'shopping_store_model.g.dart';

@freezed
class ShoppingStoreModel with _$ShoppingStoreModel {
  const factory ShoppingStoreModel({
    required String id,
    required String name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phoneNumber,
    String? website,
    String? description,
    required String createdBy,
    String? familyId,
    @Default([]) List<String> sharedWith,
    // Store preferences
    @Default({}) Map<String, String> aisleMapping, // item category -> aisle number
    @Default({}) Map<String, dynamic> storeLayout,
    String? logoUrl,
    String? chainName, // e.g., "Walmart", "Target", "Kroger"
    // Operating hours
    @Default({}) Map<String, String> operatingHours, // day -> hours (e.g., "monday" -> "8:00 AM - 10:00 PM")
    // Store-specific settings
    @Default(false) bool allowsPriceTracking,
    @Default(false) bool supportsOnlineOrders,
    @Default(false) bool supportsCurbsidePickup,
    @Default(false) bool supportsDelivery,
    // Analytics
    @Default(0) int totalVisits,
    DateTime? lastVisited,
    @Default(0.0) double averageSpentPerVisit,
    // Metadata
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShoppingStoreModel;

  factory ShoppingStoreModel.fromJson(Map<String, dynamic> json) => _$ShoppingStoreModelFromJson(json);

  // Factory constructor for creating a new store
  factory ShoppingStoreModel.create({
    required String name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phoneNumber,
    String? website,
    String? description,
    required String createdBy,
    String? familyId,
    String? chainName,
    String? logoUrl,
  }) {
    final now = DateTime.now();
    return ShoppingStoreModel(
      id: const Uuid().v4(),
      name: name,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      phoneNumber: phoneNumber,
      website: website,
      description: description,
      createdBy: createdBy,
      familyId: familyId,
      chainName: chainName,
      logoUrl: logoUrl,
      createdAt: now,
      updatedAt: now,
    );
  }
}

// Extension methods for convenience
extension ShoppingStoreModelX on ShoppingStoreModel {
  // Get full address string
  String get fullAddress {
    final parts = [address, city, state, zipCode, country]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  // Check if store has location info
  bool get hasLocationInfo => address != null || city != null;

  // Check if store has contact info
  bool get hasContactInfo => phoneNumber != null || website != null;

  // Get display name (chain name if available, otherwise store name)
  String get displayName => chainName ?? name;

  // Check if store is shared with family
  bool get isSharedWithFamily => familyId != null || sharedWith.isNotEmpty;

  // Check if user can edit this store
  bool canEdit(String userId) {
    return createdBy == userId || sharedWith.contains(userId);
  }

  // Get operating hours for a specific day
  String? getOperatingHours(String day) {
    return operatingHours[day.toLowerCase()];
  }

  // Check if store is open on a specific day
  bool isOpenOn(String day) {
    final hours = getOperatingHours(day);
    return hours != null && hours.toLowerCase() != 'closed';
  }

  // Get aisle for a specific item category
  String? getAisleFor(String category) {
    return aisleMapping[category.toLowerCase()];
  }

  // Update visit statistics
  ShoppingStoreModel updateVisitStats({
    double? amountSpent,
  }) {
    final newTotalVisits = totalVisits + 1;
    final newAverageSpent = amountSpent != null
        ? ((averageSpentPerVisit * totalVisits) + amountSpent) / newTotalVisits
        : averageSpentPerVisit;

    return copyWith(
      totalVisits: newTotalVisits,
      lastVisited: DateTime.now(),
      averageSpentPerVisit: newAverageSpent,
      updatedAt: DateTime.now(),
    );
  }

  // Add aisle mapping
  ShoppingStoreModel addAisleMapping(String category, String aisle) {
    final updatedMapping = <String, String>{...aisleMapping};
    updatedMapping[category.toLowerCase()] = aisle;
    return copyWith(
      aisleMapping: updatedMapping,
      updatedAt: DateTime.now(),
    );
  }

  // Remove aisle mapping
  ShoppingStoreModel removeAisleMapping(String category) {
    final updatedMapping = <String, String>{...aisleMapping};
    updatedMapping.remove(category.toLowerCase());
    return copyWith(
      aisleMapping: updatedMapping,
      updatedAt: DateTime.now(),
    );
  }

  // Update operating hours
  ShoppingStoreModel updateOperatingHours(String day, String hours) {
    final updatedHours = <String, String>{...operatingHours};
    updatedHours[day.toLowerCase()] = hours;
    return copyWith(
      operatingHours: updatedHours,
      updatedAt: DateTime.now(),
    );
  }

  // Share with family members
  ShoppingStoreModel shareWith(List<String> userIds) {
    final updatedSharedWith = <String>{...sharedWith, ...userIds}.toList();
    return copyWith(
      sharedWith: updatedSharedWith,
      updatedAt: DateTime.now(),
    );
  }

  // Remove sharing with specific users
  ShoppingStoreModel unshareWith(List<String> userIds) {
    final updatedSharedWith = sharedWith.where((id) => !userIds.contains(id)).toList();
    return copyWith(
      sharedWith: updatedSharedWith,
      updatedAt: DateTime.now(),
    );
  }

  // Check if store supports specific features
  bool get supportsAnyOnlineFeatures => 
      supportsOnlineOrders || supportsCurbsidePickup || supportsDelivery;

  // Get feature list
  List<String> get supportedFeatures {
    final features = <String>[];
    if (allowsPriceTracking) features.add('Price Tracking');
    if (supportsOnlineOrders) features.add('Online Orders');
    if (supportsCurbsidePickup) features.add('Curbside Pickup');
    if (supportsDelivery) features.add('Delivery');
    return features;
  }

  // Calculate distance from user location (if coordinates are available in metadata)
  double? distanceFromUser(double userLat, double userLng) {
    final storeLat = metadata['latitude'] as double?;
    final storeLng = metadata['longitude'] as double?;
    
    if (storeLat == null || storeLng == null) return null;
    
    // Simple distance calculation (Haversine formula would be more accurate)
    final latDiff = (userLat - storeLat).abs();
    final lngDiff = (userLng - storeLng).abs();
    return (latDiff * latDiff + lngDiff * lngDiff) * 69; // Rough miles conversion
  }
}
