import 'package:rental_apartments_finder/models/note.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqflite.dart';

class SqliteNoteService {
  SqliteNoteService();

  static Future<sqlite.Database> getDatabase() async {
    String dbPath = await sqlite.getDatabasesPath();

    return await sqlite.openDatabase(dbPath + '/notes.db', version: 1,
        onCreate: (database, version) async {
      await database.execute(
          'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, imageURL TEXT, referencesProperty TEXT, cleanness INTEGER, stability INTEGER, affordable INTEGER)');
    });
  }

  /* ____________________________________ RETRIEVE ____________________________________ */

  static Future<List<Map<String, Object?>>> getAllNotes() async {
    sqlite.Database database = await SqliteNoteService.getDatabase();

    List<Map<String, Object?>> records =
        await database.query('notes', orderBy: 'id');
    return records;
  }

  /* ____________________________________ INSERT ____________________________________ */

  static Future insert(Note note) async {
    sqlite.Database database = await SqliteNoteService.getDatabase();
    Map<String, Object?> data = note.toMap();
    await database.insert('notes', data,
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

/* ____________________________________ DELETE ____________________________________ */
  static Future deleteAllNotes() async {
    sqlite.Database database = await SqliteNoteService.getDatabase();
    await database.execute("DELETE FROM notes");
  }

  static Future deleteNote(int id) async {
    sqlite.Database database = await SqliteNoteService.getDatabase();
    await database.delete('notes', where: "id = ?", whereArgs: [id]);
  }

  static Future deleteDatabase() async {
    String dbPath = await sqlite.getDatabasesPath();
    await sqlite.deleteDatabase("$dbPath/places.db");
  }

/* ____________________________________ UPDATE ____________________________________ */
  static Future updateNote(Note note) async {
    sqlite.Database database = await SqliteNoteService.getDatabase();
    await database.update('notes', note.toMap(),
        where: "id = ?",
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
