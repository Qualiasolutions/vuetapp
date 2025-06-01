import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/reference_group_model.dart';
import 'package:vuet_app/providers/reference_providers.dart';
import 'package:vuet_app/ui/screens/references/reference_group_card.dart';
import 'package:vuet_app/ui/screens/references/reference_group_form.dart';

class ReferencesScreen extends ConsumerWidget {
  const ReferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(referenceGroupsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('References'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGroupDialog(context, ref),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) => groups.isEmpty
            ? _buildEmptyState(context, ref)
            : _buildGroupsList(context, groups),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading references',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(referenceGroupsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReferenceDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Reference'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.link,
              size: 96,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'No Reference Groups',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Organize your references by creating groups.\nStart by adding your first reference group.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddGroupDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Create Reference Group'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _showAddReferenceDialog(context, ref),
              icon: const Icon(Icons.link),
              label: const Text('Add Ungrouped Reference'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(BuildContext context, List<ReferenceGroupModel> groups) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ReferenceGroupCard(group: groups[index]),
        );
      },
    );
  }

  void _showAddGroupDialog(BuildContext context, WidgetRef ref) {
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
          onSaved: (groupId) {
            ref.invalidate(referenceGroupsProvider);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reference group created successfully'),
              ),
            );
          },
        ),
      ),
    );
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
          onSaved: (referenceId) {
            ref.invalidate(referencesProvider);
            ref.invalidate(referenceGroupsProvider);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reference created successfully'),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: ReferenceSearchDelegate(ref),
    );
  }
}

// Reference form widget
class ReferenceForm extends ConsumerStatefulWidget {
  final Function(String) onSaved;
  
  const ReferenceForm({
    super.key,
    required this.onSaved,
  });
  
  @override
  ConsumerState<ReferenceForm> createState() => _ReferenceFormState();
}

class _ReferenceFormState extends ConsumerState<ReferenceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGroupId;
  
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
            'Add Reference',
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
                child: const Text('Save'),
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
        final id = await ref.read(referenceNotifierProvider.notifier)
            .createReference(
              name: _nameController.text.trim(),
              groupId: _selectedGroupId,
            );
        
        if (mounted) {
          widget.onSaved(id);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating reference: $e')),
          );
        }
      }
    }
  }
}

// Search delegate for references
class ReferenceSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  
  ReferenceSearchDelegate(this.ref);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }
  
  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(
        child: Text('Enter a search term'),
      );
    }
    
    return Consumer(
      builder: (context, ref, child) {
        final referencesAsync = ref.watch(referencesProvider);
        
        return referencesAsync.when(
          data: (references) {
            final filteredReferences = references
                .where((ref) => ref.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            
            if (filteredReferences.isEmpty) {
              return const Center(
                child: Text('No references found'),
              );
            }
            
            return ListView.builder(
              itemCount: filteredReferences.length,
              itemBuilder: (context, index) {
                final reference = filteredReferences[index];
                return ListTile(
                  title: Text(reference.name),
                  subtitle: reference.groupId != null 
                      ? FutureBuilder(
                          future: ref.read(referenceGroupByIdProvider(reference.groupId!).future),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text('Group: ${snapshot.data!.name}');
                            }
                            return const SizedBox.shrink();
                          },
                        )
                      : const Text('No group'),
                  onTap: () {
                    close(context, reference.id);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        );
      },
    );
  }
} 