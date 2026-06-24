import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:notefly/core/theme.dart';
import 'package:notefly/providers/note_provider.dart';

class NotesPanelOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const NotesPanelOverlay({super.key, required this.onClose});

  @override
  State<NotesPanelOverlay> createState() => _NotesPanelOverlayState();
}

class _NotesPanelOverlayState extends State<NotesPanelOverlay> {
  final TextEditingController _noteController = TextEditingController();

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      context.read<NoteProvider>().addNote(_noteController.text);
      _noteController.clear();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5), // Semi-transparent overlay background
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: AppTheme.brutalShadow,
                    ),
                    child: const Text(
                      'QUICK NOTES',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: AppTheme.brutalShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Notes List
              Expanded(
                child: Consumer<NoteProvider>(
                  builder: (context, provider, child) {
                    final notes = provider.notes;
                    if (notes.isEmpty) {
                      return const Center(
                        child: Text(
                          'NO NOTES YET.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: note.isDone ? Colors.grey[300] : Colors.white,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: AppTheme.brutalShadow,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              ),
              
              const SizedBox(height: 16),
              
              // Add Note Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: AppTheme.brutalShadow,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          hintText: 'Type a new note...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _addNote(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.black),
                        onPressed: _addNote,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
