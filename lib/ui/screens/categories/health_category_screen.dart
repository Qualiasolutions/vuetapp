import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class HealthCategoryScreen extends StatelessWidget {
  const HealthCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Health & Beauty'),
      body: Center(
        child: Text(
          'Health & Beauty Category Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
