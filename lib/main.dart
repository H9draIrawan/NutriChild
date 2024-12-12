import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrichild/ui/HomePage.dart';
import 'package:nutrichild/ui/LoginPage.dart';
import 'package:nutrichild/ui/RegisterPage.dart';
import 'package:nutrichild/ui/WelcomePage.dart';

import 'database/database_child.dart';
import 'firebase_options.dart';

void main() async {
  final sqlite = DatabaseChild();
  sqlite.initDB();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: Welcomepage.routeName,
      routes: {
        Welcomepage.routeName: (context) => const Welcomepage(),
        Loginpage.routeName: (context) => const Loginpage(),
        Registerpage.routeName: (context) => const Registerpage(),
        Homepage.routeName: (context) => const Homepage(),
      },
    );
  }
}
