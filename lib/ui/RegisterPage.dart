import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatelessWidget {
  static const routeName = "/register";
  const Registerpage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Future<void> register() async {
      try {
        if (passwordController.text != confirmPasswordController.text) {
          throw Exception("Passwords do not match");
        }

        // Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Firestore
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': usernameController.text,
          'email': emailController.text,
          'uid': uid,
        });

        // Navigate to Login Page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        print("Error during registration: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextButton Username
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Username',
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
                prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
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

          // TextButton Confirm Password
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
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

          // ElevatedButton Register
          ElevatedButton(
            onPressed: register,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Register'),
          ),
          const SizedBox(height: 20),

          // TextButton Login
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    ));
  }
}
