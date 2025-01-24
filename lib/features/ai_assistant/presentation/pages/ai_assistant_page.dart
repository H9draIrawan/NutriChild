import 'package:flutter/material.dart';

class AIAssistantPage extends StatelessWidget {
  const AIAssistantPage({super.key});

  static const String routeName = '/ai_assistant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIAssistant'),
      ),
      body: const Center(
        child: Text('AIAssistant Page'),
      ),
    );
  }
}
