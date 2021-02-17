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
        await db.execute("CREATE TABLE KnowledgeBase ("
            "id INTEGER PRIMARY KEY,"
            "reference TEXT,"
            "question TEXT,"
            "answer TEXT,"
            "tags TEXT,"
            "isFavorite INTEGER"
            ")");
        await db.execute("CREATE TABLE FrequentlyAskedQuestions ("
            "id INTEGER PRIMARY KEY,"
            "reference TEXT,"
            "question TEXT,"
            "answer TEXT,"
            "tags TEXT,"
            "isFavorite INTEGER"
            ")");
        await db.execute("CREATE TABLE CourseQuestion ("
            "id INTEGER PRIMARY KEY,"
            "reference TEXT,"
            "question TEXT,"
            "answer TEXT,"
            "tags TEXT,"
            "isFavorite INTEGER"
            ")");
        await db.execute("CREATE TABLE Recipe ("
            "recipeId INTEGER PRIMARY KEY,"
            "title TEXT,"
            "description TEXT,"
            "thumbnail TEXT,"
            "ingredients TEXT,"
            "method TEXT,"
            "tips TEXT,"
            "tags TEXT,"
            "difficulty INTEGER,"
            "servings INTEGER,"
            "duration INTEGER,"
            "isFavorite INTEGER"
            ")");
        await db.execute("CREATE TABLE Message ("
            "id INTEGER PRIMARY KEY,"
            "notificationId INTEGER,"
            "title TEXT,"
            "message TEXT,"
            "isRead INTEGER,"
            "action TEXT,"
            "dateReadUTC TEXT,"
            "dateCreatedUTC TEXT"
            ")");
      },
      version: 1,
    );
    // the init function is async so it won't block the main thread
    // notify provider that depends on it when done
    notifyListeners();
  }

  Future<void> insert(
      final String table, final Map<String, Object> data) async {
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(final String table) async {
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getDataQuery(
      final String table, final String where) async {
    return await db.rawQuery("SELECT * FROM $table $where");
  }

  Future<int> getTableRowCount(final String table) async {
    return sql.Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<void> deleteAll(final String table) async {
    db.delete(table);
  }

  Future<void> updateQuery({
    final String table,
    final String setFields,
    final String whereClause,
    final int limitRowCount,
  }) async {
    String updateStatement = "UPDATE $table SET $setFields WHERE $whereClause";
    //if (limitRowCount > 0) updateStatement += " LIMIT $limitRowCount";
    debugPrint("*******UPDATE STATEMENT = $updateStatement");
    await db.rawQuery(updateStatement);
  }
}
