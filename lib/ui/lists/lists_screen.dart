import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/lists/screens/planning_lists_screen.dart';
import 'package:vuet_app/ui/lists/screens/shopping_lists_screen.dart';
import 'package:vuet_app/ui/navigation/app_drawer.dart';

/// Provider for the current Lists tab index
final listsTabIndexProvider = StateProvider<int>((ref) => 0);

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(listsTabIndexProvider);

    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lists'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search functionality
              },
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              ref.read(listsTabIndexProvider.notifier).state = index;
            },
            tabs: const [
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Planning'),
                    SizedBox(height: 4),
                    Text(
                      'For organizing tasks and projects',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Shopping'),
                    SizedBox(height: 4),
                    Text(
                      'For tracking items to purchase',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: Colors.white,
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            PlanningListsScreen(),
            ShoppingListsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (tabIndex == 0) {
              // Navigate to PlanningListsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanningListsScreen()),
              );
            } else {
              // Navigate to ShoppingListsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingListsScreen()),
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }


}
