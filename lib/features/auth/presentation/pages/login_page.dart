import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/auth_illustration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: const [
                  SizedBox(height: 40),
                  LoginHeader(),
                  SizedBox(height: 24),
                  LoginForm(),
                ],
              ),
            ),
            const AuthIllustration(),
          ],
        ),
      ),
    );
  }
}
