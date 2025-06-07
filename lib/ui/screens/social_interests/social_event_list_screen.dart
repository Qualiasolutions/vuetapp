import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/social_interest_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:vuet_app/ui/navigation/social_interests_navigator.dart';

class SocialEventListScreen extends ConsumerWidget {
  const SocialEventListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialEventsAsyncValue = ref.watch(userSocialEventsProvider);

    return Scaffold(
      appBar: const VuetHeader('Social Events'),
      body: socialEventsAsyncValue.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No social events yet. Add one!'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              String subtitle = DateFormat.yMMMd().add_jm().format(event.startDatetime);
              if (event.locationName != null && event.locationName!.isNotEmpty) {
                subtitle += ' - ${event.locationName}';
              }
              return ListTile(
                title: Text(event.name),
                subtitle: Text(subtitle),
                isThreeLine: event.description != null && event.description!.isNotEmpty,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () async {
                     final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete "${event.name}"?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                            ),
                            TextButton(
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      try {
                        await ref.read(socialEventRepositoryProvider).deleteSocialEvent(event.id);
                        ref.invalidate(userSocialEventsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${event.name}" deleted.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting social event: $e')),
                        );
                      }
                    }
                  },
                ),
                onTap: () {
                  SocialInterestsNavigator.navigateToSocialEventForm(context, eventId: event.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: VuetFAB(
        onPressed: () {
          SocialInterestsNavigator.navigateToSocialEventForm(context);
        },
        tooltip: 'Add Social Event',
      ),
    );
  }
}
