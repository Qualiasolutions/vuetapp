import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/models/entity_model.dart';

/// Career Category Screen - Modern UI for career-related subcategories
/// 
/// This screen implements the 4 main career subcategories:
/// 1. Employees - navigates to EntityList with Colleague entity types
/// 2. Days Off - navigates to EntityList with Work entity types (for tracking time off)
/// 3. Career Goal - navigates to EntityList with Work entity types (for career planning)
/// 4. My Career Information - navigates to tag-based information screen
class CareerCategoryScreen extends ConsumerWidget {
  const CareerCategoryScreen({super.key});

  void _navigateToEntityList(BuildContext context, {
    required List<EntitySubtype> entityTypes,
    required String title,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '4', // Career category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Career',
          screenTitle: title,
          appCategoryId: 4, // Career app category ID
          defaultEntityType: entityTypes.first,
        ),
      ),
    );
  }

  void _navigateToTagScreen(BuildContext context, {
    required String tagName,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tag screen for $title ($tagName) - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSubcategoryCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<EntitySubtype>? entityTypes,
    String? tagName,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (tagName != null) {
            _navigateToTagScreen(context, tagName: tagName, title: title);
          } else if (entityTypes != null) {
            _navigateToEntityList(context, entityTypes: entityTypes, title: title);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Icon with colored background
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your professional life',
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
                childAspectRatio: 1.0,
                children: [
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Employees',
                    description: 'Manage colleagues and team members',
                    icon: Icons.people,
                    color: const Color(0xFF1976D2), // Blue
                    entityTypes: [EntitySubtype.colleague],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Days Off',
                    description: 'Track vacation and leave time',
                    icon: Icons.beach_access,
                    color: const Color(0xFF4CAF50), // Green
                    entityTypes: [EntitySubtype.work], // Using work entity for time off tracking
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Career Goal',
                    description: 'Set and track career objectives',
                    icon: Icons.trending_up,
                    color: const Color(0xFFFF9800), // Orange
                    entityTypes: [EntitySubtype.work], // Using work entity for career goals
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'My Career Information',
                    description: 'Personal career details and achievements',
                    icon: Icons.account_circle,
                    color: const Color(0xFF9C27B0), // Purple
                    entityTypes: null,
                    tagName: 'CAREER__INFORMATION__PUBLIC',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
