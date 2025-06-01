import 'package:flutter/material.dart';

class PremiumTag extends StatelessWidget {
  const PremiumTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.amber, // Or a specific premium color
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: const Text(
        'PREMIUM',
        style: TextStyle(
          color: Colors.black, // Or a contrasting color
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
