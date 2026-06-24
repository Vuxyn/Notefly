import 'package:flutter/material.dart';

import 'package:notefly/core/theme.dart';
import 'package:notefly/ui/screens/onboarding_screen.dart';
import 'package:notefly/ui/screens/notes_screen.dart';

/// The main application widget for Notefly.
class App extends StatelessWidget {
  final bool isFirstTime;
  const App({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notefly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isFirstTime ? const OnboardingScreen() : const NotesScreen(),
    );
  }
}
