import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class GardenCategoryScreen extends StatelessWidget {
  const GardenCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Garden'),
      body: Center(
        child: Text(
          'Garden Category Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
