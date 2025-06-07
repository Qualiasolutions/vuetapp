import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Transport Category Screen - Shows all Transport entity types
/// As specified in detailed guide: Car, PublicTransport, TrainBusFerry, RentalCar
class TransportCategoryScreen extends StatelessWidget {
  const TransportCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Transport'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _TransportEntityTile(
            title: 'Cars',
            icon: Icons.directions_car,
            description: 'Manage your cars',
            onTap: () => context.go('/categories/transport/cars'),
          ),
          _TransportEntityTile(
            title: 'Public Transport',
            icon: Icons.train,
            description: 'Track public transport',
            onTap: () => context.go('/categories/transport/public'),
          ),
          _TransportEntityTile(
            title: 'Train/Bus/Ferry',
            icon: Icons.directions_transit,
            description: 'Long distance travel',
            onTap: () => context.go('/categories/transport/transit'),
          ),
          _TransportEntityTile(
            title: 'Rental Cars',
            icon: Icons.car_rental,
            description: 'Rental vehicles',
            onTap: () => context.go('/categories/transport/rentals'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Transport Item',
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
              'Add Transport Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.directions_car, color: AppColors.orange),
              title: const Text('Car'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/transport/cars/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.train, color: AppColors.orange),
              title: const Text('Public Transport'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/transport/public/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_transit, color: AppColors.orange),
              title: const Text('Train/Bus/Ferry'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/transport/transit/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_rental, color: AppColors.orange),
              title: const Text('Rental Car'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/transport/rentals/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportEntityTile extends StatelessWidget {
  const _TransportEntityTile({
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
