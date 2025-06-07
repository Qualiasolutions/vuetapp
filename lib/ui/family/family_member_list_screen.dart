import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// FamilyMember List Screen - Shows all FamilyMember entities
/// Following detailed guide specifications with Modern Palette
class FamilyMemberListScreen extends StatefulWidget {
  const FamilyMemberListScreen({super.key});

  @override
  State<FamilyMemberListScreen> createState() => _FamilyMemberListScreenState();
}

class _FamilyMemberListScreenState extends State<FamilyMemberListScreen> {
  List<FamilyMember> _familyMembers = [];
  List<FamilyMember> _filteredFamilyMembers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
    _searchController.addListener(_filterFamilyMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFamilyMembers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from Supabase using MCP tools
      // For now, show sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _familyMembers = [
          FamilyMember(
            id: 1,
            firstName: 'John',
            lastName: 'Smith',
            relationship: 'Father',
            dateOfBirth: DateTime(1975, 5, 15),
            phoneNumber: '+1-555-0123',
            email: 'john.smith@email.com',
            notes: 'Emergency contact',
          ),
          FamilyMember(
            id: 2,
            firstName: 'Sarah',
            lastName: 'Smith',
            relationship: 'Mother',
            dateOfBirth: DateTime(1978, 8, 22),
            phoneNumber: '+1-555-0124',
            email: 'sarah.smith@email.com',
            notes: null,
          ),
          FamilyMember(
            id: 3,
            firstName: 'Emma',
            lastName: 'Smith',
            relationship: 'Sister',
            dateOfBirth: DateTime(2005, 12, 3),
            phoneNumber: null,
            email: null,
            notes: 'High school student',
          ),
          FamilyMember(
            id: 4,
            firstName: 'Robert',
            lastName: 'Johnson',
            relationship: 'Grandfather',
            dateOfBirth: DateTime(1945, 3, 10),
            phoneNumber: '+1-555-0125',
            email: null,
            notes: 'Lives in assisted living',
          ),
        ];
        _filteredFamilyMembers = List.from(_familyMembers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading family members: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterFamilyMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFamilyMembers = _familyMembers.where((member) {
        return member.firstName.toLowerCase().contains(query) ||
               member.lastName.toLowerCase().contains(query) ||
               (member.relationship?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Family Members'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                  child: _filteredFamilyMembers.isEmpty
                      ? _buildEmptyState()
                      : _buildFamilyMembersList(),
                ),
              ],
            ),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/family-members/create'),
        tooltip: 'Add Family Member',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.steel.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty 
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
            _searchController.text.isEmpty
                ? 'Add family members to keep track of contact information'
                : 'Try adjusting your search terms',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isEmpty) ...[
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

  Widget _buildFamilyMembersList() {
    return RefreshIndicator(
      onRefresh: _loadFamilyMembers,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredFamilyMembers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final familyMember = _filteredFamilyMembers[index];
          return _FamilyMemberCard(
            familyMember: familyMember,
            onTap: () => _showFamilyMemberDetails(familyMember),
            onEdit: () => context.go('/categories/family/family-members/${familyMember.id}/edit'),
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete from Supabase using MCP tools
              setState(() {
                _familyMembers.removeWhere((m) => m.id == familyMember.id);
                _filterFamilyMembers();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Family member deleted'),
                  backgroundColor: AppColors.mediumTurquoise,
                ),
              );
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
          color: AppColors.steel.withOpacity(0.3),
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
                  color: AppColors.mediumTurquoise.withOpacity(0.15),
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
