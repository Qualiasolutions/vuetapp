import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/providers/modernized_list_providers.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/ui/lists/components/list_item_components.dart';
import 'package:vuet_app/ui/lists/screens/planning_list_detail_screen.dart';

class PlanningListsScreen extends ConsumerWidget {
  const PlanningListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planningListsAsync = ref.watch(planningListsProvider);

    return Scaffold(
      body: planningListsAsync.when(
        data: (planningLists) {
          if (planningLists.isEmpty) {
            return const EmptyListState(
              message: 'No planning lists yet.\nCreate a new planning list to get started!',
              icon: Icons.assignment_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(planningListsProvider);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: planningLists.length,
                itemBuilder: (context, index) {
                  final list = planningLists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: PlanningListCard(
                      list: list,
                      onTap: () => _navigateToListDetail(context, list),
                      onDelete: () => _confirmDeleteList(context, ref, list),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading lists: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPlanningListDialog(context, ref);
        },
        tooltip: 'Add Planning List',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToListDetail(BuildContext context, ListModel list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanningListDetailScreen(list: list),
      ),
    );
  }

  void _showAddPlanningListDialog(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CreatePlanningListScreen(),
      ),
    ).then((_) {
      // Refresh lists when returning from create screen
      ref.invalidate(planningListsProvider);
      ref.invalidate(allListsProvider);
    });
  }

  void _confirmDeleteList(BuildContext context, WidgetRef ref, ListModel list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Planning List'),
          content: Text('Are you sure you want to delete "${list.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  final listNotifier = ref.read(listNotifierProvider.notifier);
                  await listNotifier.deleteList(list.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Planning list deleted')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete list: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// Removed placeholder EmptyListState as it's defined in list_item_components.dart

class _CreatePlanningListScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreatePlanningListScreen> createState() => _CreatePlanningListScreenState();
}

class _CreatePlanningListScreenState extends ConsumerState<_CreatePlanningListScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedFamilyMembers = {};
  bool _shareWithFamily = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserFamilyAsync = ref.watch(currentUserFamilyProvider);
    final familyMembersAsync = ref.watch(familyMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Planning List'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createList,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('CREATE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'List Name *',
                border: OutlineInputBorder(),
                hintText: 'Enter list name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Enter list description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Family Sharing Section
            currentUserFamilyAsync.when(
              data: (family) {
                if (family == null) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.family_restroom,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join a family to share lists',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Create or join a family group to collaborate on lists with family members.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family Sharing',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Share with family'),
                      subtitle: const Text('Allow family members to view and edit this list'),
                      value: _shareWithFamily,
                      onChanged: (value) {
                        setState(() {
                          _shareWithFamily = value;
                          if (!value) {
                            _selectedFamilyMembers.clear();
                          }
                        });
                      },
                    ),
                    if (_shareWithFamily) ...[
                      const SizedBox(height: 16),
                      familyMembersAsync.when(
                        data: (members) {
                          if (members.isEmpty) {
                            return const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No family members to share with'),
                              ),
                            );
                          }

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select family members to share with:',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 12),
                                  ...members.map((member) {
                                    final isCurrentUser = member.userId == ref.read(currentUserIdProvider);
                                    if (isCurrentUser) return const SizedBox();

                                    Color? avatarColor;
                                    if (member.memberColor.startsWith('#')) {
                                      try {
                                        avatarColor = Color(int.parse('0xFF${member.memberColor.substring(1)}'));
                                      } catch (e) {
                                        avatarColor = Colors.grey;
                                      }
                                    }

                                    return CheckboxListTile(
                                      title: Text('${member.firstName ?? ''} ${member.lastName ?? ''}'),
                                      subtitle: Text(member.email ?? ''),
                                      secondary: CircleAvatar(
                                        backgroundColor: avatarColor ?? Colors.blue,
                                        foregroundColor: Colors.white,
                                        backgroundImage: member.profileImageUrl != null
                                            ? NetworkImage(member.profileImageUrl!)
                                            : null,
                                        child: member.profileImageUrl == null
                                            ? Text((member.firstName ?? 'U')[0].toUpperCase())
                                            : null,
                                      ),
                                      value: _selectedFamilyMembers.contains(member.userId),
                                      onChanged: (selected) {
                                        setState(() {
                                          if (selected == true) {
                                            _selectedFamilyMembers.add(member.userId);
                                          } else {
                                            _selectedFamilyMembers.remove(member.userId);
                                          }
                                        });
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        error: (error, _) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error loading family members: $error'),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading family information: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createList() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('List name cannot be empty')),
      );
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not identified')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final listNotifier = ref.read(listNotifierProvider.notifier);
      final currentUserFamily = await ref.read(currentUserFamilyProvider.future);
      
      final newList = ListModel.create(
        name: name,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        ownerId: userId,
        familyId: _shareWithFamily ? currentUserFamily?.id : null,
        isShoppingList: false, // Planning list
      );

      // Add family sharing if selected
      final finalList = _shareWithFamily && _selectedFamilyMembers.isNotEmpty
          ? newList.shareWith(_selectedFamilyMembers.toList())
          : newList;

      await listNotifier.createList(finalList);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _shareWithFamily
                  ? 'Planning list created and shared with family'
                  : 'Planning list created',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create list: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
