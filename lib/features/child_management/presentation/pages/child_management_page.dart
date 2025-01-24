import 'package:flutter/material.dart';

class ChildManagementPage extends StatelessWidget {
  const ChildManagementPage({super.key});

  static const String routeName = '/child_management';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChildManagement'),
      ),
      body: const Center(
        child: Text('ChildManagement Page'),
      ),
    );
  }
}
