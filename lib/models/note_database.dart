import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/notes.dart';
import 'package:path_provider/path_provider.dart';
class NoteDatabase extends ChangeNotifier{
  
   static late Isar isar; //Isar obj


  // INITIALIZE DATABASE
   static Future<void> initialize() async{ //method for initializing
      final dir = await getApplicationCacheDirectory();
      isar = await Isar.open(
        [NoteSchema],
        directory: dir.path,
      );
   }
  // list of notes

  final List<Note>currentNotes = [];

  //C R E A T E - A NOTE AND SAVE TO DB
  Future<void> addNote(String textFromUser) async{
    // create a new note

    final newNote = Note()..text = textFromUser;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read from db
    fetchNotes();

  }


  //R E A D - NOTES FROM DB
  Future<void> fetchNotes() async{
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // U P D A T E - A NOTE IN DB
  Future<void> updateNotes(int id, String newText) async{
    final existingNote = await isar.notes.get(id);
    if(existingNote != null){ //func for reading if there are any existing notes.
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }


  // D E L E T E - A NOTE FROM DB

  Future<void> deleteNote(int id) async{
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }

}