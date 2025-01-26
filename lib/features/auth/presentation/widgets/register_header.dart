import 'package:flutter/material.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Register',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 40),
            const Text(
              'Register',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
