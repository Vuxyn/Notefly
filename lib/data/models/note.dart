import 'package:hive/hive.dart';

part 'note.g.dart';

/// Note data model persisted via Hive.
@HiveType(typeId: 0)
class Note extends HiveObject {
  /// Unique identifier for this note.
  @HiveField(0)
  final String id;

  /// Text content of the note.
  @HiveField(1)
  final String content;

  /// Whether the note has been completed.
  @HiveField(2)
  final bool isDone;

  /// Timestamp when the note was created.
  @HiveField(3)
  final DateTime createdAt;

  Note({
    required this.id,
    required this.content,
    required this.isDone,
    required this.createdAt,
  });

  /// Returns a copy of this note with the given fields
  /// replaced with new values.
  Note copyWith({
    String? id,
    String? content,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
