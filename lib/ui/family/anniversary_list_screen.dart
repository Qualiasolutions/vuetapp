import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Anniversary List Screen - Shows all Anniversary entities
/// Following detailed guide specifications with Modern Palette
class AnniversaryListScreen extends StatefulWidget {
  const AnniversaryListScreen({super.key});

  @override
  State<AnniversaryListScreen> createState() => _AnniversaryListScreenState();
}

class _AnniversaryListScreenState extends State<AnniversaryListScreen> {
  List<Anniversary> _anniversaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnniversaries();
  }

  Future<void> _loadAnniversaries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from Supabase using MCP tools
      // For now, show sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _anniversaries = [
          Anniversary(
            id: 1,
            name: 'Wedding Anniversary',
            date: DateTime(2015, 6, 20),
            knownYear: true,
          ),
          Anniversary(
            id: 2,
            name: 'First Date Anniversary',
            date: DateTime(2014, 2, 14),
            knownYear: true,
          ),
          Anniversary(
            id: 3,
            name: 'Company Anniversary',
            date: DateTime(2020, 9, 1),
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
            content: Text('Error loading anniversaries: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Anniversaries'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _anniversaries.isEmpty
              ? _buildEmptyState()
              : _buildAnniversaryList(),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/anniversaries/create'),
        tooltip: 'Add Anniversary',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 64,
            color: AppColors.steel.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No anniversaries yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.steel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add important anniversaries to get automatic reminders',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          VuetSaveButton(
            text: 'Add First Anniversary',
            onPressed: () => context.go('/categories/family/anniversaries/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnniversaryList() {
    return RefreshIndicator(
      onRefresh: _loadAnniversaries,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _anniversaries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final anniversary = _anniversaries[index];
          return _AnniversaryCard(
            anniversary: anniversary,
            onTap: () => _showAnniversaryDetails(anniversary),
            onEdit: () => context.go('/categories/family/anniversaries/${anniversary.id}/edit'),
            onDelete: () => _deleteAnniversary(anniversary),
          );
        },
      ),
    );
  }

  void _showAnniversaryDetails(Anniversary anniversary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(anniversary.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Anniversary Date', _formatDate(anniversary.date)),
            _DetailRow('Known Year', anniversary.knownYear ? 'Yes' : 'No'),
            if (anniversary.knownYear)
              _DetailRow('Years Together', '${_calculateYears(anniversary.date)} years'),
            _DetailRow('Next Anniversary', _getNextAnniversary(anniversary.date)),
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
              context.go('/categories/family/anniversaries/${anniversary.id}/edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteAnniversary(Anniversary anniversary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Anniversary'),
        content: Text('Are you sure you want to delete ${anniversary.name}?'),
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
                _anniversaries.removeWhere((a) => a.id == anniversary.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anniversary deleted'),
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

  int _calculateYears(DateTime anniversaryDate) {
    final now = DateTime.now();
    int years = now.year - anniversaryDate.year;
    if (now.month < anniversaryDate.month || 
        (now.month == anniversaryDate.month && now.day < anniversaryDate.day)) {
      years--;
    }
    return years;
  }

  String _getNextAnniversary(DateTime anniversaryDate) {
    final now = DateTime.now();
    var nextAnniversary = DateTime(now.year, anniversaryDate.month, anniversaryDate.day);
    
    if (nextAnniversary.isBefore(now)) {
      nextAnniversary = DateTime(now.year + 1, anniversaryDate.month, anniversaryDate.day);
    }
    
    final daysUntil = nextAnniversary.difference(now).inDays;
    
    if (daysUntil == 0) {
      return 'Today! 💕';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else {
      return 'In $daysUntil days';
    }
  }
}

class _AnniversaryCard extends StatelessWidget {
  const _AnniversaryCard({
    required this.anniversary,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Anniversary anniversary;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final nextAnniversary = _getNextAnniversary(anniversary.date);
    final isToday = nextAnniversary.contains('Today');
    
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
                  isToday ? Icons.celebration : Icons.favorite,
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
                      anniversary.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isToday ? AppColors.orange : AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${anniversary.date.day}/${anniversary.date.month}${anniversary.knownYear ? '/${anniversary.date.year}' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.steel,
                      ),
                    ),
                    Text(
                      nextAnniversary,
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

  String _getNextAnniversary(DateTime anniversaryDate) {
    final now = DateTime.now();
    var nextAnniversary = DateTime(now.year, anniversaryDate.month, anniversaryDate.day);
    
    if (nextAnniversary.isBefore(now)) {
      nextAnniversary = DateTime(now.year + 1, anniversaryDate.month, anniversaryDate.day);
    }
    
    final daysUntil = nextAnniversary.difference(now).inDays;
    
    if (daysUntil == 0) {
      return 'Today! 💕';
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
