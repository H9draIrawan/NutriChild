import 'package:flutter/material.dart';

class ResetPasswordForm extends StatefulWidget {
  final bool isFromLogin;
  const ResetPasswordForm({super.key, required this.isFromLogin});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _performResetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: Implement reset password logic with bloc
  }

  Future<void> _performChangePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: Implement change password logic with bloc
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFromLogin) {
      return _buildForgotPasswordForm();
    } else {
      return _buildChangePasswordForm();
    }
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSubmitButton(
          onPressed: _performResetPassword,
          text: 'Reset Password',
        ),
      ],
    );
  }

  Widget _buildChangePasswordForm() {
    return Column(
      children: [
        TextField(
          controller: currentPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Current Password',
            hintText: 'Enter your current password',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
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
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSubmitButton(
          onPressed: _performChangePassword,
          text: 'Change Password',
        ),
      ],
    );
  }

  Widget _buildSubmitButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: _isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
} 