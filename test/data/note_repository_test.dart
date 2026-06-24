import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';
import 'package:notefly/data/repositories/note_repository.dart';

void main() {
  late Box<Note> box;
  late NoteRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }

    box = await Hive.openBox<Note>(AppConstants.noteBoxName);
    repository = NoteRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
    await Hive.close();

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('getNotes returns empty list initially', () {
    final notes = repository.getNotes();
    expect(notes, isEmpty);
  });

  test('saveNote adds a note and getNotes retrieves it',
      () async {
    final note = Note(
      id: 'test-1',
      content: 'Buy groceries',
      isDone: false,
      createdAt: DateTime(2026, 6, 24),
    );

    await repository.saveNote(note);

    final notes = repository.getNotes();
    expect(notes.length, 1);
    expect(notes.first.id, 'test-1');
    expect(notes.first.content, 'Buy groceries');
    expect(notes.first.isDone, false);
  });

  test('saveNote updates an existing note', () async {
    final note = Note(
      id: 'test-2',
      content: 'Read a book',
      isDone: false,
      createdAt: DateTime(2026, 6, 24),
    );

    await repository.saveNote(note);

    final updated = note.copyWith(isDone: true);
    await repository.saveNote(updated);

    final notes = repository.getNotes();
    expect(notes.length, 1);
    expect(notes.first.isDone, true);
  });

  test('deleteNote removes a note', () async {
    final note = Note(
      id: 'test-3',
      content: 'Walk the dog',
      isDone: false,
      createdAt: DateTime(2026, 6, 24),
    );

    await repository.saveNote(note);
    expect(repository.getNotes().length, 1);

    await repository.deleteNote('test-3');
    expect(repository.getNotes(), isEmpty);
  });

  test('getNotes returns notes sorted newest first',
      () async {
    final older = Note(
      id: 'old',
      content: 'Older note',
      isDone: false,
      createdAt: DateTime(2026, 1, 1),
    );
    final newer = Note(
      id: 'new',
      content: 'Newer note',
      isDone: false,
      createdAt: DateTime(2026, 6, 24),
    );

    await repository.saveNote(older);
    await repository.saveNote(newer);

    final notes = repository.getNotes();
    expect(notes.length, 2);
    expect(notes.first.id, 'new');
    expect(notes.last.id, 'old');
  });
}
