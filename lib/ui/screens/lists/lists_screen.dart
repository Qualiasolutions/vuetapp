import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/lists/screens/planning_lists_screen.dart';
import 'package:vuet_app/ui/lists/screens/shopping_lists_screen.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Planning'),
            Tab(text: 'Shopping'),
            // Tab(text: 'Templates'), // Future placeholder
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PlanningListsScreen(),
          ShoppingListsScreen(),
          // Center(child: Text('List Templates - Coming Soon!')), // Future placeholder
        ],
      ),
    );
  }
}
