import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/config/app_categories.dart'; // Still used for CategoryDisplayGroup class
import 'package:vuet_app/providers/category_providers.dart';
import 'package:vuet_app/utils/logger.dart';

// Helper class to define the structure of our target display groups
class _CategoryGroupDefinition {
  final String displayName;
  final String systemName;
  final String iconName;
  final List<String> constituentNames; // EntityCategory.name values
  final int sortOrder;
  final bool? isPremium; // Changed to nullable

  const _CategoryGroupDefinition({
    required this.displayName,
    required this.systemName,
    required this.iconName,
    required this.constituentNames,
    required this.sortOrder,
    this.isPremium, // Removed default, now nullable
  });
}

// Define the 9 target display groups
final List<_CategoryGroupDefinition> _targetDisplayGroups = [
  _CategoryGroupDefinition(displayName: "Family", systemName: "FAMILY", iconName: "family_restroom", constituentNames: ["FAMILY"], sortOrder: 1, isPremium: false),
  _CategoryGroupDefinition(displayName: "Pets", systemName: "PETS", iconName: "pets", constituentNames: ["PETS"], sortOrder: 2, isPremium: false),
  _CategoryGroupDefinition(displayName: "Social Interests", systemName: "SOCIAL_INTERESTS", iconName: "people", constituentNames: ["SOCIAL_INTERESTS"], sortOrder: 3, isPremium: false),
  _CategoryGroupDefinition(displayName: "Education & Career", systemName: "EDUCATION_AND_CAREER", iconName: "school", constituentNames: ["EDUCATION", "CAREER"], sortOrder: 4, isPremium: false),
  _CategoryGroupDefinition(displayName: "Travel", systemName: "TRAVEL", iconName: "flight", constituentNames: ["TRAVEL"], sortOrder: 5, isPremium: false),
  _CategoryGroupDefinition(displayName: "Health & Beauty", systemName: "HEALTH_AND_BEAUTY", iconName: "spa", constituentNames: ["HEALTH_BEAUTY"], sortOrder: 6, isPremium: false), // Example: Health & Beauty could be premium
  _CategoryGroupDefinition(displayName: "Home & Garden", systemName: "HOME_AND_GARDEN", iconName: "home", constituentNames: ["HOME", "GARDEN", "FOOD", "LAUNDRY"], sortOrder: 7, isPremium: false),
  _CategoryGroupDefinition(displayName: "Finance", systemName: "FINANCE", iconName: "account_balance_wallet", constituentNames: ["FINANCE"], sortOrder: 8, isPremium: false),
  _CategoryGroupDefinition(displayName: "Transport", systemName: "TRANSPORT", iconName: "directions_car", constituentNames: ["TRANSPORT"], sortOrder: 9, isPremium: false),
  // Add "Charity & Religion" or "References" here if confirmed and how they map.
  // For now, sticking to the 9 derived from the detailed guide and app_categories.dart TODOs.
];

// Provider for displaying personal categories as defined display groups
final personalCategoryDisplayGroupsProvider = Provider<List<CategoryDisplayGroup>>((ref) {
  final allCategoriesAsyncValue = ref.watch(allEntityCategoriesProvider);

  return allCategoriesAsyncValue.when(
    data: (allFetchedCategories) {
      final categoriesToProcess = allFetchedCategories
          .where((category) => category.isDisplayedOnGrid == true)
          .toList();

      List<CategoryDisplayGroup> resultGroups = [];

      for (final groupDef in _targetDisplayGroups) {
        List<int> currentGroupCategoryIntIds = [];
        List<EntityCategory> matchedCategories = [];

        for (final entityCategory in categoriesToProcess) {
          // EntityCategory.name from DB (e.g., "PETS", "EDUCATION")
          if (groupDef.constituentNames.contains(entityCategory.name.toUpperCase())) {
            if (entityCategory.appCategoryIntId != null) {
              currentGroupCategoryIntIds.add(entityCategory.appCategoryIntId!);
            } else {
              log('Warning: EntityCategory "${entityCategory.name}" (ID: ${entityCategory.id}) has null appCategoryIntId but is part of group "${groupDef.displayName}".', name: 'CategoryProviders');
            }
            matchedCategories.add(entityCategory);
          }
        }

        if (matchedCategories.isNotEmpty) {
          // For iconName and isPremium, we use the group definition's value.
          // If we needed to derive it from EntityCategory (e.g. if any constituent is premium, group is premium),
          // we would iterate over matchedCategories here.
          resultGroups.add(CategoryDisplayGroup(
            displayName: groupDef.displayName,
            systemName: groupDef.systemName,
            categoryIds: currentGroupCategoryIntIds, // These are appCategoryIntId from EntityCategory
            iconName: groupDef.iconName,
            isPremium: groupDef.isPremium,
          ));
        }
      }

      // Sort the final list of display groups by their defined sortOrder
      resultGroups.sort((a, b) {
        final groupDefA = _targetDisplayGroups.firstWhere((def) => def.systemName == a.systemName);
        final groupDefB = _targetDisplayGroups.firstWhere((def) => def.systemName == b.systemName);
        return groupDefA.sortOrder.compareTo(groupDefB.sortOrder);
      });

      return resultGroups;
    },
    loading: () => [], // Return empty list while loading
    error: (error, stackTrace) {
      log('Error fetching categories for personalCategoryDisplayGroupsProvider: $error', name: 'CategoryProviders', error: error, stackTrace: stackTrace);
      return []; // Return empty list on error
    },
  );
});

// Provider for professional categories with StreamProvider for auto-refresh and autoDispose
final professionalCategoriesProvider = StreamProvider.autoDispose<List<EntityCategory>>((ref) async* {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  
  yield await repository.fetchProfessionalCategories();
  
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    try {
      yield await repository.fetchProfessionalCategories();
    } catch (e) {
      continue;
    }
  }
});

// Provider for uncategorised entities count with StreamProvider for auto-refresh and autoDispose
final uncategorisedEntitiesCountProvider = StreamProvider.autoDispose<int>((ref) async* {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  
  yield await repository.fetchUncategorisedEntitiesCount();
  
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    try {
      yield await repository.fetchUncategorisedEntitiesCount();
    } catch (e) {
      continue;
    }
  }
});
