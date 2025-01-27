import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nutrichild/core/routes/app_routes.dart';

import '../../widgets/splash/splash_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7CB342), // Warna hijau muda
              Color(0xFF558B2F), // Warna hijau tua
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SplashLogo(),
                const SizedBox(height: 24),
                Text(
                  'NutriChild',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Nutrition for your child',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
