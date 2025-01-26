import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrichild/core/routes/app_routes.dart';

import '../widgets/reset_password_form.dart';
import '../widgets/auth_illustration.dart';

class ResetPasswordPage extends StatefulWidget {
  final bool isFromLogin;
  const ResetPasswordPage({super.key, this.isFromLogin = false});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: Text(
          widget.isFromLogin ? 'Forgot Password' : 'Change Password',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ResetPasswordForm(isFromLogin: widget.isFromLogin),
          ),
          const AuthIllustration(),
        ],
      ),
    );
  }
}
