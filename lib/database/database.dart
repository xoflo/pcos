import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  // You probably update the version number if you make DB schema changes
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ThePCOSProtocol.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Question ("
          "id INTEGER PRIMARY KEY,"
          "reference TEXT,"
          "assetType TEXT,"
          "question TEXT,"
          "answer TEXT,"
          "tags TEXT"
          ")");
    });
  }

  newQuestion(Question newQuestion) async {
    final db = await database;
    var res = await db.insert("Question", newQuestion.toMap());
    return res;
  }

  getQuestion(int id) async {
    final db = await database;
    var res = await db.query("Question", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Question.fromMap(res.first) : null;
  }

  Future<List<Question>> getQuestionsByType(final String questionType) async {
    final db = await database;

    print("works");
    var res = await db.query("Question",
        where: "questionType = ? ", whereArgs: [questionType]);

    List<Question> list =
        res.isNotEmpty ? res.map((c) => Question.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    var res = await db.query("Question");
    List<Question> list =
        res.isNotEmpty ? res.map((c) => Question.fromMap(c)).toList() : [];
    return list;
  }

  deleteAllByType(final String questionType) async {
    final db = await database;
    db.delete("Question", where: "questionType = ?", whereArgs: [questionType]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Question");
  }
}
