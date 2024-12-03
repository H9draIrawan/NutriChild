import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  static const String routeName = '/login';
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextButton Username
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const TextField(
              decoration: InputDecoration(
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

          // TextButton Password
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const TextField(
              decoration: InputDecoration(
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
            onPressed: () {
              // Add code here
            },
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
