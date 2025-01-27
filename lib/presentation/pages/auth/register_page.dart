import 'package:flutter/material.dart';
import '../../widgets/auth/register_form.dart';
import '../../widgets/auth/register_header.dart';
import '../../widgets/auth/auth_illustration.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  RegisterHeader(),
                  SizedBox(height: 24),
                  RegisterForm(),
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
