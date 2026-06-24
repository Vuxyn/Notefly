import 'package:flutter/material.dart';

/// Single note item widget with a checkbox.
class NoteItem extends StatelessWidget {
  const NoteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Note Content'),
    );
  }
}
