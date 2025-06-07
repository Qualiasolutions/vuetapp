import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../../providers/family_member_providers.dart';
import '../shared/widgets.dart';

/// FamilyMember List Screen - Shows all FamilyMember entities
/// Following detailed guide specifications with Modern Palette
class FamilyMemberListScreen extends ConsumerStatefulWidget {
  const FamilyMemberListScreen({super.key});

  @override
  ConsumerState<FamilyMemberListScreen> createState() => _FamilyMemberListScreenState();
}

class _FamilyMemberListScreenState extends ConsumerState<FamilyMemberListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FamilyMember> _filterFamilyMembers(List<FamilyMember> allMembers) {
    if (_searchQuery.isEmpty) {
      return allMembers;
    }
    final query = _searchQuery.toLowerCase();
    return allMembers.where((member) {
      return member.firstName.toLowerCase().contains(query) ||
             member.lastName.toLowerCase().contains(query) ||
             (member.relationship?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Future<void> _refreshFamilyMembers() async {
    await ref.refresh(familyMembersProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final familyMembersAsyncValue = ref.watch(familyMembersProvider);

    return Scaffold(
      appBar: const VuetHeader('Family Members'),
      body: Column(
        children: [
          // Search bar
          Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search family members...',
                      hintStyle: TextStyle(color: AppColors.steel),
                      prefixIcon: Icon(Icons.search, color: AppColors.steel),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.steel),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mediumTurquoise),
                      ),
                    ),
                  ),
                ),
          // Family members list
          Expanded(
            child: familyMembersAsyncValue.when(
              data: (allMembers) {
                final filteredMembers = _filterFamilyMembers(allMembers);
                if (filteredMembers.isEmpty) {
                  return _buildEmptyState(allMembers.isEmpty);
                }
                return _buildFamilyMembersList(filteredMembers);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${err.toString()}'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _refreshFamilyMembers, child: const Text('Retry'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/family-members/create'),
        tooltip: 'Add Family Member',
      ),
    );
  }

  Widget _buildEmptyState(bool isTrulyEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.steel.withAlpha((255 * 0.5).round()),
          ),
          const SizedBox(height: 16),
          Text(
            isTrulyEmpty && _searchQuery.isEmpty
                ? 'No family members yet'
                : 'No family members found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.steel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTrulyEmpty && _searchQuery.isEmpty
                ? 'Add family members to keep track of contact information'
                : 'Try adjusting your search terms',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          if (isTrulyEmpty && _searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            VuetSaveButton(
              text: 'Add First Family Member',
              onPressed: () => context.go('/categories/family/family-members/create'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyMembersList(List<FamilyMember> membersToDisplay) {
    return RefreshIndicator(
      onRefresh: _refreshFamilyMembers,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: membersToDisplay.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final familyMember = membersToDisplay[index];
          return _FamilyMemberCard(
            familyMember: familyMember,
            onTap: () => _showFamilyMemberDetails(familyMember),
            onEdit: () {
              if (familyMember.id != null) { // Ensure ID is not null before navigating
                context.go('/categories/family/family-members/${familyMember.id}/edit');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Family member ID is missing.'), backgroundColor: Colors.red),
                );
              }
            },
            onDelete: () => _deleteFamilyMember(familyMember),
          );
        },
      ),
    );
  }

  void _showFamilyMemberDetails(FamilyMember familyMember) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${familyMember.firstName} ${familyMember.lastName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (familyMember.relationship != null)
              _DetailRow('Relationship', familyMember.relationship!),
            if (familyMember.dateOfBirth != null)
              _DetailRow('Date of Birth', _formatDate(familyMember.dateOfBirth!)),
            if (familyMember.phoneNumber != null)
              _DetailRow('Phone', familyMember.phoneNumber!),
            if (familyMember.email != null)
              _DetailRow('Email', familyMember.email!),
            if (familyMember.notes != null)
              _DetailRow('Notes', familyMember.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/categories/family/family-members/${familyMember.id}/edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteFamilyMember(FamilyMember familyMember) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Family Member'),
        content: Text('Are you sure you want to delete "${familyMember.firstName} ${familyMember.lastName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (familyMember.id == null) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Cannot delete member without ID.'), backgroundColor: Colors.red),
                );
                return;
              }
              try {
                await ref.read(familyMemberServiceProvider).deleteFamilyMember(familyMember.id!);
                _refreshFamilyMembers(); // Refresh the list
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Family member deleted'),
                      backgroundColor: AppColors.mediumTurquoise,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting family member: $e'), backgroundColor: Colors.red),
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
    return '${date.day}/${date.month}/${date.year}';
  }

  // int _calculateAge(DateTime birthDate) { // Unused element
  //   final now = DateTime.now();
  //   int age = now.year - birthDate.year;
  //   if (now.month < birthDate.month || 
  //       (now.month == birthDate.month && now.day < birthDate.day)) {
  //     age--;
  //   }
  //   return age;
  // }
}

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({
    required this.familyMember,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final FamilyMember familyMember;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.steel.withAlpha((255 * 0.3).round()),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mediumTurquoise.withAlpha((255 * 0.15).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.mediumTurquoise,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${familyMember.firstName} ${familyMember.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (familyMember.relationship != null)
                      Text(
                        familyMember.relationship!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.steel,
                        ),
                      ),
                    if (familyMember.dateOfBirth != null)
                      Text(
                        'Age ${_calculateAge(familyMember.dateOfBirth!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumTurquoise,
                        ),
                      ),
                    if (familyMember.phoneNumber != null || familyMember.email != null)
                      Row(
                        children: [
                          if (familyMember.phoneNumber != null)
                            const Icon(
                              Icons.phone,
                              size: 12,
                              color: AppColors.steel,
                            ),
                          if (familyMember.phoneNumber != null && familyMember.email != null)
                            const SizedBox(width: 8),
                          if (familyMember.email != null)
                            const Icon(
                              Icons.email,
                              size: 12,
                              color: AppColors.steel,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
