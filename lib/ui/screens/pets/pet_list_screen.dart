import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/providers/pets_providers.dart';
import 'package:vuet_app/services/auth_service.dart'; // For current user ID
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader, VuetFAB
import 'package:vuet_app/utils/logger.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdAsyncValue = ref.watch(authServiceProvider.select((auth) => auth.currentUser?.id));

    return Scaffold(
      appBar: const VuetHeader('My Pets'),
      body: userIdAsyncValue == null
          ? const Center(child: Text('User not authenticated.'))
          : Consumer(
              builder: (context, ref, child) {
                final userId = userIdAsyncValue;
                if (userId == null || userId.isEmpty) {
                  return const Center(child: Text('User ID not available.'));
                }
                final petsAsyncValue = ref.watch(petsByUserIdProvider(userId));

                return petsAsyncValue.when(
                  data: (pets) {
                    if (pets.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No pets added yet.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        final IconData petIcon;
                        switch (pet.species) {
                          case PetSpecies.dog:
                            petIcon = Icons.pets; // Material 'pets' icon often depicts a dog or paw
                            break;
                          case PetSpecies.cat:
                            petIcon = Icons.star_border_purple500_outlined; // Placeholder, a more cat-like icon would be better
                            break;
                          case PetSpecies.other:
                          default:
                            petIcon = Icons.question_mark_outlined; // For 'other' or if species is null
                            break;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              petIcon, 
                              color: Theme.of(context).primaryColor
                            ),
                            title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '${pet.species?.toString().split('.').last ?? 'Unknown species'}${pet.dob != null ? ' - Born: ${MaterialLocalizations.of(context).formatShortDate(pet.dob!)}' : ''}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to Pet detail/edit screen
                              context.go('/categories/pets/pets/edit/${pet.id}');
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    log('Error fetching pets: $error', name: 'PetListScreen', error: error, stackTrace: stack);
                    return Center(child: Text('Error loading pets: ${error.toString()}'));
                  },
                );
              },
            ),
      floatingActionButton: VuetFAB(
        onPressed: () {
          context.go('/categories/pets/pets/create');
        },
        tooltip: 'Add New Pet',
      ),
    );
  }
}
