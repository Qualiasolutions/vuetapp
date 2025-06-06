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
  final List<int> categoryIds;
  final bool isPremium;
  // final String iconName; // TODO if needed

  const CategoryDisplayGroup({
    required this.displayName,
    required this.categoryIds,
    this.isPremium = false,
    // required this.iconName,
  });
}

// Updated category display groups with new structure
// Family is now ID 1, and Charity & Religion replaces References
const List<CategoryDisplayGroup> categoryDisplayGroups = [
  CategoryDisplayGroup(displayName: "Family", categoryIds: [1]),
  CategoryDisplayGroup(displayName: "Pets", categoryIds: [2]),
  CategoryDisplayGroup(displayName: "Social Interests", categoryIds: [3]),
  CategoryDisplayGroup(displayName: "Education & Career", categoryIds: [4, 5]),
  CategoryDisplayGroup(displayName: "Travel", categoryIds: [6]),
  CategoryDisplayGroup(displayName: "Health & Beauty", categoryIds: [7], isPremium: true),
  CategoryDisplayGroup(displayName: "Home & Garden", categoryIds: [8, 9, 10, 11]),
  CategoryDisplayGroup(displayName: "Finance", categoryIds: [12]),
  CategoryDisplayGroup(displayName: "Transport", categoryIds: [13]),
  CategoryDisplayGroup(displayName: "Charity & Religion", categoryIds: [14], isPremium: true),
];

// Function to get the group for a category ID
CategoryDisplayGroup? getCategoryDisplayGroup(int categoryId) {
  for (var group in categoryDisplayGroups) {
    if (group.categoryIds.contains(categoryId)) {
      return group;
    }
  }
  return null;
}

// Function to get all categories within a display group name
List<AppCategory> getCategoriesInGroup(String displayGroupName) {
  final group = categoryDisplayGroups.firstWhere((g) => g.displayName == displayGroupName, orElse: () => const CategoryDisplayGroup(displayName: '', categoryIds: []));
  return appCategories.where((cat) => group.categoryIds.contains(cat.id)).toList();
}
