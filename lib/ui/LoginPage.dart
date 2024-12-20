import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class Loginpage extends StatefulWidget {
  static const String routeName = '/login';
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isLoading = false;

  Future<void> loadCredentials() async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      if (await firebaseAuth.currentUser?.email != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedAuthState) {
              Navigator.pushReplacementNamed(context, '/');
            } else if (state is ErrorAuthState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")),
              );
            }
            if (state is LoadingAuthState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is LoadedAuthState) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Login/Register tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      suffixIcon: const Icon(Icons.visibility_off),
                    ),
                  ),

                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                          const Text(
                            'Remember password',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/reset-password');
                        },
                        child: const Text(
                          'Forgot password',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _isLoading
                      ? LoadingIndicator(
                          indicatorType: Indicator.circleStrokeSpin,
                          colors: [Colors.green],
                          strokeWidth: 5,
                          backgroundColor: Colors.white,
                          pathBackgroundColor: Colors.white,
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 40),

                  // Bottom illustration
                  Image.asset(
                    'assets/images/login_illustration.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
