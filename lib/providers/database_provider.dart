import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseProvider with ChangeNotifier {
  sql.Database db;

  DatabaseProvider() {
    // this will run when provider is instantiate the first time
    init();
  }

  void init() async {
    final dbPath = await sql.getDatabasesPath();
    db = await sql.openDatabase(
      path.join(dbPath, 'ThePCOSProtocol.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Question ("
            "id INTEGER PRIMARY KEY,"
            "reference TEXT,"
            "questionType TEXT,"
            "question TEXT,"
            "answer TEXT,"
            "tags TEXT"
            ")");
      },
      version: 1,
    );
    // the init function is async so it won't block the main thread
    // notify provider that depends on it when done
    notifyListeners();
  }

  Future<void> insert(String table, Map<String, Object> data) async {
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    return await db.query(table);
  }

  Future<void> deleteAll(String table) async {
    db.delete(table);
  }
}
