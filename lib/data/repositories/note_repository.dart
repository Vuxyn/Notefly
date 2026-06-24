import 'package:hive/hive.dart';

import 'package:notefly/data/models/note.dart';

/// Repository for managing note persistence via Hive.
class NoteRepository {
  final Box<Note> _box;

  /// Creates a [NoteRepository] backed by the given
  /// Hive [box].
  NoteRepository(this._box);

  /// Returns all stored notes, ordered by creation date
  /// (newest first).
  List<Note> getNotes() {
    final notes = _box.values.toList();
    notes.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return notes;
  }

  /// Saves or updates a [note]. Uses the note's [Note.id]
  /// as the Hive key.
  Future<void> saveNote(Note note) async {
    await _box.put(note.id, note);
  }

  /// Deletes the note with the given [id].
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }
}
