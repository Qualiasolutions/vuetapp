import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/utils/logger.dart';

class LaundryCategoryScreen extends ConsumerWidget {
  const LaundryCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your laundry schedules and routines',
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
                    title: 'Laundry Plans',
                    description: 'Washing schedules and laundry routines',
                    icon: Icons.local_laundry_service,
                    color: Colors.cyan,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.laundryPlan],
                      title: 'Laundry Plans',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'My Laundry Information',
                    description: 'Laundry documents and care instructions',
                    icon: Icons.info_outline,
                    color: Colors.blueGrey,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'LAUNDRY__INFORMATION__PUBLIC',
                      title: 'My Laundry Information',
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
    log('Navigating to laundry subcategory: $title', name: 'LaundryCategoryScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '10', // Laundry category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Laundry',
          screenTitle: title,
          appCategoryId: 10, // Laundry category ID from app_categories.dart
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
