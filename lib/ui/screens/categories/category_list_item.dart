import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/ui/theme/app_theme.dart'; // Assuming AppTheme is used for colors
import 'package:go_router/go_router.dart'; // Import go_router
// Assuming a utility for hex color conversion

class CategoryListItem extends ConsumerWidget {
  final TaskCategoryModel category;
  final bool isProfessional; // To differentiate navigation/actions
  final VoidCallback? onEdit; // Callback for edit action
  final VoidCallback? onDelete; // Callback for delete action

  const CategoryListItem({
    super.key,
    required this.category,
    this.isProfessional = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(AppTheme.appThemeProvider);

    // Convert hex color string to Color object
    final categoryColor = ColorUtils.fromHex(category.color);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest, // Use theme color
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor,
          child: category.icon != null
              ? Icon(
                  Icons.category, // Placeholder icon, replace with actual icon logic if needed
                  color: theme.colorScheme.onPrimary, // Use theme color for icon
                )
              : null,
        ),
        title: Text(category.name),
        trailing: isProfessional && (onEdit != null || onDelete != null)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                ],
              )
            : null,
        onTap: () {
          // Navigate to category detail screen
          if (isProfessional) {
            context.go('/professional-categories/${category.id}');
          } else {
            context.go('/categories/${category.id}');
          }
        },
      ),
    );
  }
}

// Assuming a simple ColorUtils class exists or needs to be created
class ColorUtils {
  static Color fromHex(String hexString) {
    final hexCode = hexString.replaceAll('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    } else if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16));
    } else {
      throw FormatException('Invalid hex color string: $hexString');
    }
  }

  /// Convert a Color object to a hex color string (e.g., "#RRGGBB").
  static String toHex(Color color, {bool includeHash = true}) {
    final hex = color.value.toRadixString(16).substring(2); // Remove alpha channel
    return includeHash ? '#$hex' : hex;
  }
}
