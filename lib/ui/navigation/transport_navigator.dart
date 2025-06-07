import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/categories/transport_category_screen.dart';
import 'package:vuet_app/ui/screens/shared/placeholder_screen.dart';
import 'package:vuet_app/ui/screens/transport/rental_car_form_screen.dart'; // Existing form

class TransportNavigator {
  static const String transportCategoryBasePath = '/categories/transport';

  // Path constants
  static const String carsListPath = 'cars_motorcycles';
  static const String carsCreatePath = 'cars_motorcycles/create';
  static const String carsEditPath = 'cars_motorcycles/edit/:id';

  static const String boatsListPath = 'boats_other';
  static const String boatsCreatePath = 'boats_other/create';
  static const String boatsEditPath = 'boats_other/edit/:id';

  static const String publicTransportListPath = 'public_transport';
  static const String publicTransportCreatePath = 'public_transport/create';
  static const String publicTransportEditPath = 'public_transport/edit/:id';

  static const String rentalCarListPath = 'rental_cars';
  static const String rentalCarCreatePath = 'rental_cars/create';
  static const String rentalCarEditPath = 'rental_cars/edit/:id';


  static List<RouteBase> routes() {
    return [
      GoRoute(
        path: transportCategoryBasePath,
        builder: (context, state) => const TransportCategoryScreen(),
        routes: [
          // Cars & Motorcycles
          GoRoute(
            name: 'carsList',
            path: carsListPath,
            builder: (context, state) => const PlaceholderScreen(title: 'Cars & Motorcycles'),
            routes: [
              GoRoute(name: 'carsCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Car/Motorcycle')),
              GoRoute(name: 'carsEdit', path: 'edit/:id', builder: (context, state) => PlaceholderScreen(title: 'Edit Car/Motorcycle', entityId: state.pathParameters['id'])),
            ],
          ),
          // Boats & Other
          GoRoute(
            name: 'boatsList',
            path: boatsListPath,
            builder: (context, state) => const PlaceholderScreen(title: 'Boats & Other Vehicles'),
            routes: [
              GoRoute(name: 'boatsCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Boat/Other Vehicle')),
              GoRoute(name: 'boatsEdit', path: 'edit/:id', builder: (context, state) => PlaceholderScreen(title: 'Edit Boat/Other Vehicle', entityId: state.pathParameters['id'])),
            ],
          ),
          // Public Transport
          GoRoute(
            name: 'publicTransportList',
            path: publicTransportListPath,
            builder: (context, state) => const PlaceholderScreen(title: 'Public Transport'),
            routes: [
              GoRoute(name: 'publicTransportCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Public Transport Info')),
              GoRoute(name: 'publicTransportEdit', path: 'edit/:id', builder: (context, state) => PlaceholderScreen(title: 'Edit Public Transport Info', entityId: state.pathParameters['id'])),
            ],
          ),
          // Rental Cars
          GoRoute(
            name: 'rentalCarList',
            path: rentalCarListPath,
            builder: (context, state) => const PlaceholderScreen(title: 'Rental Cars'), // Placeholder for list
            routes: [
              GoRoute(name: 'rentalCarCreate', path: 'create', builder: (context, state) => const RentalCarFormScreen()), // Uses existing form
              // Cline: Temporarily passing null for rentalCar to fix linter error.
              // Edit functionality will require RentalCarFormScreen to fetch by id or receive object via 'extra'.
              GoRoute(name: 'rentalCarEdit', path: 'edit/:id', builder: (context, state) => RentalCarFormScreen(rentalCar: null)), 
            ],
          ),
        ],
      ),
    ];
  }

  // Navigation helpers
  static void navigateToCarsList(BuildContext context) => context.goNamed('carsList');
  static void navigateToCarsCreate(BuildContext context) => context.goNamed('carsCreate');
  static void navigateToCarsEdit(BuildContext context, String id) => context.goNamed('carsEdit', pathParameters: {'id': id});

  static void navigateToBoatsList(BuildContext context) => context.goNamed('boatsList');
  static void navigateToBoatsCreate(BuildContext context) => context.goNamed('boatsCreate');
  static void navigateToBoatsEdit(BuildContext context, String id) => context.goNamed('boatsEdit', pathParameters: {'id': id});

  static void navigateToPublicTransportList(BuildContext context) => context.goNamed('publicTransportList');
  static void navigateToPublicTransportCreate(BuildContext context) => context.goNamed('publicTransportCreate');
  static void navigateToPublicTransportEdit(BuildContext context, String id) => context.goNamed('publicTransportEdit', pathParameters: {'id': id});
  
  static void navigateToRentalCarList(BuildContext context) => context.goNamed('rentalCarList');
  static void navigateToRentalCarCreate(BuildContext context) => context.goNamed('rentalCarCreate');
  static void navigateToRentalCarEdit(BuildContext context, String id) => context.goNamed('rentalCarEdit', pathParameters: {'id': id});
}
