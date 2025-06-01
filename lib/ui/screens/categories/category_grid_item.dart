import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/ui/theme/app_theme.dart'; // Assuming AppTheme is used for colors
import 'package:go_router/go_router.dart'; // Import go_router

class CategoryGridItem extends ConsumerWidget {
  final String groupName;
  final List<TaskCategoryModel> categoryGroup;

  const CategoryGridItem({
    super.key,
    required this.groupName,
    required this.categoryGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(AppTheme.appThemeProvider);

    // TODO: Implement image background similar to React if assets are available
    // For now, use a colored card

    return Card(
      color: theme.colorScheme.surfaceContainerHighest, // Use theme color
      child: InkWell(
        onTap: () {
          if (categoryGroup.length == 1) {
            // Navigate to CategoryList with categoryGroup[0].id
            context.go('/categories/${categoryGroup[0].id}');
          } else {
            // Navigate to SubCategoryList with categoryGroup.map((cat) => cat.id).toList()
            // Note: go_router might need a custom type or query parameters for list of IDs
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on $groupName group with IDs: ${categoryGroup.map((cat) => cat.id).join(', ')}')),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              groupName, // Use group name for now, will use translated name later
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface, // Use theme color
                fontWeight: FontWeight.bold, // Match React bold text
                fontSize: 13, // Match React font size
              ),
            ),
          ),
        ),
      ),
    );
  }
}
