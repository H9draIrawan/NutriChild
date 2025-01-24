import 'package:flutter/material.dart';

class MealPlanningPage extends StatelessWidget {
  const MealPlanningPage({super.key});

  static const String routeName = '/meal_planning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealPlanning'),
      ),
      body: const Center(
        child: Text('MealPlanning Page'),
      ),
    );
  }
}
