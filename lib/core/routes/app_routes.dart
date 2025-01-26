import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrichild/features/splash/presentation/pages/splash_page.dart';
import 'package:nutrichild/features/auth/presentation/pages/login_page.dart';
import 'package:nutrichild/features/auth/presentation/pages/register_page.dart';
import 'package:nutrichild/features/auth/presentation/pages/reset_password_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';

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
        path: changePassword,
        name: changePassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ResetPasswordPage(isFromLogin: false);
        },
      ),
    ],
  );

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      resetPassword: (context) => const ResetPasswordPage(isFromLogin: true),
      changePassword: (context) => const ResetPasswordPage(isFromLogin: false),
    };
  }
}
