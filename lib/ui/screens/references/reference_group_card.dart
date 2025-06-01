import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/reference_group_model.dart';
import 'package:vuet_app/models/reference_model.dart';
import 'package:vuet_app/providers/reference_providers.dart';
import 'package:vuet_app/ui/screens/references/reference_group_form.dart';

class ReferenceGroupCard extends ConsumerWidget {
  final ReferenceGroupModel group;
  
  const ReferenceGroupCard({super.key, required this.group});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referencesAsync = ref.watch(referencesByGroupProvider(group.id));
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const Divider(height: 1),
          _buildReferencesSection(context, ref, referencesAsync),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (group.createdAt != null)
                  Text(
                    'Created ${_formatDate(group.createdAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_reference',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add Reference'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Group'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Group', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildReferencesSection(
    BuildContext context, 
    WidgetRef ref, 
    AsyncValue<List<ReferenceModel>> referencesAsync
  ) {
    return referencesAsync.when(
      data: (references) => references.isEmpty
          ? _buildEmptyReferences(context, ref)
          : _buildReferencesList(context, ref, references),
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error loading references: $error',
          style: TextStyle(color: Colors.red[700]),
        ),
      ),
    );
  }
  
  Widget _buildEmptyReferences(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'No references in this group',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showAddReferenceDialog(context, ref),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add First Reference'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReferencesList(
    BuildContext context, 
    WidgetRef ref, 
    List<ReferenceModel> references
  ) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: references.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final reference = references[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              title: Text(reference.name),
              subtitle: reference.createdAt != null 
                  ? Text('Added ${_formatDate(reference.createdAt!)}')
                  : null,
              trailing: PopupMenuButton<String>(
                onSelected: (value) => _handleReferenceAction(
                  context, ref, reference, value,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showAddReferenceDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Reference'),
            ),
          ),
        ),
      ],
    );
  }
  
  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'add_reference':
        _showAddReferenceDialog(context, ref);
        break;
      case 'edit':
        _showEditGroupDialog(context, ref);
        break;
      case 'delete':
        _showDeleteGroupDialog(context, ref);
        break;
    }
  }
  
  void _handleReferenceAction(
    BuildContext context, 
    WidgetRef ref, 
    ReferenceModel reference, 
    String action
  ) {
    switch (action) {
      case 'edit':
        _showEditReferenceDialog(context, ref, reference);
        break;
      case 'delete':
        _showDeleteReferenceDialog(context, ref, reference);
        break;
    }
  }
  
  void _showAddReferenceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: ReferenceForm(
          initialGroupId: group.id,
          onSaved: (referenceId) {
            ref.invalidate(referencesByGroupProvider(group.id));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reference added successfully'),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _showEditGroupDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: ReferenceGroupForm(
          initialData: group,
          onSaved: (groupId) {
            ref.invalidate(referenceGroupsProvider);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reference group updated successfully'),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _showEditReferenceDialog(
    BuildContext context, 
    WidgetRef ref, 
    ReferenceModel reference
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: ReferenceForm(
          initialData: reference,
          onSaved: (referenceId) {
            ref.invalidate(referencesByGroupProvider(group.id));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reference updated successfully'),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _showDeleteGroupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reference Group'),
        content: Text(
          'Are you sure you want to delete "${group.name}"? This will also delete all references in this group.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(referenceGroupNotifierProvider.notifier)
                    .deleteReferenceGroup(group.id);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reference group deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting group: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteReferenceDialog(
    BuildContext context, 
    WidgetRef ref, 
    ReferenceModel reference
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reference'),
        content: Text(
          'Are you sure you want to delete "${reference.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(referenceNotifierProvider.notifier)
                    .deleteReference(reference.id);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reference deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting reference: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}

// Reference form widget for adding/editing references
class ReferenceForm extends ConsumerStatefulWidget {
  final ReferenceModel? initialData;
  final String? initialGroupId;
  final Function(String) onSaved;
  
  const ReferenceForm({
    super.key,
    this.initialData,
    this.initialGroupId,
    required this.onSaved,
  });
  
  @override
  ConsumerState<ReferenceForm> createState() => _ReferenceFormState();
}

class _ReferenceFormState extends ConsumerState<ReferenceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _selectedGroupId;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?.name ?? '');
    _selectedGroupId = widget.initialData?.groupId ?? widget.initialGroupId;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(referenceGroupsProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialData == null ? 'Add Reference' : 'Edit Reference',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Reference Name',
              hintText: 'Enter reference name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a reference name';
              }
              return null;
            },
            autofocus: true,
          ),
          const SizedBox(height: 16),
          groupsAsync.when(
            data: (groups) => DropdownButtonFormField<String>(
              value: _selectedGroupId,
              decoration: const InputDecoration(
                labelText: 'Reference Group (Optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No Group'),
                ),
                ...groups.map((group) => DropdownMenuItem<String>(
                  value: group.id,
                  child: Text(group.name),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGroupId = value;
                });
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error loading groups: $error'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _saveReference,
                child: Text(widget.initialData == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveReference() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.initialData == null) {
          // Create new reference
          final id = await ref.read(referenceNotifierProvider.notifier)
              .createReference(
                name: _nameController.text.trim(),
                groupId: _selectedGroupId,
              );
          
          if (mounted) {
            widget.onSaved(id);
          }
        } else {
          // Update existing reference
          final updatedReference = widget.initialData!.copyWith(
            name: _nameController.text.trim(),
            groupId: _selectedGroupId,
            updatedAt: DateTime.now(),
          );
          
          await ref.read(referenceNotifierProvider.notifier)
              .updateReference(updatedReference);
          
          if (mounted) {
            widget.onSaved(widget.initialData!.id);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving reference: $e')),
          );
        }
      }
    }
  }
} 