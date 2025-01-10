import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/navigation/BottomNavigation.dart';
import 'package:nutrichild/ui/LoginPage.dart';
import 'package:nutrichild/ui/RegisterPage.dart';
import 'package:nutrichild/ui/ResetPasswordPage.dart';
import 'package:nutrichild/ui/WelcomePage.dart';
import 'package:nutrichild/ui/MyGoalPage.dart';
import 'package:nutrichild/ui/EditProfilePage.dart';

import 'bloc/auth/auth_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
          child: const Loginpage(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
          child: const Registerpage(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
          child: const Bottomnavigation(),
        ),
      ],
      child: MaterialApp(
        initialRoute: "/login",
        routes: {
          "/welcome": (context) => const Welcomepage(),
          "/login": (context) => const Loginpage(),
          "/register": (context) => const Registerpage(),
          "/reset-password": (context) => const Resetpasswordpage(),
          "/": (context) => const Bottomnavigation(),
          "/goal": (context) => const MyGoalPage(),
          "/edit-profile": (context) => const EditProfilePage(),
        },
      ),
    );
  }
}
