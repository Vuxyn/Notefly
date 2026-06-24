import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notefly/core/constants.dart';
import 'package:notefly/data/models/note.dart';
import 'package:notefly/data/repositories/note_repository.dart';

/// Provider for managing Note state and business logic.
class NoteProvider extends ChangeNotifier {
  NoteRepository _repository;
  Box<Note> _box;

  NoteProvider(this._repository, this._box) {
    _box.listenable().addListener(_onBoxChange);

    // Listen for sync events from the other engine
    FlutterOverlayWindow.overlayListener.listen((event) async {
      if (event == 'sync_notes') {
        // Close and reopen the box to fetch the latest data from disk
        if (_box.isOpen) {
          await _box.close();
        }
        _box = await Hive.openBox<Note>(AppConstants.noteBoxName);
        _box.listenable().addListener(_onBoxChange);
        _repository = NoteRepository(_box);
        notifyListeners();
      }
    });
  }

  void _onBoxChange() {
    notifyListeners();
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
    FlutterOverlayWindow.shareData('sync_notes');
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    FlutterOverlayWindow.shareData('sync_notes');
  }

  Future<void> toggleNoteStatus(Note note) async {
    final updatedNote = Note(
      id: note.id,
      content: note.content,
      isDone: !note.isDone,
      createdAt: note.createdAt,
    );
    await _repository.saveNote(updatedNote);
    FlutterOverlayWindow.shareData('sync_notes');
  }
}
