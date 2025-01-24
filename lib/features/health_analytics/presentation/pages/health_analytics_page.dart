import 'package:flutter/material.dart';

class HealthAnalyticsPage extends StatelessWidget {
  const HealthAnalyticsPage({super.key});

  static const String routeName = '/health_analytics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthAnalytics'),
      ),
      body: const Center(
        child: Text('HealthAnalytics Page'),
      ),
    );
  }
}
