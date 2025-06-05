import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/utils/logger.dart';

class PetsCategoryScreen extends ConsumerWidget {
  const PetsCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your pets and their care',
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
                childAspectRatio: 1.1,
                children: [
                  _buildSubcategoryCard(
                    context,
                    title: 'My Pets',
                    description: 'Pet profiles and information',
                    icon: Icons.pets,
                    color: Colors.orange,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.pet, EntitySubtype.petBirthday],
                      title: 'My Pets',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Feeding Schedule',
                    description: 'Pet feeding routines and schedules',
                    icon: Icons.restaurant,
                    color: Colors.green,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'PETS__FEEDING',
                      title: 'Feeding Schedule',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Exercise',
                    description: 'Pet exercise and activity tracking',
                    icon: Icons.directions_run,
                    color: Colors.blue,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'PETS__EXERCISE',
                      title: 'Exercise',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Grooming',
                    description: 'Cleaning and grooming schedules',
                    icon: Icons.content_cut,
                    color: Colors.purple,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'PETS__GROOMING',
                      title: 'Grooming',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Health',
                    description: 'Pet health records and vet visits',
                    icon: Icons.medical_services,
                    color: Colors.red,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'PETS__HEALTH',
                      title: 'Health',
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
    log('Navigating to pets subcategory: $title', name: 'PetsCategoryScreen');
    
    // Navigate to EntityList for entity-based subcategories
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '1', // Pets category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Pets',
          screenTitle: title,
          appCategoryId: 1, // Pets category ID from app_categories.dart
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
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tag screen for $title ($tagName) - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
