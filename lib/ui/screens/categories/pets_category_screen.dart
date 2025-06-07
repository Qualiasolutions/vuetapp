import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart'; // No longer directly used for navigation calls
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';
import '../../navigation/pets_navigator.dart'; // Import the PetsNavigator

/// Pets Category Screen - Shows all Pets entity types
/// As specified in detailed guide: Pet, PetAppointment
class PetsCategoryScreen extends StatelessWidget {
  const PetsCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Pets'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _PetsEntityTile(
            title: 'Pets',
            icon: Icons.pets,
            description: 'Manage your pets',
            onTap: () => PetsNavigator.navigateToPetList(context),
          ),
          _PetsEntityTile(
            title: 'Pet Appointments',
            icon: Icons.medical_services,
            description: 'Schedule vet visits',
            onTap: () => PetsNavigator.navigateToPetAppointmentList(context), // No petId for general list
          ),
          _PetsEntityTile(
            title: 'Vets',
            icon: Icons.medical_services_outlined, // Or a more specific vet icon if available
            description: 'Manage veterinary contacts',
            onTap: () => PetsNavigator.navigateToVetList(context),
          ),
          _PetsEntityTile(
            title: 'Pet Groomers',
            icon: Icons.content_cut_outlined, // Or a more specific groomer icon
            description: 'Find and manage groomers',
            onTap: () => PetsNavigator.navigateToGroomerList(context),
          ),
          _PetsEntityTile(
            title: 'Pet Sitters',
            icon: Icons.home_work_outlined, // Or a more specific sitter icon
            description: 'Organize pet sitting',
            onTap: () => PetsNavigator.navigateToSitterList(context),
          ),
          _PetsEntityTile(
            title: 'Pet Walkers',
            icon: Icons.directions_walk_outlined,
            description: 'Manage pet walkers',
            onTap: () => PetsNavigator.navigateToWalkerList(context),
          ),
          _PetsEntityTile(
            title: 'Microchip Companies',
            icon: Icons.memory_outlined,
            description: 'Track microchip info',
            onTap: () => PetsNavigator.navigateToMicrochipCompanyList(context),
          ),
          _PetsEntityTile(
            title: 'Pet Insurance',
            icon: Icons.shield_outlined, // Combined for company & policy
            description: 'Manage pet insurance',
            onTap: () => PetsNavigator.navigateToInsuranceCompanyList(context), // Or a dedicated insurance hub
          ),
          _PetsEntityTile(
            title: 'Pet Birthdays',
            icon: Icons.cake_outlined,
            description: 'Remember pet birthdays',
            onTap: () => PetsNavigator.navigateToPetBirthdayList(context),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Pet Item',
      ),
    );
  }

  static void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Pet Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.pets, color: AppColors.orange),
              title: const Text('Pet'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToPetCreate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services, color: AppColors.orange),
              title: const Text('Pet Appointment'),
              onTap: () {
                Navigator.pop(context);
                // Navigating to create appointment without a specific petId
                // The form screen is expected to handle this (e.g., show a pet selector)
                PetsNavigator.navigateToPetAppointmentCreate(context);
              },
            ),
            const VuetDivider(), // Added by Cline
            ListTile(
              leading: const Icon(Icons.medical_services_outlined, color: AppColors.orange), // Added by Cline
              title: const Text('Vet'), // Added by Cline
              onTap: () { // Added by Cline
                Navigator.pop(context); // Added by Cline
                PetsNavigator.navigateToVetCreate(context); // Added by Cline
              }, // Added by Cline
            ),
            ListTile(
              leading: const Icon(Icons.content_cut_outlined, color: AppColors.orange), // Added by Cline
              title: const Text('Pet Groomer'), // Added by Cline
              onTap: () { // Added by Cline
                Navigator.pop(context); // Added by Cline
                PetsNavigator.navigateToGroomerCreate(context); // Added by Cline
              }, // Added by Cline
            ),
            ListTile(
              leading: const Icon(Icons.home_work_outlined, color: AppColors.orange), // Added by Cline
              title: const Text('Pet Sitter'), // Added by Cline
              onTap: () { // Added by Cline
                Navigator.pop(context); // Added by Cline
                PetsNavigator.navigateToSitterCreate(context); // Added by Cline
              }, // Added by Cline
            ),
            // Further additions by Cline
            ListTile(
              leading: const Icon(Icons.directions_walk_outlined, color: AppColors.orange),
              title: const Text('Pet Walker'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToWalkerCreate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.memory_outlined, color: AppColors.orange),
              title: const Text('Microchip Company'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToMicrochipCompanyCreate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: AppColors.orange),
              title: const Text('Pet Insurance Company'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToInsuranceCompanyCreate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined, color: AppColors.orange),
              title: const Text('Pet Insurance Policy'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToInsurancePolicyCreate(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cake_outlined, color: AppColors.orange),
              title: const Text('Pet Birthday'),
              onTap: () {
                Navigator.pop(context);
                PetsNavigator.navigateToPetBirthdayCreate(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PetsEntityTile extends StatelessWidget {
  const _PetsEntityTile({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VuetCategoryTile(
      title: title,
      icon: icon,
      onTap: onTap,
    );
  }
}
