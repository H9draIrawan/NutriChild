import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/bloc/auth/auth_bloc.dart';
import 'package:nutrichild/bloc/auth/auth_event.dart';
import 'package:nutrichild/bloc/auth/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final bool isFromLogin;
  const ResetPasswordPage({super.key, this.isFromLogin = false});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isFromLogin ? 'Forgot Password' : 'Change Password',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset email sent!')),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isFromLogin) ...[
                  // Form untuk Forgot Password
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is LoadingAuthState
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    ResetPasswordEvent(
                                        emailController.text.trim()),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is LoadingAuthState
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ] else ...[
                  // Form untuk Change Password
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      hintText: 'Enter your current password',
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter your new password',
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is LoadingAuthState
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    ChangePasswordEvent(
                                      currentPassword:
                                          currentPasswordController.text.trim(),
                                      newPassword:
                                          newPasswordController.text.trim(),
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is LoadingAuthState
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
