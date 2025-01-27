import 'package:flutter/material.dart';

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -60,
              child: Container(
                width: 500,
                height: 500,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  'assets/images/login_illustration.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/blue.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
