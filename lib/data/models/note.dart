/// Note data model.
class Note {
  final String id;
  final String content;
  final bool isDone;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.content,
    required this.isDone,
    required this.createdAt,
  });
}
