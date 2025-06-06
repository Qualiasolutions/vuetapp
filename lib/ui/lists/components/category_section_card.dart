import 'package:flutter/material.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

class CategorySectionCard extends StatelessWidget {
  final ListCategoryModel category;
  final List<ListModel> lists;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final VoidCallback onAddToCategory;

  const CategorySectionCard({
    super.key,
    required this.category,
    required this.lists,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onAddToCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = AppTheme.accent;
    final iconColor = _parseColor(category.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // Category Header
          Material(
            color: theme.colorScheme.surface,
            borderRadius: isExpanded
                ? const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )
                : BorderRadius.circular(16),
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: InkWell(
              onTap: lists.isEmpty ? onAddToCategory : onToggleExpansion,
              borderRadius: isExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )
                  : BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Category Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(category.icon),
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Category Name & Lists Count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (lists.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${lists.length} list${lists.length == 1 ? '' : 's'}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 2),
                            Text(
                              'Tap to add first list',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    AppTheme.secondary.withValues(alpha: 0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Add Button or Expansion Arrow
                    if (lists.isEmpty)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppTheme.secondary,
                          size: 20,
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Add button for existing categories
                          IconButton(
                            onPressed: onAddToCategory,
                            icon: Icon(
                              Icons.add,
                              color: AppTheme.secondary,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  AppTheme.secondary.withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Expansion arrow
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Lists Section
          if (isExpanded && lists.isNotEmpty)
            Material(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    // Divider
                    Container(
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      margin: const EdgeInsets.only(bottom: 12),
                    ),

                    // Lists
                    ...lists.map(
                        (list) => _buildListItem(context, list, categoryColor)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, ListModel list, Color categoryColor) {
    final theme = Theme.of(context);
    final progressPercent = list.completionPercentage / 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        child: InkWell(
          onTap: () {
            // Navigate to list detail
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // List indicator/icon
                Container(
                  width: 8,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),

                // List content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Progress or description
                      if (list.totalItems > 0) ...[
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progressPercent,
                                backgroundColor: AppTheme.secondary.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation(AppTheme.secondary),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${list.completedItems}/${list.totalItems}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ] else if (list.description?.isNotEmpty == true) ...[
                        Text(
                          list.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        Text(
                          'Empty list',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Edit list
                      },
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 18,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      style: IconButton.styleFrom(
                        foregroundColor:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Delete list
                      },
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 18,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      style: IconButton.styleFrom(
                        foregroundColor:
                            theme.colorScheme.error.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse('0xFF${colorString.substring(1)}'));
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets;
      case 'group':
        return Icons.group;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'flight':
        return Icons.flight;
      case 'spa':
        return Icons.spa;
      case 'home':
        return Icons.home;
      case 'yard':
        return Icons.yard;
      case 'restaurant':
        return Icons.restaurant;
      case 'checkroom':
        return Icons.checkroom;
      default:
        return Icons.folder_outlined;
    }
  }
}
