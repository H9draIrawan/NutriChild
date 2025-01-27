import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrichild/firebase_options.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';
import 'package:nutrichild/presentation/bloc/child/child_bloc.dart';
import 'package:nutrichild/presentation/bloc/meal/meal_bloc.dart';
import 'package:nutrichild/presentation/bloc/allergy/allergy_bloc.dart';
import 'package:nutrichild/presentation/bloc/allergy/allergy_event.dart';
import 'injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await init();

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Error during initialization: $e');
    debugPrint(stackTrace.toString());
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
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChildBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<MealBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AllergyBloc>()..add(InitAllergyEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: 'NutriChild',
      ),
    );
  }
}
