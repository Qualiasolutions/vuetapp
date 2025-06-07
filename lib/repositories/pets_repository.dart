import 'package:vuet_app/models/pets_model.dart';

abstract class PetsRepository {
  Future<Pet> createPet(Pet pet);
  Future<Pet?> getPet(String petId);
  Future<List<Pet>> listPetsByUserId(String userId);
  Future<Pet> updatePet(Pet pet);
  Future<void> deletePet(String petId);
}

abstract class PetAppointmentsRepository {
  Future<PetAppointment> createPetAppointment(PetAppointment appointment);
  Future<PetAppointment?> getPetAppointment(String appointmentId);
  Future<List<PetAppointment>> listPetAppointmentsByPetId(String petId);
  Future<List<PetAppointment>> listPetAppointmentsByUserId(String userId);
  Future<PetAppointment> updatePetAppointment(PetAppointment appointment);
  Future<void> deletePetAppointment(String appointmentId);
}
