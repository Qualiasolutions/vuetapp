import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/models/entity_model.dart';

/// Education Category Screen - Modern UI for education-related subcategories
/// 
/// This screen implements the 5 main education subcategories:
/// 1. Students - navigates to EntityList with Student entity types
/// 2. Schools - navigates to EntityList with School entity types  
/// 3. School Terms - navigates to EntityList with SchoolTerm entity types
/// 4. Academic Plans - navigates to EntityList with AcademicPlan entity types
/// 5. Extracurricular Plans - navigates to EntityList with ExtracurricularPlan entity types
class EducationCategoryScreen extends ConsumerWidget {
  const EducationCategoryScreen({super.key});

  void _navigateToEntityList(BuildContext context, {
    required List<EntitySubtype> entityTypes,
    required String title,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '3', // Education category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Education',
          screenTitle: title,
          appCategoryId: 3, // Education app category ID
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
    required List<EntitySubtype> entityTypes,
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
          } else {
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
        title: const Text('Education'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your educational journey',
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
                childAspectRatio: 0.9,
                children: [
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Students',
                    description: 'Manage student information and profiles',
                    icon: Icons.school,
                    color: const Color(0xFF1976D2), // Blue
                    entityTypes: [EntitySubtype.student],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Schools',
                    description: 'Track educational institutions',
                    icon: Icons.location_city,
                    color: const Color(0xFF388E3C), // Green
                    entityTypes: [EntitySubtype.school],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'School Terms',
                    description: 'Organize academic terms and semesters',
                    icon: Icons.calendar_today,
                    color: const Color(0xFFFF9800), // Orange
                    entityTypes: [EntitySubtype.subject], // Using subject as closest match
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Academic Plans',
                    description: 'Plan your academic goals and progress',
                    icon: Icons.assignment,
                    color: const Color(0xFF9C27B0), // Purple
                    entityTypes: [EntitySubtype.academicPlan],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Extracurricular Plans',
                    description: 'Manage activities and clubs',
                    icon: Icons.sports_soccer,
                    color: const Color(0xFFE91E63), // Pink
                    entityTypes: [EntitySubtype.extracurricularPlan],
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
