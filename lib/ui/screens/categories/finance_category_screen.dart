import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Finance Category Screen - Shows all Finance entity types
/// As specified in detailed guide: Finance, Subscription
class FinanceCategoryScreen extends StatelessWidget {
  const FinanceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Finance'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _FinanceEntityTile(
            title: 'Finance',
            icon: Icons.account_balance_wallet,
            description: 'Manage finances',
            onTap: () => context.go('/categories/finance/finance'),
          ),
          _FinanceEntityTile(
            title: 'Subscriptions',
            icon: Icons.subscriptions,
            description: 'Track subscriptions',
            onTap: () => context.go('/categories/finance/subscriptions'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Finance Item',
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
              'Add Finance Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: AppColors.orange),
              title: const Text('Finance'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/finance/finance/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions, color: AppColors.orange),
              title: const Text('Subscription'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/finance/subscriptions/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FinanceEntityTile extends StatelessWidget {
  const _FinanceEntityTile({
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
