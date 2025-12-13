import 'package:hive_flutter/hive_flutter.dart';

class NotesService {
  final Box notesBox = Hive.box('notesBox');

  List<String> getNotes() {
    return List<String>.from(
      notesBox.get('notes', defaultValue: []),
    );
  }

  void addNote(String note) {
    final notes = getNotes();
    notes.add(note);
    notesBox.put('notes', notes);
  }

  void editNote(int index, String newNote) {
    final notes = getNotes();
    notes[index] = newNote;
    notesBox.put('notes', notes);
  }

  void deleteNote(int index) {
    final notes = getNotes();
    notes.removeAt(index);
    notesBox.put('notes', notes);
  }
}
