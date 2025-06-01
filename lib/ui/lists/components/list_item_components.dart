import 'package:flutter/material.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/utils/date_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import the main repository file, not the .g.dart file directly
import 'package:vuet_app/repositories/supabase_entity_repository.dart'; 
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/utils/logger.dart'; // Added logger

// Provider that fetches category name by ID
// TODO: Replace with proper category repository when implemented
// This provider's logic is flawed if categoryId was a String UUID, as listEntities now takes int appCategoryId.
// For now, changing parameter to int to match repository, but this provider needs review.
final categoryByIdProvider =
    FutureProvider.family<String?, int>((ref, appCategoryId) async { // Changed String categoryId to int appCategoryId
  try {
    final entityRepository = ref.watch(supabaseEntityRepositoryProvider);
    final authService = ref.watch(authServiceProvider);
    final userId = authService.currentUser?.id;
    
    if (userId == null) {
        log("User not authenticated, cannot fetch entities by appCategoryId for categoryByIdProvider", name: "categoryByIdProvider");
        return null; 
    }

    // listEntities now expects appCategoryId as int?
    final entities =
        await entityRepository.listEntities(userId: userId, appCategoryId: appCategoryId);

    if (entities.isNotEmpty) {
      // This logic is still placeholder. It should fetch category name from CategoryRepository using appCategoryId.
      return "Category (ID: $appCategoryId)"; // TODO: Replace with actual category name from category table
    }
    return null;
  } catch (e, s) { // Added stacktrace
    log("Error in categoryByIdProvider (appCategoryId: $appCategoryId): $e", name: "categoryByIdProvider", error: e, stackTrace: s);
    return null;
  }
});

/// Widget for showing an empty state when a list has no items
class EmptyListState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyListState({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Input field for creating new list items
class CreateItemField extends StatefulWidget {
  final String hintText;
  final Function(String value) onSubmit;

  const CreateItemField({
    super.key,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  State<CreateItemField> createState() => _CreateItemFieldState();
}

class _CreateItemFieldState extends State<CreateItemField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: _submitValue,
        ),
      ),
      onSubmitted: (_) => _submitValue(),
    );
  }

  void _submitValue() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      widget.onSubmit(value);
      _controller.clear();
    }
  }
}

/// Card for displaying a planning list in the lists overview
class PlanningListCard extends ConsumerWidget {
  final ListModel list;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlanningListCard({
    super.key,
    required this.list,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withAlpha(51),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.grey.withAlpha(25),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            color: primaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              list.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error.withAlpha(178),
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete List',
                      style: IconButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.error.withAlpha(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 14,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.getRelativeDate(list.updatedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
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
}

/*
/// Card for displaying a planning sublist
class PlanningSublistCard extends StatelessWidget {
  final PlanningSublist planningSublist; 
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlanningSublistCard({
    super.key,
    required this.planningSublist,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: primaryColor.withAlpha(51),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                primaryColor.withAlpha(12),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: theme.colorScheme.secondary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "planningSublist.title", 
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error.withAlpha(178),
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete Sublist',
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.error.withAlpha(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
  
  Color _getProgressColor(double value, ThemeData theme) {
    if (value >= 1.0) {
      return Colors.green;
    } else if (value >= 0.5) {
      return Colors.orange;
    } else {
      return theme.colorScheme.primary;
    }
  }
}
*/

/// List tile for displaying a planning list item with checkbox
class PlanningListItemTile extends StatelessWidget {
  final ListItemModel item;
  final Function(bool? checked) onCheckChanged;
  final VoidCallback onDelete;

  const PlanningListItemTile({
    super.key,
    required this.item,
    required this.onCheckChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Dismissible(
      key: Key(item.id),
      background: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete_sweep,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: CheckboxListTile(
            value: item.isCompleted,
            onChanged: onCheckChanged,
            title: Text(
              item.name,
              style: TextStyle(
                decoration:
                    item.isCompleted ? TextDecoration.lineThrough : null,
                color: item.isCompleted
                    ? Colors.grey
                    : theme.textTheme.bodyMedium?.color,
                fontWeight:
                    item.isCompleted ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            secondary: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error.withAlpha(178),
              ),
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.error.withAlpha(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: item.isCompleted
                ? Colors.green
                : primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ),
    );
  }
}

/// Card for displaying a shopping list in the lists overview
class ShoppingListCard extends StatelessWidget {
  final ListModel list;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ShoppingListCard({
    super.key,
    required this.list,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: primaryColor.withAlpha(51),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                primaryColor.withAlpha(12),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: primaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              list.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error.withAlpha(178),
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete List',
                      style: IconButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.error.withAlpha(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 14,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.getRelativeDate(list.updatedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
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
}

/// List tile for displaying a shopping list item with checkbox and store info
class ShoppingListItemTile extends StatelessWidget {
  final ListItemModel item;
  final String?
      storeName; 
  final Function(bool? checked) onCheckChanged;
  final VoidCallback onDelete;

  const ShoppingListItemTile({
    super.key,
    required this.item,
    this.storeName,
    required this.onCheckChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Dismissible(
      key: Key(item.id),
      background: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete_sweep,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: CheckboxListTile(
                value: item.isCompleted,
                onChanged: onCheckChanged,
                title: Text(
                  item.name,
                  style: TextStyle(
                    decoration:
                        item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted
                        ? Colors.grey
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight:
                        item.isCompleted ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
                subtitle: storeName != null && storeName!.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront,
                                size: 12, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              storeName!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : (item.description != null && item.description!.isNotEmpty
                        ? Text(item.description!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)
                        : null),
                secondary: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error.withAlpha(178),
                  ),
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.error.withAlpha(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: item.isCompleted
                    ? Colors.green
                    : primaryColor,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            if (storeName == null &&
                item.description != null &&
                item.description!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(left: 72.0, right: 16.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withAlpha(51),
                      ),
                    ),
                    child: Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),
              ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
