import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _performRegister() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon:
                Icon(Icons.person_outline, color: Colors.grey[400], size: 22),
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
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _isLoading ? null : _performRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
