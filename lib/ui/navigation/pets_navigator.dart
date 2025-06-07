import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/pets/pet_list_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_form_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_appointment_list_screen.dart';
import 'package:vuet_app/ui/screens/pets/pet_appointment_form_screen.dart';
import 'package:vuet_app/ui/screens/categories/pets_category_screen.dart';
import 'package:vuet_app/ui/screens/shared/placeholder_screen.dart'; // Added by Cline

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

  // Paths for Vet screens (Added by Cline)
  static const String vetListPath = 'vets';
  static const String vetCreatePath = 'vets/create';
  static const String vetEditPath = 'vets/edit/:vetId';

  // Paths for PetGroomer screens (Added by Cline)
  static const String groomerListPath = 'groomers';
  static const String groomerCreatePath = 'groomers/create';
  static const String groomerEditPath = 'groomers/edit/:groomerId';

  // Paths for PetSitter screens (Added by Cline)
  static const String sitterListPath = 'sitters';
  static const String sitterCreatePath = 'sitters/create';
  static const String sitterEditPath = 'sitters/edit/:sitterId';

  // Paths for PetWalker screens (Added by Cline)
  static const String walkerListPath = 'walkers';
  static const String walkerCreatePath = 'walkers/create';
  static const String walkerEditPath = 'walkers/edit/:walkerId';

  // Paths for MicrochipCompany screens (Added by Cline)
  static const String microchipCompanyListPath = 'microchip_companies';
  static const String microchipCompanyCreatePath = 'microchip_companies/create';
  static const String microchipCompanyEditPath = 'microchip_companies/edit/:companyId';

  // Paths for InsuranceCompany (Pet) screens (Added by Cline)
  static const String insuranceCompanyListPath = 'insurance_companies';
  static const String insuranceCompanyCreatePath = 'insurance_companies/create';
  static const String insuranceCompanyEditPath = 'insurance_companies/edit/:companyId';

  // Paths for InsurancePolicy (Pet) screens (Added by Cline)
  static const String insurancePolicyListPath = 'insurance_policies';
  static const String insurancePolicyCreatePath = 'insurance_policies/create';
  static const String insurancePolicyEditPath = 'insurance_policies/edit/:policyId';
  
  // Paths for PetBirthday screens (Added by Cline)
  static const String petBirthdayListPath = 'pet_birthdays';
  static const String petBirthdayCreatePath = 'pet_birthdays/create';
  static const String petBirthdayEditPath = 'pet_birthdays/edit/:birthdayId';

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
          // Vet Routes (Added by Cline)
          GoRoute(
            name: 'vetList',
            path: vetListPath, // /categories/pets/vets
            builder: (BuildContext context, GoRouterState state) {
              return const PlaceholderScreen(title: 'Vets');
            },
            routes: [
              GoRoute(
                name: 'vetCreate',
                path: 'create', // /categories/pets/vets/create
                builder: (BuildContext context, GoRouterState state) {
                  return const PlaceholderScreen(title: 'Create Vet');
                },
              ),
              GoRoute(
                name: 'vetEdit',
                path: 'edit/:vetId', // /categories/pets/vets/edit/:vetId
                builder: (BuildContext context, GoRouterState state) {
                  return PlaceholderScreen(title: 'Edit Vet', entityId: state.pathParameters['vetId']);
                },
              ),
            ],
          ),
          // PetGroomer Routes (Added by Cline)
          GoRoute(
            name: 'groomerList',
            path: groomerListPath, // /categories/pets/groomers
            builder: (BuildContext context, GoRouterState state) {
              return const PlaceholderScreen(title: 'Pet Groomers');
            },
            routes: [
              GoRoute(
                name: 'groomerCreate',
                path: 'create', // /categories/pets/groomers/create
                builder: (BuildContext context, GoRouterState state) {
                  return const PlaceholderScreen(title: 'Create Pet Groomer');
                },
              ),
              GoRoute(
                name: 'groomerEdit',
                path: 'edit/:groomerId', // /categories/pets/groomers/edit/:groomerId
                builder: (BuildContext context, GoRouterState state) {
                  return PlaceholderScreen(title: 'Edit Pet Groomer', entityId: state.pathParameters['groomerId']);
                },
              ),
            ],
          ),
          // PetSitter Routes (Added by Cline)
          GoRoute(
            name: 'sitterList',
            path: sitterListPath, // /categories/pets/sitters
            builder: (BuildContext context, GoRouterState state) {
              return const PlaceholderScreen(title: 'Pet Sitters');
            },
            routes: [
              GoRoute(
                name: 'sitterCreate',
                path: 'create', // /categories/pets/sitters/create
                builder: (BuildContext context, GoRouterState state) {
                  return const PlaceholderScreen(title: 'Create Pet Sitter');
                },
              ),
              GoRoute(
                name: 'sitterEdit',
                path: 'edit/:sitterId', // /categories/pets/sitters/edit/:sitterId
                builder: (BuildContext context, GoRouterState state) {
                  return PlaceholderScreen(title: 'Edit Pet Sitter', entityId: state.pathParameters['sitterId']);
                },
              ),
            ],
          ),
          // PetWalker Routes (Added by Cline)
          GoRoute(
            name: 'walkerList',
            path: walkerListPath, // /categories/pets/walkers
            builder: (BuildContext context, GoRouterState state) => const PlaceholderScreen(title: 'Pet Walkers'),
            routes: [
              GoRoute(name: 'walkerCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Pet Walker')),
              GoRoute(name: 'walkerEdit', path: 'edit/:walkerId', builder: (context, state) => PlaceholderScreen(title: 'Edit Pet Walker', entityId: state.pathParameters['walkerId'])),
            ],
          ),
          // MicrochipCompany Routes (Added by Cline)
          GoRoute(
            name: 'microchipCompanyList',
            path: microchipCompanyListPath, // /categories/pets/microchip_companies
            builder: (BuildContext context, GoRouterState state) => const PlaceholderScreen(title: 'Microchip Companies'),
            routes: [
              GoRoute(name: 'microchipCompanyCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Microchip Company')),
              GoRoute(name: 'microchipCompanyEdit', path: 'edit/:companyId', builder: (context, state) => PlaceholderScreen(title: 'Edit Microchip Company', entityId: state.pathParameters['companyId'])),
            ],
          ),
          // InsuranceCompany (Pet) Routes (Added by Cline)
          GoRoute(
            name: 'insuranceCompanyList',
            path: insuranceCompanyListPath, // /categories/pets/insurance_companies
            builder: (BuildContext context, GoRouterState state) => const PlaceholderScreen(title: 'Pet Insurance Companies'),
            routes: [
              GoRoute(name: 'insuranceCompanyCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Pet Insurance Company')),
              GoRoute(name: 'insuranceCompanyEdit', path: 'edit/:companyId', builder: (context, state) => PlaceholderScreen(title: 'Edit Pet Insurance Company', entityId: state.pathParameters['companyId'])),
            ],
          ),
          // InsurancePolicy (Pet) Routes (Added by Cline)
          GoRoute(
            name: 'insurancePolicyList',
            path: insurancePolicyListPath, // /categories/pets/insurance_policies
            builder: (BuildContext context, GoRouterState state) => const PlaceholderScreen(title: 'Pet Insurance Policies'),
            routes: [
              GoRoute(name: 'insurancePolicyCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Pet Insurance Policy')),
              GoRoute(name: 'insurancePolicyEdit', path: 'edit/:policyId', builder: (context, state) => PlaceholderScreen(title: 'Edit Pet Insurance Policy', entityId: state.pathParameters['policyId'])),
            ],
          ),
          // PetBirthday Routes (Added by Cline)
          GoRoute(
            name: 'petBirthdayList',
            path: petBirthdayListPath, // /categories/pets/pet_birthdays
            builder: (BuildContext context, GoRouterState state) => const PlaceholderScreen(title: 'Pet Birthdays'),
            routes: [
              GoRoute(name: 'petBirthdayCreate', path: 'create', builder: (context, state) => const PlaceholderScreen(title: 'Add Pet Birthday')),
              GoRoute(name: 'petBirthdayEdit', path: 'edit/:birthdayId', builder: (context, state) => PlaceholderScreen(title: 'Edit Pet Birthday', entityId: state.pathParameters['birthdayId'])),
            ],
          ),
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

  // Vets (Added by Cline)
  static void navigateToVetList(BuildContext context) {
    context.goNamed('vetList');
  }

  static void navigateToVetCreate(BuildContext context) {
    context.goNamed('vetCreate');
  }

  static void navigateToVetEdit(BuildContext context, String vetId) {
    context.goNamed('vetEdit', pathParameters: {'vetId': vetId});
  }

  // Pet Groomers (Added by Cline)
  static void navigateToGroomerList(BuildContext context) {
    context.goNamed('groomerList');
  }

  static void navigateToGroomerCreate(BuildContext context) {
    context.goNamed('groomerCreate');
  }

  static void navigateToGroomerEdit(BuildContext context, String groomerId) {
    context.goNamed('groomerEdit', pathParameters: {'groomerId': groomerId});
  }

  // Pet Sitters (Added by Cline)
  static void navigateToSitterList(BuildContext context) {
    context.goNamed('sitterList');
  }

  static void navigateToSitterCreate(BuildContext context) {
    context.goNamed('sitterCreate');
  }

  static void navigateToSitterEdit(BuildContext context, String sitterId) {
    context.goNamed('sitterEdit', pathParameters: {'sitterId': sitterId});
  }

  // Pet Walkers (Added by Cline)
  static void navigateToWalkerList(BuildContext context) => context.goNamed('walkerList');
  static void navigateToWalkerCreate(BuildContext context) => context.goNamed('walkerCreate');
  static void navigateToWalkerEdit(BuildContext context, String walkerId) => context.goNamed('walkerEdit', pathParameters: {'walkerId': walkerId});

  // Microchip Companies (Added by Cline)
  static void navigateToMicrochipCompanyList(BuildContext context) => context.goNamed('microchipCompanyList');
  static void navigateToMicrochipCompanyCreate(BuildContext context) => context.goNamed('microchipCompanyCreate');
  static void navigateToMicrochipCompanyEdit(BuildContext context, String companyId) => context.goNamed('microchipCompanyEdit', pathParameters: {'companyId': companyId});

  // Insurance Companies (Pet) (Added by Cline)
  static void navigateToInsuranceCompanyList(BuildContext context) => context.goNamed('insuranceCompanyList');
  static void navigateToInsuranceCompanyCreate(BuildContext context) => context.goNamed('insuranceCompanyCreate');
  static void navigateToInsuranceCompanyEdit(BuildContext context, String companyId) => context.goNamed('insuranceCompanyEdit', pathParameters: {'companyId': companyId});

  // Insurance Policies (Pet) (Added by Cline)
  static void navigateToInsurancePolicyList(BuildContext context) => context.goNamed('insurancePolicyList');
  static void navigateToInsurancePolicyCreate(BuildContext context) => context.goNamed('insurancePolicyCreate');
  static void navigateToInsurancePolicyEdit(BuildContext context, String policyId) => context.goNamed('insurancePolicyEdit', pathParameters: {'policyId': policyId});

  // Pet Birthdays (Added by Cline)
  static void navigateToPetBirthdayList(BuildContext context) => context.goNamed('petBirthdayList');
  static void navigateToPetBirthdayCreate(BuildContext context) => context.goNamed('petBirthdayCreate');
  static void navigateToPetBirthdayEdit(BuildContext context, String birthdayId) => context.goNamed('petBirthdayEdit', pathParameters: {'birthdayId': birthdayId});
  
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
