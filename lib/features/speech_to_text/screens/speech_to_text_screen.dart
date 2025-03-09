import 'package:flutter/material.dart';

class SpeechToTextScreen extends StatelessWidget {
  const SpeechToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Speech to Text Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
