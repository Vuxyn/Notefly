import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:notefly/core/theme.dart';
import 'package:notefly/ui/screens/home_screen.dart'; // Route to floating settings
import 'package:notefly/providers/note_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteController = TextEditingController();

  void _openFloatingSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(0),
        ),
        title: const Text('NEW NOTE', style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'Type your note...',
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _noteController.clear();
              Navigator.pop(context);
            },
            child: const Text('CANCEL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            onPressed: () {
              if (_noteController.text.trim().isNotEmpty) {
                context.read<NoteProvider>().addNote(_noteController.text);
                _noteController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'MY NOTES',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        backgroundColor: AppTheme.primary,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCD34D), // Yellow
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_applications_rounded, color: Colors.black),
              onPressed: _openFloatingSettings,
              tooltip: 'Floating Mode Settings',
            ),
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          final notes = provider.notes;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'NO NOTES YET.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final note = notes[index];
              return Container(
                decoration: BoxDecoration(
                  color: note.isDone ? Colors.grey[300] : Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: AppTheme.brutalShadow,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Checkbox(
                      value: note.isDone,
                      activeColor: AppTheme.primary,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      onChanged: (_) {
                        provider.toggleNoteStatus(note);
                      },
                    ),
                    Expanded(
                      child: Text(
                        note.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: note.isDone ? TextDecoration.lineThrough : null,
                          color: note.isDone ? Colors.grey[700] : Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      color: AppTheme.error,
                      onPressed: () => provider.deleteNote(note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: AppTheme.brutalShadow,
        ),
        child: IconButton(
          icon: const Icon(Icons.add_rounded, color: Colors.black, size: 32),
          onPressed: _addNote,
        ),
      ),
    );
  }
}
