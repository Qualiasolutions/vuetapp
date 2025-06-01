import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/providers/timeblock_providers.dart';
import 'package:vuet_app/ui/screens/timeblocks/create_edit_timeblock_screen.dart';

class TimeblockListScreen extends ConsumerWidget {
  const TimeblockListScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeblocksFuture = ref.watch(currentUserTimeblocksProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timeblocks'),
      ),
      body: timeblocksFuture.when(
        data: (timeblocks) {
          if (timeblocks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No timeblocks yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create recurring weekly timeblocks to\nhelp organize your schedule',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create Timeblock'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateEditTimeblockScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // Group timeblocks by day of week
          final Map<int, List<TimeblockModel>> timeblocksByDay = {};
          for (int i = 1; i <= 7; i++) {
            timeblocksByDay[i] = [];
          }

          for (final timeblock in timeblocks) {
            timeblocksByDay[timeblock.dayOfWeek]!.add(timeblock);
          }

          // Sort timeblocks within each day by start time
          for (final dayTimeblocks in timeblocksByDay.values) {
            dayTimeblocks.sort((a, b) => a.startTime.compareTo(b.startTime));
          }

          return ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              final dayOfWeek = index + 1;
              final dayTimeblocks = timeblocksByDay[dayOfWeek]!;
              
              if (dayTimeblocks.isEmpty) {
                return const SizedBox.shrink(); // Skip days with no timeblocks
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      _getDayName(dayOfWeek),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...dayTimeblocks.map((timeblock) {
                    return Dismissible(
                      key: ValueKey(timeblock.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Timeblock'),
                              content: const Text('Are you sure you want to delete this timeblock?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        ref.read(timeblockRepositoryProvider).deleteTimeblock(timeblock.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Timeblock deleted')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _parseHexColor(timeblock.color).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateEditTimeblockScreen(
                                  timeblockId: timeblock.id,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _parseHexColor(timeblock.color),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeblock.title ?? 'Untitled',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_formatTime(timeblock.startTime)} - ${_formatTime(timeblock.endTime)}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      if (timeblock.description != null && timeblock.description!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            timeblock.description!,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CreateEditTimeblockScreen(
                                          timeblockId: timeblock.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateEditTimeblockScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
