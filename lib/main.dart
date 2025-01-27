import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrichild/firebase_options.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/presentation/bloc/auth/auth_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan options yang benar
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
