// import 'dart:io' show Platform;

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nutrichild/bloc/food/food_bloc.dart';
// import 'package:nutrichild/ui/Auth/LoginPage.dart';
// import 'package:nutrichild/ui/Auth/RegisterPage.dart';
// import 'package:nutrichild/ui/Auth/ResetPasswordPage.dart';
// import 'package:nutrichild/ui/Navigation/BottomNavigation.dart';
// import 'package:nutrichild/ui/Profile/EditProfilePage.dart';
// import 'package:nutrichild/ui/Profile/MyGoalPage.dart';
// import 'package:nutrichild/ui/Welcome/WelcomePage.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'bloc/auth/auth_bloc.dart';
// import 'bloc/child/child_bloc.dart';
// import 'database/database_allergy.dart';
// import 'database/database_child.dart';
// import 'database/database_food.dart';
// import 'database/database_meal.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Inisialisasi Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Inisialisasi SQLite untuk platform non-web
//   if (!kIsWeb) {
//     // Inisialisasi untuk Windows/Linux/MacOS
//     if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       sqfliteFfiInit();
//       databaseFactory = databaseFactoryFfi;
//     }

//     // Inisialisasi database
//     final foodSqflite = FoodSqflite();
//     final mealSqflite = MealSqflite();
//     final childSqflite = ChildSqflite();
//     final allergySqflite = AllergySqflite();

//     await foodSqflite.initDB();
//     await mealSqflite.initDB();
//     await childSqflite.initDB();
//     await allergySqflite.initDB();
//   }

//   runApp(
//     const MyApp(),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => ChildBloc(),
//         ),
//         BlocProvider(
//           create: (context) => AuthBloc(),
//         ),
//         BlocProvider(
//           create: (context) => FoodBloc(),
//         ),
//       ],
//       child: MaterialApp(
//         initialRoute: "/login",
//         routes: {
//           "/welcome": (context) => const Welcomepage(),
//           "/login": (context) => const Loginpage(),
//           "/register": (context) => const Registerpage(),
//           "/reset-password": (context) =>
//               const ResetPasswordPage(isFromLogin: true),
//           "/": (context) => const Bottomnavigation(),
//           "/goal": (context) => const MyGoalPage(),
//           "/edit-profile": (context) => const EditProfilePage(),
//         },
//       ),
//     );
//   }
// }

// !: Clean Architecture

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrichild/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
    );
  }
}
