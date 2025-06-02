import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/categories/categories_grid.dart';
import 'package:vuet_app/ui/screens/categories/professional_categories_list.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> 
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool _isProfessionalMode = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Refresh data when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to foreground
      _refreshData();
    }
  }

  void _refreshData() {
    // Invalidate the relevant providers to refresh data
    if (_isProfessionalMode) {
      ref.invalidate(professionalCategoriesProvider);
      ref.invalidate(uncategorisedEntitiesCountProvider);
    } else {
      ref.invalidate(personalCategoriesProvider);
    }
  }
  
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search categories...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  // Trigger search on text change
                  setState(() {});
                },
              )
            : const Text('Categories'),
        actions: [
          // Search icon/button
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Cancel Search' : 'Search Categories',
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Categories',
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle for Personal/Professional mode
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Personal',
                  style: TextStyle(
                    fontWeight: !_isProfessionalMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Switch(
                  value: _isProfessionalMode,
                  onChanged: (value) {
                    setState(() {
                      _isProfessionalMode = value;
                    });
                    // Refresh data when switching modes
                    _refreshData();
                  },
                ),
                Text(
                  'Professional',
                  style: TextStyle(
                    fontWeight: _isProfessionalMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          // Display either CategoriesGrid or ProfessionalCategoriesList
          Expanded(
            child: _isProfessionalMode
                ? ProfessionalCategoriesList(searchQuery: _searchController.text)
                : CategoriesGrid(searchQuery: _searchController.text),
          ),
        ],
      ),
    );
  }
}
