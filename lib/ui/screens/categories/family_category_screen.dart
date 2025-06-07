import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class FamilyCategoryScreen extends StatelessWidget {
  const FamilyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Family'),
      body: Center(
        child: Text(
          'Family Category Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
