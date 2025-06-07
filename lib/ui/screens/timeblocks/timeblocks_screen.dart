import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/providers/timeblock_providers.dart';
import 'package:vuet_app/ui/screens/timeblocks/create_edit_timeblock_screen.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

class TimeblocksScreen extends ConsumerStatefulWidget {
  const TimeblocksScreen({super.key});

  @override
  ConsumerState<TimeblocksScreen> createState() => _TimeblocksScreenState();
}

class _TimeblocksScreenState extends ConsumerState<TimeblocksScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeblocksAsync = ref.watch(userTimeblocksProvider);
    final timeblockNotifier = ref.watch(timeblockNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Weekly Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => ref.refresh(userTimeblocksProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: timeblocksAsync.when(
          data: (timeblocks) => _buildWeeklyView(timeblocks, timeblockNotifier),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(error.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateTimeblock(),
        backgroundColor: colorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeeklyView(List<TimeblockModel> timeblocks, TimeblockNotifier notifier) {
    if (timeblocks.isEmpty) {
      return _buildEmptyState();
    }

    // Group timeblocks by day of week
    final timeblocksByDay = <int, List<TimeblockModel>>{};
    for (int day = 1; day <= 7; day++) {
      timeblocksByDay[day] = timeblocks.where((tb) => tb.dayOfWeek == day).toList();
      timeblocksByDay[day]!.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Weekly Schedule'),
          const SizedBox(height: 16),
          ...List.generate(7, (index) {
            final dayOfWeek = index + 1;
            final dayTimeblocks = timeblocksByDay[dayOfWeek] ?? [];
            return _buildDaySection(dayOfWeek, dayTimeblocks, notifier);
          }),
        ],
      ),
    );
  }

  Widget _buildDaySection(int dayOfWeek, List<TimeblockModel> timeblocks, TimeblockNotifier notifier) {
    final dayName = _getDayName(dayOfWeek);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ModernComponents.modernCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${timeblocks.length} timeblock${timeblocks.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 20, color: colorScheme.secondary),
                      onPressed: () => _navigateToCreateTimeblock(dayOfWeek: dayOfWeek),
                      tooltip: 'Add timeblock for $dayName',
                    ),
                  ],
                ),
              ],
            ),
            if (timeblocks.isEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.grey.shade400, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No timeblocks scheduled',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              ...timeblocks.map((timeblock) => _buildTimeblockCard(timeblock, notifier)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeblockCard(TimeblockModel timeblock, TimeblockNotifier notifier) {
    final startTime = _parseTime(timeblock.startTime);
    final endTime = _parseTime(timeblock.endTime);
    final duration = _calculateDuration(startTime, endTime);
    final color = _parseColor(timeblock.color);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ModernComponents.modernCard(
        onTap: () => _navigateToEditTimeblock(timeblock.id),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color ?? colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            
            // Time indicator
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    endTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (timeblock.title != null && timeblock.title!.isNotEmpty) ...[
                    Text(
                      timeblock.title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                  if (timeblock.description != null && timeblock.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      timeblock.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              onPressed: () => _navigateToEditTimeblock(timeblock.id),
              tooltip: 'Edit',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'No Timeblocks Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first timeblock to start organizing your weekly schedule',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ModernComponents.modernButton(
              text: 'Create Timeblock',
              onPressed: () => _navigateToCreateTimeblock(),
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Error Loading Timeblocks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(userTimeblocksProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Unknown';
    }
  }

  String _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeStr;
    }
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) {
      return const Color(0xFF0D9488);
    }
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF0D9488);
    }
  }

  String _calculateDuration(String startTime, String endTime) {
    try {
      final startParts = startTime.split(' ');
      final endParts = endTime.split(' ');
      
      final startTimeParts = startParts[0].split(':');
      final endTimeParts = endParts[0].split(':');
      
      int startHour = int.parse(startTimeParts[0]);
      int startMinute = int.parse(startTimeParts[1]);
      int endHour = int.parse(endTimeParts[0]);
      int endMinute = int.parse(endTimeParts[1]);
      
      // Convert to 24-hour format
      if (startParts[1] == 'PM' && startHour != 12) startHour += 12;
      if (startParts[1] == 'AM' && startHour == 12) startHour = 0;
      if (endParts[1] == 'PM' && endHour != 12) endHour += 12;
      if (endParts[1] == 'AM' && endHour == 12) endHour = 0;
      
      final startMinutes = startHour * 60 + startMinute;
      final endMinutes = endHour * 60 + endMinute;
      final durationMinutes = endMinutes - startMinutes;
      
      if (durationMinutes <= 0) return '0min';
      
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      
      if (hours > 0 && minutes > 0) {
        return '${hours}h ${minutes}m';
      } else if (hours > 0) {
        return '${hours}h';
      } else {
        return '${minutes}m';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _navigateToCreateTimeblock({int? dayOfWeek}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditTimeblockScreen(),
      ),
    );
  }

  void _navigateToEditTimeblock(String timeblockId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditTimeblockScreen(timeblockId: timeblockId),
      ),
    );
  }

  void _handleTimeblockAction(String action, TimeblockModel timeblock, TimeblockNotifier notifier) {
    switch (action) {
      case 'edit':
        _navigateToEditTimeblock(timeblock.id);
        break;
      case 'duplicate':
        _duplicateTimeblock(timeblock, notifier);
        break;
      case 'delete':
        _deleteTimeblock(timeblock, notifier);
        break;
    }
  }

  void _duplicateTimeblock(TimeblockModel timeblock, TimeblockNotifier notifier) {
    final duplicated = timeblock.copyWith(
      id: '', // Will be generated
      title: '${timeblock.title ?? 'Timeblock'} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    notifier.createTimeblock(duplicated).then((_) {
      if (!mounted) return; // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timeblock duplicated successfully'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
    }).catchError((error) {
      if (!mounted) return; // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to duplicate timeblock: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _deleteTimeblock(TimeblockModel timeblock, TimeblockNotifier notifier) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog( // Use dialogContext for clarity
        title: const Text('Delete Timeblock'),
        content: Text(
          'Are you sure you want to delete "${timeblock.title ?? 'this timeblock'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (!mounted) return; // Add mounted check
              notifier.deleteTimeblock(timeblock.id).then((_) {
                if (!mounted) return; // Add mounted check
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timeblock deleted successfully'),
                    backgroundColor: Color(0xFF0D9488),
                  ),
                );
              }).catchError((error) {
                if (!mounted) return; // Add mounted check
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete timeblock: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
