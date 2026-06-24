import 'package:flutter/material.dart';

/// Entry point and UI for the floating bubble overlay.
class FloatingBubble extends StatelessWidget {
  const FloatingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(Icons.note, color: Colors.blue),
      ),
    );
  }
}
