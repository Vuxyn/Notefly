import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:notefly/app.dart';
import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';
import 'package:notefly/overlay/floating_bubble.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>(AppConstants.noteBoxName);

  runApp(const App());
}

/// Separate entry point for the overlay window.
///
/// This function is called by the Android OS when the
/// overlay service starts. It runs in its own Flutter
/// engine, independent of [main].
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingBubble(),
    ),
  );
}
