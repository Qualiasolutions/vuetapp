import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Travel Category Screen - Shows all Travel entity types
/// As specified in detailed guide: Trip, Flight, HotelOrRental, TaxiOrTransfer, DriveTime
class TravelCategoryScreen extends StatelessWidget {
  const TravelCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Travel'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _TravelEntityTile(
            title: 'Trips',
            icon: Icons.luggage,
            description: 'Plan your trips',
            onTap: () => context.go('/categories/travel/trips'),
          ),
          _TravelEntityTile(
            title: 'Flights',
            icon: Icons.flight,
            description: 'Manage flights',
            onTap: () => context.go('/categories/travel/flights'),
          ),
          _TravelEntityTile(
            title: 'Hotels & Rentals',
            icon: Icons.hotel,
            description: 'Book accommodations',
            onTap: () => context.go('/categories/travel/hotels'),
          ),
          _TravelEntityTile(
            title: 'Taxi & Transfer',
            icon: Icons.local_taxi,
            description: 'Arrange transport',
            onTap: () => context.go('/categories/travel/transfers'),
          ),
          _TravelEntityTile(
            title: 'Drive Time',
            icon: Icons.directions_car,
            description: 'Plan driving',
            onTap: () => context.go('/categories/travel/driving'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Travel Item',
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
              'Add Travel Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.luggage, color: AppColors.orange),
              title: const Text('Trip'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/travel/trips/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.flight, color: AppColors.orange),
              title: const Text('Flight'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/travel/flights/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: AppColors.orange),
              title: const Text('Hotel & Rental'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/travel/hotels/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_taxi, color: AppColors.orange),
              title: const Text('Taxi & Transfer'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/travel/transfers/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: AppColors.orange),
              title: const Text('Drive Time'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/travel/driving/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelEntityTile extends StatelessWidget {
  const _TravelEntityTile({
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
