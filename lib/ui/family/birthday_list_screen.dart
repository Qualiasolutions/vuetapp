import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Birthday List Screen - Shows all Birthday entities
/// Following detailed guide specifications with Modern Palette
class BirthdayListScreen extends StatefulWidget {
  const BirthdayListScreen({super.key});

  @override
  State<BirthdayListScreen> createState() => _BirthdayListScreenState();
}

class _BirthdayListScreenState extends State<BirthdayListScreen> {
  List<Birthday> _birthdays = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBirthdays();
  }

  Future<void> _loadBirthdays() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from Supabase using MCP tools
      // For now, show sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _birthdays = [
          Birthday(
            id: 1,
            name: 'John Doe',
            dob: DateTime(1990, 5, 15),
            knownYear: true,
          ),
          Birthday(
            id: 2,
            name: 'Jane Smith',
            dob: DateTime(1985, 12, 3),
            knownYear: true,
          ),
          Birthday(
            id: 3,
            name: 'Baby Alex',
            dob: DateTime(2020, 8, 22),
            knownYear: false,
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading birthdays: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Birthdays'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _birthdays.isEmpty
              ? _buildEmptyState()
              : _buildBirthdayList(),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/birthdays/create'),
        tooltip: 'Add Birthday',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cake_outlined,
            size: 64,
            color: AppColors.steel.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No birthdays yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.steel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add family member birthdays to get automatic reminders',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          VuetSaveButton(
            text: 'Add First Birthday',
            onPressed: () => context.go('/categories/family/birthdays/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayList() {
    return RefreshIndicator(
      onRefresh: _loadBirthdays,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _birthdays.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final birthday = _birthdays[index];
          return _BirthdayCard(
            birthday: birthday,
            onTap: () => _showBirthdayDetails(birthday),
            onEdit: () => context.go('/categories/family/birthdays/${birthday.id}/edit'),
            onDelete: () => _deleteBirthday(birthday),
          );
        },
      ),
    );
  }

  void _showBirthdayDetails(Birthday birthday) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(birthday.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Date of Birth', _formatDate(birthday.dob)),
            _DetailRow('Known Year', birthday.knownYear ? 'Yes' : 'No'),
            if (birthday.knownYear)
              _DetailRow('Age', '${_calculateAge(birthday.dob)} years old'),
            _DetailRow('Next Birthday', _getNextBirthday(birthday.dob)),
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
              context.go('/categories/family/birthdays/${birthday.id}/edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteBirthday(Birthday birthday) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: Text('Are you sure you want to delete ${birthday.name}\'s birthday?'),
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
                _birthdays.removeWhere((b) => b.id == birthday.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Birthday deleted'),
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

  String _getNextBirthday(DateTime birthDate) {
    final now = DateTime.now();
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    
    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }
    
    final daysUntil = nextBirthday.difference(now).inDays;
    
    if (daysUntil == 0) {
      return 'Today! 🎉';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else {
      return 'In $daysUntil days';
    }
  }
}

class _BirthdayCard extends StatelessWidget {
  const _BirthdayCard({
    required this.birthday,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Birthday birthday;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final nextBirthday = _getNextBirthday(birthday.dob);
    final isToday = nextBirthday.contains('Today');
    
    return Card(
      color: isToday ? AppColors.orange.withOpacity(0.1) : AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isToday ? AppColors.orange : AppColors.steel.withOpacity(0.3),
          width: isToday ? 2 : 0.5,
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
                  color: isToday 
                      ? AppColors.orange.withOpacity(0.2)
                      : AppColors.mediumTurquoise.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isToday ? Icons.celebration : Icons.cake,
                  color: isToday ? AppColors.orange : AppColors.mediumTurquoise,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birthday.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isToday ? AppColors.orange : AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${birthday.dob.day}/${birthday.dob.month}${birthday.knownYear ? '/${birthday.dob.year}' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.steel,
                      ),
                    ),
                    Text(
                      nextBirthday,
                      style: TextStyle(
                        fontSize: 12,
                        color: isToday ? AppColors.orange : AppColors.mediumTurquoise,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
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

  String _getNextBirthday(DateTime birthDate) {
    final now = DateTime.now();
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    
    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }
    
    final daysUntil = nextBirthday.difference(now).inDays;
    
    if (daysUntil == 0) {
      return 'Today! 🎉';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else {
      return 'In $daysUntil days';
    }
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
            width: 100,
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
