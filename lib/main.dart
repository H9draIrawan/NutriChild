import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/food/food_bloc.dart';
import 'package:nutrichild/ui/Auth/LoginPage.dart';
import 'package:nutrichild/ui/Auth/RegisterPage.dart';
import 'package:nutrichild/ui/Auth/ResetPasswordPage.dart';
import 'package:nutrichild/ui/Navigation/BottomNavigation.dart';
import 'package:nutrichild/ui/Profile/EditProfilePage.dart';
import 'package:nutrichild/ui/Profile/MyGoalPage.dart';
import 'package:nutrichild/ui/Welcome/WelcomePage.dart';
import 'package:sqflite/sqflite.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/child/child_bloc.dart';
import 'database/database_allergy.dart';
import 'database/database_child.dart';
import 'database/database_food.dart';
import 'database/database_meal.dart';
import 'database/database_initializer.dart';
import 'firebase_options.dart';

void main() async {
  try {
    print("Starting application initialization...");
    WidgetsFlutterBinding.ensureInitialized();

    print("Checking platform compatibility...");
    if (kIsWeb) {
      print("Web platform detected - proceeding with web-only initialization");
    } else {
      print("Native platform detected - initializing SQLite...");
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        print("Desktop platform detected");
      } else if (Platform.isAndroid || Platform.isIOS) {
        print("Mobile platform detected");
      }

      // Initialize SQLite
      print("Starting SQLite initialization...");
      await DatabaseInitializer.initialize();
      print("Testing database connection...");
      await DatabaseInitializer.testConnection();
      print("SQLite initialization completed");

      // Initialize application databases
      print("Initializing application databases...");
      final futures = <Future<Database>>[
        FoodSqflite().initDB(),
        MealSqflite().initDB(),
        ChildSqflite().initDB(),
        AllergySqflite().initDB(),
      ];

      print("Waiting for all databases to initialize...");
      await Future.wait(futures);
      print("All application databases initialized");
    }

    // Initialize Firebase after database setup
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialization completed");

    print("Starting application UI...");
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print("Fatal error during initialization: $e");
    print("Stack trace: $stackTrace");
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChildBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => FoodBloc(),
        ),
      ],
      child: MaterialApp(
        initialRoute: "/login",
        routes: {
          "/welcome": (context) => const Welcomepage(),
          "/login": (context) => const Loginpage(),
          "/register": (context) => const Registerpage(),
          "/reset-password": (context) =>
              const ResetPasswordPage(isFromLogin: true),
          "/": (context) => const Bottomnavigation(),
          "/goal": (context) => const MyGoalPage(),
          "/edit-profile": (context) => const EditProfilePage(),
        },
      ),
    );
  }
}
