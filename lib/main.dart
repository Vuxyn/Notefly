import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:notefly/app.dart';
import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';
import 'package:notefly/data/repositories/note_repository.dart';
import 'package:notefly/providers/note_provider.dart';
import 'package:notefly/overlay/floating_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  final box = await Hive.openBox<Note>(AppConstants.noteBoxName);

  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(NoteRepository(box), box),
      child: App(isFirstTime: isFirstTime),
    ),
  );
}

/// Separate entry point for the overlay window.
///
/// This function is called by the Android OS when the
/// overlay service starts. It runs in its own Flutter
/// engine, independent of [main].
@pragma('vm:entry-point')
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NoteAdapter());
  }
  final box = await Hive.openBox<Note>(AppConstants.noteBoxName);

  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(NoteRepository(box), box),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FloatingBubble(),
      ),
    ),
  );
}
