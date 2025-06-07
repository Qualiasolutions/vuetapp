import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/social_interest_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader, VuetFAB
// import 'package:vuet_app/ui/navigation/social_interests_navigator.dart'; // Will be created later

class HobbyListScreen extends ConsumerWidget {
  const HobbyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbiesAsyncValue = ref.watch(userHobbiesProvider);

    return Scaffold(
      appBar: const VuetHeader('Hobbies'),
      body: hobbiesAsyncValue.when(
        data: (hobbies) {
          if (hobbies.isEmpty) {
            return const Center(child: Text('No hobbies yet. Add one!'));
          }
          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, index) {
              final hobby = hobbies[index];
              return ListTile(
                title: Text(hobby.name),
                subtitle: Text(hobby.description ?? 'No description'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () async {
                    // Show confirmation dialog before deleting
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete "${hobby.name}"?'),
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
                        await ref.read(hobbyRepositoryProvider).deleteHobby(hobby.id);
                        ref.invalidate(userHobbiesProvider); // Refresh the list
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${hobby.name}" deleted.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting hobby: $e')),
                        );
                      }
                    }
                  },
                ),
                onTap: () {
                  // SocialInterestsNavigator.navigateToHobbyForm(context, hobbyId: hobby.id); // For editing
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
          // SocialInterestsNavigator.navigateToHobbyForm(context); // For creating
        },
        tooltip: 'Add Hobby',
      ),
    );
  }
}
