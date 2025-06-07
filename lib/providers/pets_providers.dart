import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Unused import
import 'package:vuet_app/models/pets_model.dart';
import 'package:vuet_app/repositories/pets_repository.dart';
import 'package:vuet_app/repositories/supabase_pets_repository.dart';

// Provider for SupabasePetsRepository
final supabasePetsRepositoryProvider = Provider<SupabasePetsRepository>((ref) {
  return SupabasePetsRepository(ref); // Pass ref to the constructor
});

// Provider for SupabasePetAppointmentsRepository
final supabasePetAppointmentsRepositoryProvider = Provider<SupabasePetAppointmentsRepository>((ref) {
  return SupabasePetAppointmentsRepository(ref); // Pass ref to the constructor
});

// Provider to list all pets for a given user ID
final petsByUserIdProvider = FutureProvider.family<List<Pet>, String>((ref, userId) async {
  final petsRepository = ref.watch(supabasePetsRepositoryProvider);
  return petsRepository.listPetsByUserId(userId);
});

// Provider to get a single pet by its ID
final petByIdProvider = FutureProvider.family<Pet?, String>((ref, petId) async {
  final petsRepository = ref.watch(supabasePetsRepositoryProvider);
  return petsRepository.getPet(petId);
});

// Provider to list all appointments for a given pet ID
final petAppointmentsByPetIdProvider = FutureProvider.family<List<PetAppointment>, String>((ref, petId) async {
  final appointmentsRepository = ref.watch(supabasePetAppointmentsRepositoryProvider);
  return appointmentsRepository.listPetAppointmentsByPetId(petId);
});

// Provider to list all appointments for a given user ID
final petAppointmentsByUserIdProvider = FutureProvider.family<List<PetAppointment>, String>((ref, userId) async {
  final appointmentsRepository = ref.watch(supabasePetAppointmentsRepositoryProvider);
  return appointmentsRepository.listPetAppointmentsByUserId(userId);
});

// Provider to get a single pet appointment by its ID
final petAppointmentByIdProvider = FutureProvider.family<PetAppointment?, String>((ref, appointmentId) async {
  final appointmentsRepository = ref.watch(supabasePetAppointmentsRepositoryProvider);
  return appointmentsRepository.getPetAppointment(appointmentId);
});

// Provider for the abstract PetsRepository (can be overridden for testing)
final petsRepositoryProvider = Provider<PetsRepository>((ref) {
  return ref.watch(supabasePetsRepositoryProvider);
});

// Provider for the abstract PetAppointmentsRepository (can be overridden for testing)
final petAppointmentsRepositoryProvider = Provider<PetAppointmentsRepository>((ref) {
  return ref.watch(supabasePetAppointmentsRepositoryProvider);
});
