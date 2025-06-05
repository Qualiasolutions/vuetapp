import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/utils/logger.dart';

class FinanceCategoryScreen extends ConsumerWidget {
  const FinanceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your finances and financial planning',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildSubcategoryCard(
                    context,
                    title: 'My Finances',
                    description: 'Accounts, budgets, and financial records',
                    icon: Icons.account_balance_wallet,
                    color: Colors.green,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.finance],
                      title: 'My Finances',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'My Finance Information',
                    description: 'Financial documents and references',
                    icon: Icons.info_outline,
                    color: Colors.teal,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'FINANCE__INFORMATION__PUBLIC',
                      title: 'My Finance Information',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEntityList(
    BuildContext context, {
    required List<EntitySubtype> entityTypes,
    required String title,
  }) {
    log('Navigating to finance subcategory: $title', name: 'FinanceCategoryScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '11', // Finance category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Finance',
          screenTitle: title,
          appCategoryId: 11, // Finance category ID from app_categories.dart
          defaultEntityType: entityTypes.first,
        ),
      ),
    );
  }

  void _navigateToTagScreen(
    BuildContext context, {
    required String tagName,
    required String title,
  }) {
    // TODO: Implement tag screen navigation when TagScreen is available
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tag screen for $title ($tagName) - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
