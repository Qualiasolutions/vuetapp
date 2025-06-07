import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:vuet_app/ui/screens/categories/categories_screen.dart'; // No longer needed
import 'package:vuet_app/ui/screens/categories/categories_grid.dart'; // Use CategoriesGrid
import 'package:vuet_app/ui/screens/calendar/calendar_screen.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';
// import 'package:vuet_app/ui/navigation/timeblock_navigator.dart'; // Removed TimeblockNavigator

/// Provider for the current bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

/// Bottom navigation bar with corresponding screens
class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // Ensure currentIndex is within the new valid range
    final adjustedCurrentIndex = currentIndex >= 2 ? 2 : currentIndex; // Adjusted for 3 items

    // Listen for tab changes and refresh categories data when categories tab is selected
    ref.listen(bottomNavIndexProvider, (previous, next) {
      if (next == 1) { // Categories tab index
        // Refresh categories data when tab becomes active
        Future.microtask(() {
          ref.invalidate(personalCategoryDisplayGroupsProvider);
          ref.invalidate(professionalCategoriesProvider);
          ref.invalidate(uncategorisedEntitiesCountProvider);
        });
      }
    });

    // TODO: Replace with actual providers and logic
    // final personalCategoriesCount = ref.watch(personalCategoriesProvider.select((data) => data.value?.length ?? 0));
    // final professionalCategoriesCount = ref.watch(professionalCategoriesProvider.select((data) => data.value?.length ?? 0));
    // final uncategorisedCount = ref.watch(uncategorisedEntitiesCountProvider.select((data) => data.value ?? 0));

    // Example: Fetch categories count (replace with actual logic if needed)
    // final categoriesCount = ref.watch(categoriesCountProvider);

    return Scaffold(
      body: IndexedStack(
        index: adjustedCurrentIndex, // Use adjusted index
        children: const [
          Placeholder(
            child: Center(child: Text('Dashboard - Coming Soon!')),
          ),
          CategoriesGrid(), // Changed from CategoriesScreen
          // RedesignedListsScreen removed
          CalendarScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: adjustedCurrentIndex, // Use adjusted index
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => ref.read(bottomNavIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category), // Use a category icon
            label: 'Categories', // Update label to Categories
          ),
          // Lists item removed
          // Timeblocks item removed
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
