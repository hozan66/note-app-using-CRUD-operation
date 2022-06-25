import 'package:crud_app/models/note.dart';
import 'package:crud_app/models/note_manipulation.dart';
import 'package:crud_app/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  const NoteModify({Key? key, required this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != '0';
  NotesService get notesService => GetIt.I<NotesService>();
  String? errorMessage;
  Note? note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing == true) {
      setState(() {
        _isLoading = true;
      });

      // We use widget.noteID cuz it's StatefulWidget
      notesService.getNote(widget.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An Error Occurred';
        }
        note = response.data;
        _titleController.text = note?.noteTitle ?? "Empty noteTitle";
        _contentController.text = note?.noteContent ?? "Empty noteContent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editing Note' : 'Create Note',
            style: const TextStyle(fontSize: 24.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Note Title',
                      // hintText: 'Note Title',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3.0, color: Colors.amber),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3.0, color: Colors.green),
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Note Content',
                      // hintText: 'Note Content',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3.0, color: Colors.amber),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3.0, color: Colors.green),
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Update note in API
                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.updateNote(
                                widget.noteID, note);

                            setState(() {
                              _isLoading = false;
                            });

                            const title = 'Done!';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occurred')
                                : 'Your note was updated';

                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(title),
                                  content: Text(text),
                                  actions: [
                                    TextButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((_) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            // Create note in API
                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.createNote(note);

                            setState(() {
                              _isLoading = false;
                            });

                            const title = 'Done!';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occurred')
                                : 'Your note was created';

                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(title),
                                  content: Text(text),
                                  actions: [
                                    TextButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((_) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }

                          // Navigator.of(context).pop();
                        },
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 18.0))),
                  )
                ],
              ),
      ),
    );
  }
}
