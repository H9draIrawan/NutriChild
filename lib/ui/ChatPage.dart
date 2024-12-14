import 'package:flutter/material.dart';

class Chatpage extends StatelessWidget {
  const Chatpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextButton Chat
            TextButton(
              onPressed: () {
                // Navigate to Chatpage
              },
              child: const Text('Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
