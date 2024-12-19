import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Firebase login
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("Login successful! UID: ${userCredential.user!.uid}");
      if (rememberMe) {
        saveUser(emailController.text.trim(), passwordController.text.trim());
      }
      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    } catch (e) {
      print("General exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');
    if (storedEmail != null && storedPassword != null) {
      emailController.text = storedEmail;
      passwordController.text = storedPassword;
      login();
    }
  }

  Future<void> saveUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  ? const SizedBox(
                      width: 50,
                      height: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.circleStrokeSpin,
                        colors: [Colors.green],
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                        pathBackgroundColor: Colors.white,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
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
        ),
      ),
    );
  }
}
