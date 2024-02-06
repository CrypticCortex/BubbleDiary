import 'package:bubblediary/Services/database_service.dart';
import 'package:bubblediary/models/notes.dart';
import 'package:flutter/material.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  final DatabaseService _databaseService;

  NotesProvider(this._databaseService) {
    notesStream();
  }

  List<Note> get notes => List.unmodifiable(_notes);

  void notesStream() {
    _databaseService.notesStream().listen((event) {
      _notes = event;

      notifyListeners();
    });
  }

  void addNote(Note note) {
    _databaseService.addNote(note);
  }

  void deleteAllNotes() {
    _databaseService.deleteAllNotes();
  }

}
