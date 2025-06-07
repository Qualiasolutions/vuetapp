import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? entityId;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.entityId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VuetHeader(title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Screen - Coming Soon!',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (entityId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Entity ID: $entityId',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
