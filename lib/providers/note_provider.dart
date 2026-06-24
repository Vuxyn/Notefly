import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notefly/data/models/note.dart';
import 'package:notefly/data/repositories/note_repository.dart';

/// Provider for managing Note state and business logic.
class NoteProvider extends ChangeNotifier {
  final NoteRepository _repository;
  final Box<Note> _box;

  NoteProvider(this._repository, this._box) {
    // Listen to Hive box changes (crucial for cross-engine sync)
    _box.listenable().addListener(() {
      notifyListeners();
    });
  }

  List<Note> get notes => _repository.getNotes();

  Future<void> addNote(String content) async {
    if (content.trim().isEmpty) return;
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isDone: false,
      createdAt: DateTime.now(),
    );
    await _repository.saveNote(note);
    // No need to call notifyListeners() here since the box listener will trigger it.
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
  }

  Future<void> toggleNoteStatus(Note note) async {
    final updatedNote = Note(
      id: note.id,
      content: note.content,
      isDone: !note.isDone,
      createdAt: note.createdAt,
    );
    await _repository.saveNote(updatedNote);
  }
}
