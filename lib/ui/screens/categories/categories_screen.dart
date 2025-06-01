import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/widgets/top_nav.dart';
import 'package:vuet_app/ui/screens/categories/categories_grid.dart';
import 'package:vuet_app/ui/screens/categories/professional_categories_list.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  bool _isProfessionalMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNav(title: 'Categories'), // Using the existing TopNav widget with a title
      body: Column(
        children: [
          // Toggle for Personal/Professional mode
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Personal',
                  style: TextStyle(
                    fontWeight: !_isProfessionalMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Switch(
                  value: _isProfessionalMode,
                  onChanged: (value) {
                    setState(() {
                      _isProfessionalMode = value;
                    });
                  },
                ),
                Text(
                  'Professional',
                  style: TextStyle(
                    fontWeight: _isProfessionalMode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          // Display either CategoriesGrid or ProfessionalCategoriesList
          Expanded(
            child: _isProfessionalMode
                ? const ProfessionalCategoriesList() // Instantiate the widget
                : const CategoriesGrid(), // Instantiate the widget
          ),
        ],
      ),
    );
  }
}
