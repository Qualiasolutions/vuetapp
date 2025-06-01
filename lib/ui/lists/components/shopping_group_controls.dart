import 'package:flutter/material.dart';

enum ShoppingGroupMode { none, store, category }

class ShoppingGroupControls extends StatelessWidget {
  final ShoppingGroupMode currentMode;
  final ValueChanged<ShoppingGroupMode> onModeChanged;

  const ShoppingGroupControls({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Group by Store Button
          _buildGroupButton(
            context: context,
            icon: Icons.store,
            label: 'Group by store',
            isActive: currentMode == ShoppingGroupMode.store,
            onPressed: () => onModeChanged(
              currentMode == ShoppingGroupMode.store 
                  ? ShoppingGroupMode.none 
                  : ShoppingGroupMode.store
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Group by Category Button
          _buildGroupButton(
            context: context,
            icon: Icons.category,
            label: 'Group by category',
            isActive: currentMode == ShoppingGroupMode.category,
            onPressed: () => onModeChanged(
              currentMode == ShoppingGroupMode.category 
                  ? ShoppingGroupMode.none 
                  : ShoppingGroupMode.category
            ),
          ),
          
          const Spacer(),
          
          // View Mode Toggle
          _buildViewModeButton(context),
        ],
      ),
    );
  }

  Widget _buildGroupButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return Material(
      color: isActive 
          ? theme.colorScheme.primary
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: isActive ? 2 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isActive ? null : Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive 
                    ? theme.colorScheme.onPrimary 
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isActive 
                      ? theme.colorScheme.onPrimary 
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopupMenuButton<ViewMode>(
      icon: Icon(
        Icons.view_agenda,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      onSelected: (ViewMode mode) {
        // Handle view mode change
        // For now, this is just a placeholder
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ViewMode.list,
          child: Row(
            children: [
              Icon(
                Icons.view_list,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              const Text('List view'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ViewMode.grid,
          child: Row(
            children: [
              Icon(
                Icons.grid_view,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              const Text('Grid view'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ViewMode.compact,
          child: Row(
            children: [
              Icon(
                Icons.view_compact,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              const Text('Compact view'),
            ],
          ),
        ),
      ],
    );
  }
}

enum ViewMode { list, grid, compact } 