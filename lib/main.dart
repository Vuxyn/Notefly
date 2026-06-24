import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:notefly/app.dart';
import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>(AppConstants.noteBoxName);

  runApp(const App());
}
