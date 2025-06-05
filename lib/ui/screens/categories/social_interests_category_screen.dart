import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/entities/entity_list_screen.dart';
import 'package:vuet_app/models/entity_model.dart';

/// Social Interests Category Screen - Modern UI for social and interest-related subcategories
/// 
/// This screen implements the 7 main social interests subcategories:
/// 1. Social Plans - navigates to EntityList with SocialPlan entity types
/// 2. Anniversaries - navigates to EntityList with Anniversary entity types
/// 3. National Holidays - navigates to EntityList with Holiday entity types
/// 4. Events - navigates to EntityList with Event entity types
/// 5. Hobbies - navigates to EntityList with Hobby entity types
/// 6. Social Media - navigates to EntityList with SocialMedia entity types
/// 7. My Social Information - navigates to tag-based information screen
class SocialInterestsCategoryScreen extends ConsumerWidget {
  const SocialInterestsCategoryScreen({super.key});

  void _navigateToEntityList(BuildContext context, {
    required List<EntitySubtype> entityTypes,
    required String title,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityListScreen(
          categoryId: '2', // Social Interests category ID
          subcategoryId: title.toLowerCase().replaceAll(' ', '_'),
          categoryName: 'Social Interests',
          screenTitle: title,
          appCategoryId: 2, // Social Interests app category ID
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Icon with colored background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 11,
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
        title: const Text('Social Interests'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your social life and interests',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Social Plans',
                    description: 'Organize meetings and social activities',
                    icon: Icons.people_outline,
                    color: const Color(0xFF1976D2), // Blue
                    entityTypes: [EntitySubtype.socialPlan],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Anniversaries',
                    description: 'Track important anniversary dates',
                    icon: Icons.cake,
                    color: const Color(0xFFE91E63), // Pink
                    entityTypes: [EntitySubtype.anniversary],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'National Holidays',
                    description: 'Keep track of public holidays',
                    icon: Icons.flag,
                    color: const Color(0xFF4CAF50), // Green
                    entityTypes: [EntitySubtype.holiday],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Events',
                    description: 'Manage special events and occasions',
                    icon: Icons.event,
                    color: const Color(0xFFFF9800), // Orange
                    entityTypes: [EntitySubtype.event],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Hobbies',
                    description: 'Track your hobbies and interests',
                    icon: Icons.sports_basketball,
                    color: const Color(0xFF9C27B0), // Purple
                    entityTypes: [EntitySubtype.hobby],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'Social Media',
                    description: 'Manage social media accounts',
                    icon: Icons.share,
                    color: const Color(0xFF00BCD4), // Cyan
                    entityTypes: [EntitySubtype.socialMedia],
                  ),
                  _buildSubcategoryCard(
                    context: context,
                    title: 'My Social Information',
                    description: 'Personal social details and preferences',
                    icon: Icons.account_circle,
                    color: const Color(0xFF795548), // Brown
                    entityTypes: null,
                    tagName: 'SOCIAL_INTERESTS__INFORMATION__PUBLIC',
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
