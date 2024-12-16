import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrichild/navigation/BottomNavigation.dart';
import 'package:nutrichild/ui/LoginPage.dart';
import 'package:nutrichild/ui/RegisterPage.dart';
import 'package:nutrichild/ui/ResetPasswordPage.dart';
import 'package:nutrichild/ui/WelcomePage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
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
        Resetpasswordpage.routeName: (context) => const Resetpasswordpage(),
        Bottomnavigation.routeName: (context) => const Bottomnavigation(),
      },
      // home: Checkfetch(),
    );
  }
}
