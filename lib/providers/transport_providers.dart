import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/transport_repository.dart';
import '../models/transport_entities.dart'; // Added import for models

// Provider for CarRepository
final carRepositoryProvider = Provider<CarRepository>((ref) {
  return SupabaseCarRepository();
});

// Provider for PublicTransportRepository
final publicTransportRepositoryProvider =
    Provider<PublicTransportRepository>((ref) {
  return SupabasePublicTransportRepository();
});

// Provider for TrainBusFerryRepository
final trainBusFerryRepositoryProvider =
    Provider<TrainBusFerryRepository>((ref) {
  return SupabaseTrainBusFerryRepository();
});

// Provider for RentalCarRepository
final rentalCarRepositoryProvider = Provider<RentalCarRepository>((ref) {
  return SupabaseRentalCarRepository();
});

// If you need providers for specific data fetching (e.g., a list of cars),
// you can create FutureProviders or StreamProviders here that use the repositories.
// For example:
final allCarsProvider = FutureProvider<List<Car>>((ref) async {
  final repository = ref.watch(carRepositoryProvider);
  return repository.getAllCars();
});

final allPublicTransportProvider = FutureProvider<List<PublicTransport>>((ref) async {
  final repository = ref.watch(publicTransportRepositoryProvider);
  return repository.getAllPublicTransport();
});

final allTrainBusFerriesProvider = FutureProvider<List<TrainBusFerry>>((ref) async {
  final repository = ref.watch(trainBusFerryRepositoryProvider);
  return repository.getAllTrainBusFerries();
});

final allRentalCarsProvider = FutureProvider<List<RentalCar>>((ref) async {
  final repository = ref.watch(rentalCarRepositoryProvider);
  return repository.getAllRentalCars();
});
