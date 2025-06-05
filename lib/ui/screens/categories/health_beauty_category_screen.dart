import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/utils/logger.dart';

class HealthBeautyCategoryScreen extends ConsumerWidget {
  const HealthBeautyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Beauty'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your health and beauty information',
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
                    title: 'Patients',
                    description: 'Medical records and patient information',
                    icon: Icons.person_outline,
                    color: Colors.blue,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.patient],
                      title: 'Patients',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Appointments',
                    description: 'Medical and beauty appointments',
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.appointment],
                      title: 'Appointments',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'Health Goals',
                    description: 'Fitness and wellness objectives',
                    icon: Icons.flag_outlined,
                    color: Colors.orange,
                    onTap: () => _navigateToEntityList(
                      context,
                      entityTypes: [EntitySubtype.healthGoal],
                      title: 'Health Goals',
                    ),
                  ),
                  _buildSubcategoryCard(
                    context,
                    title: 'My Health Information',
                    description: 'Personal health documents & references',
                    icon: Icons.info_outline,
                    color: Colors.purple,
                    onTap: () => _navigateToTagScreen(
                      context,
                      tagName: 'HEALTH_BEAUTY__INFORMATION__PUBLIC',
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
    log('Navigating to health & beauty subcategory: $title', name: 'HealthBeautyCategoryScreen');
    
    // Navigate to EntityList for entity-based subcategories
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '6', // Health & Beauty category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Health & Beauty',
          screenTitle: title,
          appCategoryId: 6, // Health & Beauty category ID from app_categories.dart
          defaultEntityType: entityTypes.first,
        ),
      ),
    );
  }

  void _navigateToTagScreen(
    BuildContext context, {
    required String tagName,
  }) {
    // TODO: Implement tag screen navigation when TagScreen is available
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tag screen for $tagName - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
