import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  static const routeName = "/home";
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Welcome to Home Page"),
      ),
    );
  }
}
