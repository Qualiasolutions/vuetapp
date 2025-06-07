import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/models/family_entities.dart';
import 'package:vuet_app/providers/birthday_providers.dart';
import 'package:vuet_app/ui/navigation/family_navigator.dart';
import 'package:vuet_app/ui/shared/widgets.dart';

class BirthdayListScreen extends ConsumerStatefulWidget {
  const BirthdayListScreen({super.key});

  @override
  ConsumerState<BirthdayListScreen> createState() => _BirthdayListScreenState();
}

class _BirthdayListScreenState extends ConsumerState<BirthdayListScreen> {
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

  List<Birthday> _filterBirthdays(List<Birthday> allBirthdays) {
    if (_searchQuery.isEmpty) {
      return allBirthdays;
    }
    final query = _searchQuery.toLowerCase();
    return allBirthdays.where((birthday) {
      return birthday.name.toLowerCase().contains(query) ||
             (birthday.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Future<void> _refreshBirthdays() async {
    await ref.refresh(familyBirthdaysProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final birthdaysAsyncValue = ref.watch(familyBirthdaysProvider);

    return Scaffold(
      appBar: const VuetHeader('Birthdays'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search birthdays...',
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
          Expanded(
            child: birthdaysAsyncValue.when(
              data: (allBirthdays) {
                final filteredBirthdays = _filterBirthdays(allBirthdays);
                if (filteredBirthdays.isEmpty) {
                  return _buildEmptyState(allBirthdays.isEmpty);
                }
                return _buildBirthdaysList(filteredBirthdays);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${err.toString()}'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _refreshBirthdays, child: const Text('Retry'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => FamilyNavigator.navigateToBirthdayForm(context), // Assumes this helper will be created
        tooltip: 'Add Birthday',
      ),
    );
  }

  Widget _buildEmptyState(bool isTrulyEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cake_outlined,
            size: 64,
            color: AppColors.steel.withAlpha((255 * 0.5).round()),
          ),
          const SizedBox(height: 16),
          Text(
            isTrulyEmpty && _searchQuery.isEmpty
                ? 'No birthdays yet'
                : 'No birthdays found',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.steel),
          ),
          const SizedBox(height: 8),
          Text(
            isTrulyEmpty && _searchQuery.isEmpty
                ? 'Add birthdays to remember important dates.'
                : 'Try adjusting your search terms.',
            style: const TextStyle(fontSize: 14, color: AppColors.steel),
            textAlign: TextAlign.center,
          ),
          if (isTrulyEmpty && _searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            VuetSaveButton(
              text: 'Add First Birthday',
              onPressed: () => FamilyNavigator.navigateToBirthdayForm(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBirthdaysList(List<Birthday> birthdaysToDisplay) {
    return RefreshIndicator(
      onRefresh: _refreshBirthdays,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: birthdaysToDisplay.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final birthday = birthdaysToDisplay[index];
          return _BirthdayCard(
            birthday: birthday,
            onTap: () => _showBirthdayDetails(birthday),
            onEdit: () {
              if (birthday.id != null) {
                FamilyNavigator.navigateToBirthdayForm(context, birthdayId: birthday.id.toString());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Birthday ID is missing.'), backgroundColor: Colors.red),
                );
              }
            },
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
            _DetailRow('Date:', DateFormat('MMMM d, yyyy').format(birthday.dob)),
            if (!birthday.knownYear) const _DetailRow('Year Known:', 'No'),
            if (birthday.notes != null && birthday.notes!.isNotEmpty)
              _DetailRow('Notes:', birthday.notes!),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (birthday.id != null) {
                FamilyNavigator.navigateToBirthdayForm(context, birthdayId: birthday.id.toString());
              }
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
        content: Text('Are you sure you want to delete the birthday for "${birthday.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (birthday.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Cannot delete birthday without ID.'), backgroundColor: Colors.red),
                );
                return;
              }
              try {
                await ref.read(birthdayServiceProvider).deleteBirthday(birthday.id!);
                _refreshBirthdays();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Birthday deleted'), backgroundColor: AppColors.mediumTurquoise),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting birthday: $e'), backgroundColor: Colors.red),
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
}

class _BirthdayCard extends StatelessWidget {
  const _BirthdayCard({required this.birthday, required this.onTap, required this.onEdit, required this.onDelete});

  final Birthday birthday;
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
        side: BorderSide(color: AppColors.steel.withAlpha((255 * 0.3).round()), width: 0.5),
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
                  color: AppColors.coralPink.withAlpha((255 * 0.15).round()), // Different color for birthdays
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.cake, color: AppColors.coralPink, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(birthday.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkJungleGreen)),
                    const SizedBox(height: 4),
                    Text(DateFormat('MMMM d').format(birthday.dob) + (birthday.knownYear ? ', ${birthday.dob.year}' : ''), style: const TextStyle(fontSize: 14, color: AppColors.steel)),
                    if (birthday.notes != null && birthday.notes!.isNotEmpty) ...[
                       const SizedBox(height: 4),
                       Text(birthday.notes!, style: const TextStyle(fontSize: 12, color: AppColors.steel, fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 16, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.steel))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.darkJungleGreen))),
        ],
      ),
    );
  }
}
