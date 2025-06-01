import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

// Provider for personal categories
final personalCategoriesProvider = FutureProvider<List<EntityCategoryModel>>((ref) async {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  return repository.fetchPersonalCategories();
});

class ModernizedCategoriesScreen extends ConsumerStatefulWidget {
  const ModernizedCategoriesScreen({super.key});

  @override
  ConsumerState<ModernizedCategoriesScreen> createState() => _ModernizedCategoriesScreenState();
}

class _ModernizedCategoriesScreenState extends ConsumerState<ModernizedCategoriesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(personalCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: categoriesAsyncValue.when(
          data: (categories) => _buildCategoriesGrid(categories),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<EntityCategoryModel> categories) {
    // Filter out "Routines" category
    final filteredCategories = categories.where((category) =>
      category.name.toLowerCase() != 'routines').toList();
    
    // Add default categories if none exist in the database
    final defaultCategories = [
      EntityCategoryModel(
        id: 'PETS',
        name: 'Pets',
        color: '#E49F30',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'SOCIAL_INTERESTS',
        name: 'Social & Interests',
        color: '#9C27B0',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'EDUCATION',
        name: 'Education',
        color: '#2196F3',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'CAREER',
        name: 'Career',
        color: '#FF9800',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'TRAVEL',
        name: 'Travel',
        color: '#00BCD4',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'HEALTH_BEAUTY',
        name: 'Health & Beauty',
        color: '#4CAF50',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'HOME',
        name: 'Home',
        color: '#1A6E68',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'GARDEN',
        name: 'Garden',
        color: '#4CAF50',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'FOOD',
        name: 'Food',
        color: '#FF9800',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'LAUNDRY',
        name: 'Laundry',
        color: '#607D8B',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'FINANCE',
        name: 'Finance',
        color: '#795548',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'TRANSPORT',
        name: 'Transport',
        color: '#607D8B',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      EntityCategoryModel(
        id: 'CHARITY_RELIGION',
        name: 'Charity and Religion',
        color: '#FF5722',
        ownerId: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    // Use database categories if available, otherwise use default ones
    final allCategories = filteredCategories.isNotEmpty 
        ? [...filteredCategories] 
        : [...defaultCategories];

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCategoryCard(allCategories[index], index),
              childCount: allCategories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(EntityCategoryModel category, int index) {
    final isReferences = category.id == 'CHARITY_RELIGION';
    final categoryColor = Color(int.parse(category.color?.substring(1, 7) ?? '808080', radix: 16) + 0xFF000000);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: ModernComponents.modernCard(
        margin: EdgeInsets.zero,
        onTap: () => _navigateToCategory(category, isReferences),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor.withAlpha((0.8 * 255).round()),
                      categoryColor.withAlpha((0.6 * 255).round()),
                    ],
                  ),
                ),
              ),
              
              // Pattern overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white.withAlpha((0.1 * 255).round()),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Category icon and name
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCategoryIcon(category.name),
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Premium badge for References
              if (isReferences)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              // Hover effect
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _navigateToCategory(category, isReferences),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withAlpha((0.2 * 255).round()),
                  highlightColor: Colors.white.withAlpha((0.1 * 255).round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => ModernComponents.loadingSkeleton(
          height: 150,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: ModernComponents.modernCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ModernComponents.modernButton(
              text: 'Retry',
              onPressed: () => ref.invalidate(personalCategoriesProvider),
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'pets':
        return Icons.pets;
      case 'vehicles':
      case 'cars':
        return Icons.directions_car;
      case 'home & garden':
      case 'home':
        return Icons.home;
      case 'health & fitness':
      case 'health':
        return Icons.favorite;
      case 'travel':
        return Icons.flight;
      case 'work':
      case 'business':
        return Icons.work;
      case 'finance':
        return Icons.account_balance;
      case 'education':
        return Icons.school;
      case 'entertainment':
        return Icons.movie;
      case 'food & drink':
      case 'food':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'references':
        return Icons.bookmark;
      case 'charity and religion':
      case 'charity':
        return Icons.volunteer_activism;
      case 'holidays':
        return Icons.beach_access;
      default:
        return Icons.category;
    }
  }

  void _navigateToCategory(EntityCategoryModel category, bool isReferences) {
    // All categories including Charity & Religion should navigate to subcategory screen
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SubCategoryScreen.fromCategoryId(
              parentCategoryName: category.name,
              parentCategoryId: category.id.toUpperCase(),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }
}
