/// Defines the main application categories based on the legacy system.
/// Source: memory-bank/Categories-Entities-Tasks-Connection/Categories-Entities-Tasks-Connection.md
library;

class AppCategory {
  final int id;
  final String name; // e.g., PETS
  final String readableName; // e.g., Pets
  // TODO: Add icon, isPremium, groupedTileName if needed later based on serializer/UI requirements

  const AppCategory({
    required this.id,
    required this.name,
    required this.readableName,
  });
}

/* // TODO: Remove these static lists and helpers once fully transitioned and confirmed not used elsewhere.
const List<AppCategory> appCategories = [
  AppCategory(id: 1, name: "FAMILY", readableName: "Family"),
  AppCategory(id: 2, name: "PETS", readableName: "Pets"),
  AppCategory(id: 3, name: "SOCIAL_INTERESTS", readableName: "Social Interests"),
  AppCategory(id: 4, name: "EDUCATION", readableName: "Education"),
  AppCategory(id: 5, name: "CAREER", readableName: "Career"),
  AppCategory(id: 6, name: "TRAVEL", readableName: "Travel"),
  AppCategory(id: 7, name: "HEALTH_BEAUTY", readableName: "Health & Beauty"),
  AppCategory(id: 8, name: "HOME", readableName: "Home"),
  AppCategory(id: 9, name: "GARDEN", readableName: "Garden"),
  AppCategory(id: 10, name: "FOOD", readableName: "Food"),
  AppCategory(id: 11, name: "LAUNDRY", readableName: "Laundry"),
  AppCategory(id: 12, name: "FINANCE", readableName: "Finance"),
  AppCategory(id: 13, name: "TRANSPORT", readableName: "Transport"),
  AppCategory(id: 14, name: "CHARITY_RELIGION", readableName: "Charity & Religion"),
];

// Helper function to get a category by its ID
AppCategory? getAppCategoryById(int id) {
  try {
    return appCategories.firstWhere((category) => category.id == id);
  } catch (e) {
    return null; // Not found
  }
}
*/

// TODO: Define grouped tiles for display as per the document:
// - PETS
// - SOCIAL_INTERESTS
// - EDUCATION_CAREER (combines Education ID:3 and Career ID:4)
// - TRAVEL
// - HEALTH_BEAUTY
// - HOME_GARDEN (combines Home ID:7, Garden ID:8, Food ID:9, and Laundry ID:10)
// - FINANCE
// - TRANSPORT
// - REFERENCES (special premium feature - not a standard category ID from 1-12)

// Example for grouped tiles (can be expanded)
class CategoryDisplayGroup {
  final String displayName;
  final String systemName; // Added to carry EntityCategory.name
  final List<int> categoryIds; // Will typically be a single appCategoryIntId from EntityCategory
  final bool? isPremium; // Made nullable
  final String? iconName; // Added to carry icon name from EntityCategory

  const CategoryDisplayGroup({
    required this.displayName,
    required this.systemName, // Added to constructor
    required this.categoryIds,
    this.isPremium, // Made nullable, default removed
    this.iconName, // Added to constructor
  });
}

// Updated category display groups with new structure
// Family is now ID 1, and Charity & Religion replaces References
// This static list will effectively be replaced by the dynamic provider,
// but the class definition is still used.
// This static list is illustrative and will be superseded by dynamic data.
// For systemName, we'd use the actual system names from the DB like "PETS", "SOCIAL_INTERESTS" etc.
/* // TODO: Remove these static lists and helpers once fully transitioned and confirmed not used elsewhere.
const List<CategoryDisplayGroup> categoryDisplayGroups = [
  CategoryDisplayGroup(displayName: "Family", systemName: "FAMILY", categoryIds: [1], iconName: "family_restroom"),
  CategoryDisplayGroup(displayName: "Pets", systemName: "PETS", categoryIds: [2], iconName: "pets"),
  CategoryDisplayGroup(displayName: "Social Interests", systemName: "SOCIAL_INTERESTS", categoryIds: [3], iconName: "people"),
  CategoryDisplayGroup(displayName: "Education & Career", systemName: "EDUCATION_CAREER", categoryIds: [4, 5], iconName: "school"), // Example combined system name
  CategoryDisplayGroup(displayName: "Travel", systemName: "TRAVEL", categoryIds: [6], iconName: "flight", isPremium: false),
  CategoryDisplayGroup(displayName: "Health & Beauty", systemName: "HEALTH_BEAUTY", categoryIds: [7], isPremium: true, iconName: "spa"),
  CategoryDisplayGroup(displayName: "Home & Garden", systemName: "HOME_GARDEN", categoryIds: [8, 9, 10, 11], iconName: "home", isPremium: false), // Example combined system name
  CategoryDisplayGroup(displayName: "Finance", systemName: "FINANCE", categoryIds: [12], iconName: "account_balance_wallet", isPremium: false),
  CategoryDisplayGroup(displayName: "Transport", systemName: "TRANSPORT", categoryIds: [13], iconName: "directions_car", isPremium: false),
  CategoryDisplayGroup(displayName: "Charity & Religion", systemName: "CHARITY_RELIGION", categoryIds: [14], isPremium: true, iconName: "church"),
];

// Function to get the group for a category ID
// This will be less relevant with dynamic data but kept for now if used elsewhere.
CategoryDisplayGroup? getCategoryDisplayGroup(int categoryId) {
  for (var group in categoryDisplayGroups) {
    if (group.categoryIds.contains(categoryId)) {
      return group;
    }
  }
  return null;
}

// Function to get all categories within a display group name
// This will be less relevant with dynamic data.
List<AppCategory> getCategoriesInGroup(String displayGroupName) {
  final group = categoryDisplayGroups.firstWhere((g) => g.displayName == displayGroupName, orElse: () => const CategoryDisplayGroup(displayName: '', systemName: '', categoryIds: []));
  return appCategories.where((cat) => group.categoryIds.contains(cat.id)).toList();
}
*/
