import 'package:flutter/material.dart';
import 'package:vuet_app/constants/default_entities.dart'; // Import the new constants
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';

class DefaultEntityListScreen extends StatelessWidget {
  final String categoryName; // e.g., "Pets", "Transport" - Used for title and lookup in defaultGlobalEntities
  final String categoryId;   // The actual ID of the category

  const DefaultEntityListScreen({
    super.key, 
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to find the list of default entities for the given category name.
    final List<String> entities = defaultGlobalEntities[categoryName.toUpperCase()] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select $categoryName Entity'),
      ),
      body: entities.isEmpty
          ? Center(
              child: Text(
                'No default entities defined for "$categoryName".',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: entities.length,
              itemBuilder: (context, index) {
                final entityName = entities[index];
                return ListTile(
                  title: Text(entityName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to the entity creation form with pre-filled category ID and entity name (optional)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEntityScreen(
                          initialCategoryId: categoryId, // Pass the actual category ID
                          // Optionally, you could also pass entityName if CreateEntityScreen can pre-fill the name
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
