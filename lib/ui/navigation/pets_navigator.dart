import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/pets/pet_list_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_form_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_appointment_list_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_appointment_form_screen.dart';
import 'package:vuet_app/ui/screens/categories/pets_category_screen.dart';

// TODO: Import PetsCategoryScreen if it's the entry point for '/categories/pets'
// import 'package:vuet_app/ui/screens/categories/pets_category_screen.dart';

/// Navigator for Pets and Pet Appointments screens
class PetsNavigator {
  // Base path for the pets category
  static const String petsCategoryBasePath = '/categories/pets';

  // Paths for Pet screens
  static const String petListPath = 'pets'; // Relative to petsCategoryBasePath
  static const String petCreatePath =
      'pets/create'; // Relative to petsCategoryBasePath
  static const String petEditPath =
      'pets/edit/:petId'; // Relative to petsCategoryBasePath, petId is a path parameter

  // Paths for PetAppointment screens
  // According to task: base is /categories/pets/appointments
  static const String appointmentListPath =
      '$petsCategoryBasePath/appointments'; // Absolute path
  static const String appointmentCreatePath =
      '$appointmentListPath/create'; // Absolute path
  static const String appointmentEditPath =
      '$appointmentListPath/edit/:appointmentId'; // Absolute path, appointmentId is a path parameter

  static List<RouteBase> routes() {
    return [
      // Routes for Pets, nested under /categories/pets if PetsCategoryScreen is the parent
      // If PetsCategoryScreen itself is routed via GoRouter and this is a sub-route:
      GoRoute(
        path: petsCategoryBasePath,
        builder: (context, state) => const PetsCategoryScreen(), // Uncomment if PetsCategoryScreen is the shell
        routes: [
          GoRoute(
            name: 'petList',
            path: petListPath, // Resolves to /categories/pets/pets
            builder: (BuildContext context, GoRouterState state) {
              return const PetListScreen();
            },
            routes: [
              GoRoute(
                name: 'petCreate',
                path: 'create', // Resolves to /categories/pets/pets/create
                builder: (BuildContext context, GoRouterState state) {
                  return const PetFormScreen();
                },
              ),
              GoRoute(
                name: 'petEdit',
                path:
                    'edit/:petId', // Resolves to /categories/pets/pets/edit/:petId
                builder: (BuildContext context, GoRouterState state) {
                  final petId = state.pathParameters['petId'];
                  // TODO: Potentially fetch pet details here if needed or pass petId
                  return PetFormScreen(petId: petId);
                },
              ),
            ],
          ),
          // Routes for Pet Appointments, also under /categories/pets
          // This structure assumes /categories/pets is a common parent for both pets and their appointments.
          // If appointments are truly at /categories/pets/appointments (parallel to /categories/pets/pets),
          // then these routes should not be nested under the GoRoute for petsCategoryBasePath,
          // or the paths need to be adjusted.
          // Sticking to the provided paths from the task description for now.
          // The task implies /categories/pets/appointments is a separate top-level-ish path.
        ],
      ),
      // Standalone routes for Pet Appointments as per task description paths
      GoRoute(
        name: 'petAppointmentList',
        path: appointmentListPath, // /categories/pets/appointments
        builder: (BuildContext context, GoRouterState state) {
          // petId might be passed as an 'extra' or queryParam if needed for filtering
          final petId = state.uri.queryParameters['petId'];
          return PetAppointmentListScreen(petId: petId);
        },
        routes: [
          GoRoute(
            name: 'petAppointmentCreate',
            path: 'create', // /categories/pets/appointments/create
            builder: (BuildContext context, GoRouterState state) {
              final petId = state.uri.queryParameters['petId'];
              if (petId == null) {
                // Handle missing petId, perhaps redirect or show error
                // For now, assume PetAppointmentFormScreen can handle a null petId or show a selector
                return const PetAppointmentFormScreen();
              }
              return PetAppointmentFormScreen(petId: petId);
            },
          ),
          GoRoute(
            name: 'petAppointmentEdit',
            path:
                'edit/:appointmentId', // /categories/pets/appointments/edit/:appointmentId
            builder: (BuildContext context, GoRouterState state) {
              final appointmentId = state.pathParameters['appointmentId'];
              final petId = state.uri.queryParameters['petId'];
              // TODO: Fetch appointment details or pass IDs
              return PetAppointmentFormScreen(
                  appointmentId: appointmentId, petId: petId);
            },
          ),
        ],
      ),
    ];
  }

  // Navigation helper methods

  // Pets
  static void navigateToPetList(BuildContext context) {
    context.goNamed('petList');
    // Or context.go('$petsCategoryBasePath/$petListPath');
  }

  static void navigateToPetCreate(BuildContext context) {
    context.goNamed('petCreate');
    // Or context.go('$petsCategoryBasePath/$petCreatePath');
  }

  static void navigateToPetEdit(BuildContext context, String petId) {
    context.goNamed('petEdit', pathParameters: {'petId': petId});
    // Or context.go('$petsCategoryBasePath/$petEditPath'.replaceFirst(':petId', petId));
  }

  // Pet Appointments
  static void navigateToPetAppointmentList(BuildContext context,
      {String? petId}) {
    final Map<String, String> queryParams = {};
    if (petId != null && petId.isNotEmpty) {
      queryParams['petId'] = petId;
    }
    context.goNamed('petAppointmentList', queryParameters: queryParams);
  }

  static void navigateToPetAppointmentCreate(BuildContext context, {String? petId}) {
    final Map<String, String> queryParams = {};
    if (petId != null && petId.isNotEmpty) {
      queryParams['petId'] = petId;
    }
    context.goNamed('petAppointmentCreate', queryParameters: queryParams);
  }

  static void navigateToPetAppointmentEdit(
      BuildContext context, String appointmentId, {String? petId}) {
    final Map<String, String> queryParams = {};
    if (petId != null && petId.isNotEmpty) {
      queryParams['petId'] = petId;
    }
    context.goNamed('petAppointmentEdit',
        pathParameters: {'appointmentId': appointmentId},
        queryParameters: queryParams);
  }
}
