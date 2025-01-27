import 'package:flutter/material.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: () => context.go(AppRoutes.register),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 