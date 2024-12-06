import 'package:flutter/material.dart';
import 'package:nutrichild/ui/HomePage.dart';
import 'package:nutrichild/ui/LoginPage.dart';
import 'package:nutrichild/ui/RegisterPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Homepage.routeName,
      routes: {
        Homepage.routeName: (context) => const Homepage(),
        Loginpage.routeName: (context) => const Loginpage(),
        Registerpage.routeName: (context) => const Registerpage(),
      },
    );
  }
}
