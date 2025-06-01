import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/timeblock_providers.dart';
import 'package:vuet_app/ui/screens/timeblocks/create_edit_timeblock_screen.dart';

class TimeblockDetailScreen extends ConsumerWidget {
  final String timeblockId;

  const TimeblockDetailScreen({
    super.key,
    required this.timeblockId,
  });

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

  Color _parseHexColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue; // Default color
    }
    
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      return Color(int.parse("0xFF$hexColor"));
    }
    return Colors.blue; // Fallback
  }

  String _formatTime(String timeStr) {
    // Convert HH:mm:ss to more readable format
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      
      // Convert to 12-hour format
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      
      return '$hour:$minute $period';
    }
    return timeStr;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Timeblock'),
          content: const Text('Are you sure you want to delete this timeblock?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(timeblockRepositoryProvider).deleteTimeblock(timeblockId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Timeblock deleted')),
        );
        Navigator.of(context).pop(); // Go back after delete
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeblockAsyncValue = ref.watch(timeblockByIdProvider(timeblockId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Timeblock Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151), // Explicit dark color
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151), // Explicit foreground color
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              if (timeblockAsyncValue.hasValue && timeblockAsyncValue.value != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateEditTimeblockScreen(
                      timeblockId: timeblockAsyncValue.value!.id,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF374151),
            ),
            tooltip: 'Edit Timeblock',
          ),
          IconButton(
            onPressed: () => _confirmDelete(context, ref),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            tooltip: 'Delete Timeblock',
          ),
        ],
      ),
      body: timeblockAsyncValue.when(
        data: (timeblock) {
          if (timeblock == null) {
            return const Center(
              child: Text('Timeblock not found'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with color bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _parseHexColor(timeblock.color),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeblock.title ?? 'Untitled Timeblock',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getDayName(timeblock.dayOfWeek),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Time Section
                const Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 28),
                        const SizedBox(width: 16),
                        Text(
                          '${_formatTime(timeblock.startTime)} - ${_formatTime(timeblock.endTime)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (timeblock.description != null && timeblock.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  
                  // Description Section
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        timeblock.description!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Recurrence Info
                const Text(
                  'Recurrence',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.repeat, size: 28),
                        SizedBox(width: 16),
                        Text(
                          'Weekly',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateEditTimeblockScreen(
                              timeblockId: timeblockId,
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _confirmDelete(context, ref);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
