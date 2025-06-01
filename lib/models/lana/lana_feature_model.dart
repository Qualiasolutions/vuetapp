import 'package:flutter/material.dart';

class LanaFeature {
  final String title;
  final String description;
  final IconData icon;
  final String? tabTarget; // For features that link to a specific tab or section

  LanaFeature({
    required this.title,
    required this.description,
    required this.icon,
    this.tabTarget,
  });
}
