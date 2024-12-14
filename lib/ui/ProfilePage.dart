import 'package:flutter/material.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextButton Profile
            TextButton(
              onPressed: () {
                // Navigate to Profilepage
              },
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
