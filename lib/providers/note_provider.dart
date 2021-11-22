import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_apartments_finder/models/note.dart';
import 'package:rental_apartments_finder/services/sqlite_note_service.dart';

class NoteProvider with ChangeNotifier {
  List<Note> notesList = [];

  Future<List<Note>> getAllNotes() async {
    notesList = (await SqliteNoteService.getAllNotes()).map((record) {
      return Note.fromMap(record);
    }).toList();

    notesList.forEach((note) {
      print(note);
    });

    notifyListeners();
    return notesList;
  }

  Note? getNoteById(int id) {
    return notesList.firstWhere((note) => note.id == id);
  }

  Future addOrUpdateNote(Note note) async {
    if (notesList.indexWhere((e) => e.id == note.id) != -1) {
      notesList[notesList.indexWhere((e) => e.id == note.id)] = note;
      await SqliteNoteService.updateNote(note);
    } else {
      notesList.add(note);
      await SqliteNoteService.insert(note);
    }
    notifyListeners();
  }

  Future deleteNote(Note note) async {
    notesList.remove(note);
    await SqliteNoteService.deleteNote(note.id!);
    notifyListeners();
  }

  Future deleteAllNotes() async {
    await SqliteNoteService.deleteAllNotes();
    notesList.clear();
    notifyListeners();
  }
}
