import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/lists/redesigned_lists_screen.dart';
import 'package:vuet_app/ui/screens/categories/categories_screen.dart';
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
    final adjustedCurrentIndex = currentIndex >= 3 ? 3 : currentIndex; // Adjusted for 4 items

    // Listen for tab changes and refresh categories data when categories tab is selected
    ref.listen(bottomNavIndexProvider, (previous, next) {
      if (next == 1) { // Categories tab index
        // Refresh categories data when tab becomes active
        Future.microtask(() {
          ref.invalidate(personalCategoriesProvider);
          ref.invalidate(professionalCategoriesProvider);
          ref.invalidate(uncategorisedEntitiesCountProvider);
        });
      }
    });

    return Scaffold(
      body: IndexedStack(
        index: adjustedCurrentIndex, // Use adjusted index
        children: const [
          Placeholder(
            child: Center(child: Text('Dashboard - Coming Soon!')),
          ),
          CategoriesScreen(),
          RedesignedListsScreen(),
          // TimeblockNavigator removed
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
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Lists',
          ),
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
