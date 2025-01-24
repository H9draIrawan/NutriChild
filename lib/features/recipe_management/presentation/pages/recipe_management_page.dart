import 'package:flutter/material.dart';

class RecipeManagementPage extends StatelessWidget {
  const RecipeManagementPage({super.key});

  static const String routeName = '/recipe_management';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeManagement'),
      ),
      body: const Center(
        child: Text('RecipeManagement Page'),
      ),
    );
  }
}
