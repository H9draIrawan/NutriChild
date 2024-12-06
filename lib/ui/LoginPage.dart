import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  static const String routeName = '/login';
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> login() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        print("Login successful! UID: ${userCredential.user!.uid}");
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
      }
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextButton Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                labelStyle: TextStyle(color: Colors.deepPurple),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // TextButton Password
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.deepPurple),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20),

          // ElevatedButton Login
          ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),

          // TextButton Create Account
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Create Account'),
          ),
        ],
      ),
    ));
  }
}
