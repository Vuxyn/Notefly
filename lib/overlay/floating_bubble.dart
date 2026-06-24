import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// Entry point and UI for the floating bubble overlay.
///
/// This widget is rendered in a separate Flutter engine
/// on top of all other apps.
class FloatingBubble extends StatelessWidget {
  const FloatingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () async {
          await FlutterOverlayWindow.shareData(
            'bubble_tapped',
          );
        },
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF1565C0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x401565C0),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.note_alt_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
