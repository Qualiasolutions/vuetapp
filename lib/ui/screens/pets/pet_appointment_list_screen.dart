import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/providers/pets_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/config/theme_config.dart'; // Import for AppColors
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/services/auth_service.dart'; // For current user ID

class PetAppointmentListScreen extends ConsumerWidget {
  final String? petId; // Can be null if showing all user's pet appointments
  final String? petName; // Optional: for displaying pet's name in title

  const PetAppointmentListScreen({super.key, this.petId, this.petName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authServiceProvider.select((auth) => auth.currentUser?.id));

    if (userId == null) {
      return Scaffold(
        appBar: VuetHeader(petName != null ? '$petName\'s Appointments' : 'Pet Appointments'),
        body: const Center(child: Text('User not authenticated.')),
      );
    }

    final AsyncValue<List<PetAppointment>> appointmentsAsyncValue = petId != null
        ? ref.watch(petAppointmentsByPetIdProvider(petId!))
        : ref.watch(petAppointmentsByUserIdProvider(userId));

    return Scaffold(
      appBar: VuetHeader(petName != null ? '$petName\'s Appointments' : 'All Pet Appointments'),
      body: appointmentsAsyncValue.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    petId != null 
                        ? 'No appointments for ${petName ?? 'this pet'} yet.' 
                        : 'No pet appointments scheduled yet.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey)
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final formattedDate = DateFormat.yMMMd().format(appointment.startDatetime);
              final formattedTime = DateFormat.jm().format(appointment.startDatetime);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event_note, color: AppColors.mediumTurquoise),
                  title: Text(appointment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'On $formattedDate at $formattedTime${appointment.location != null && appointment.location!.isNotEmpty ? '\nLocation: ${appointment.location}' : ''}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to PetAppointment detail/edit screen
                    // Ensure petId is available if needed for the route, or pass appointment.petId
                    context.go('/categories/pets/appointments/edit/${appointment.id}?petId=${appointment.petId}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log('Error fetching pet appointments: $error', name: 'PetAppointmentListScreen', error: error, stackTrace: stack);
          return Center(child: Text('Error loading appointments: ${error.toString()}'));
        },
      ),
      floatingActionButton: VuetFAB(
        onPressed: () {
          // If petId is available, pass it to the create screen
          // Otherwise, the create screen might need a pet selector
          final targetPetId = petId ?? ''; // Handle null petId for general add button
          context.go('/categories/pets/appointments/create?petId=$targetPetId');
        },
        tooltip: 'Add New Appointment',
      ),
    );
  }
}
