import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrichild/core/routes/app_routes.dart';
import 'package:nutrichild/domain/entities/child.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_event.dart';
import '../../bloc/child/child_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('savedEmail') ?? '';
        passwordController.text = prefs.getString('savedPassword') ?? '';

        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          _performLogin();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final childBloc = context.read<ChildBloc>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is LoginAuthState) {
            childBloc.add(
              GetChildEvent(id: state.user.id),
            );

            if (childBloc.state is GetChildState) {
              final children = (childBloc.state as GetChildState).children;

              if (children.isEmpty) {
                context.goNamed(AppRoutes.intro);
              } else {
                context.goNamed(AppRoutes.navigation);
              }
            }
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon:
                  Icon(Icons.mail_outline, color: Colors.grey[400], size: 22),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon:
                  Icon(Icons.lock_outline, color: Colors.grey[400], size: 22),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                  size: 22,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 16),
          _buildRememberMeAndForgotPassword(),
          const SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: rememberMe,
                onChanged: (value) =>
                    setState(() => rememberMe = value ?? false),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 8),
            Text('Remember Me',
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () => context.goNamed(AppRoutes.resetPassword),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            'Forgot password',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: _isLoading ? null : _performLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  Future<void> _performLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', true);
      await prefs.setString('savedEmail', email);
      await prefs.setString('savedPassword', password);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    context.read<AuthBloc>().add(LoginEvent(
          email: email,
          password: password,
        ));
  }

  @override
  void dispose() {
    if (!rememberMe) {
      SharedPreferences.getInstance().then((prefs) => prefs.clear());
    }
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
