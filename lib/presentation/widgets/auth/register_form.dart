import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_event.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import '../../bloc/auth/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is RegisterAuthState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Verification Email'),
                content: const Text(
                  'Verification email has been sent to your email. Please check your email and verify your account before logging in.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.go(AppRoutes.login);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon:
                  Icon(Icons.mail_outline, color: Colors.grey[400], size: 22),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Username',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon:
                  Icon(Icons.person_outline, color: Colors.grey[400], size: 22),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon:
                  Icon(Icons.lock_outline, color: Colors.grey[400], size: 22),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                  size: 22,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _isLoading ? null : _performRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _performRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    // Validasi input
    String? errorMessage;
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      errorMessage = 'Email, password, and username cannot be empty';
    } else if (!email.contains('@')) {
      errorMessage = 'Invalid email format';
    } else if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters long';
    } else if (username.length < 3) {
      errorMessage = 'Username must be at least 3 characters long';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(RegisterEvent(
          email: email,
          username: username,
          password: password,
        ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
