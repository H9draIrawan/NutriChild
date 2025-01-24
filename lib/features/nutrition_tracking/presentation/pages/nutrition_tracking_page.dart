import 'package:flutter/material.dart';

class NutritionTrackingPage extends StatelessWidget {
  const NutritionTrackingPage({super.key});

  static const String routeName = '/nutrition_tracking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutritionTracking'),
      ),
      body: const Center(
        child: Text('NutritionTracking Page'),
      ),
    );
  }
}
