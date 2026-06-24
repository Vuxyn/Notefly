import 'package:flutter/material.dart';

import 'package:notefly/ui/screens/home_screen.dart';

/// The main application widget for Notefly.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notefly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
