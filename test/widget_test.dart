import 'package:flutter_test/flutter_test.dart';

import 'package:notefly/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';

void main() {
  setUp(() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }
    await Hive.openBox<Note>(AppConstants.noteBoxName);
  });

  testWidgets('App renders NotesScreen when not first time',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App(isFirstTime: false));

    expect(find.text('MY NOTES'), findsOneWidget);
  });
}
