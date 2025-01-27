import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrichild/presentation/pages/splash/splash_page.dart';
import 'package:nutrichild/presentation/pages/auth/login_page.dart';
import 'package:nutrichild/presentation/pages/auth/register_page.dart';
import 'package:nutrichild/presentation/pages/auth/reset_password_page.dart';
import 'package:nutrichild/presentation/pages/intro/intro_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String onboarding = '/onboarding';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: login,
        name: login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: register,
        name: register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: resetPassword,
        name: resetPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ResetPasswordPage(isFromLogin: true);
        },
      ),
      GoRoute(
        path: onboarding,
        name: onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return const IntroPage();
        },
      ),
    ],
  );

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      resetPassword: (context) => const ResetPasswordPage(isFromLogin: true),
    };
  }
}
