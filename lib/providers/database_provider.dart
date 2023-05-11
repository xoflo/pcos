import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:thepcosprotocol_app/constants/table_names.dart';

class DatabaseProvider with ChangeNotifier {
  //increment this number whenever the database tables change
  static const DB_VERSION = 7;
  static const DATABASE_NAME = "ThePCOSProtocol.db";
  sql.Database? db;

  DatabaseProvider() {
    // this will run when provider is instantiate the first time
    init();
  }

  Future init() async {
    final dbPath = await sql.getDatabasesPath();
    final fullPath = path.join(dbPath, DATABASE_NAME);

    db = await sql.openDatabase(fullPath);

    if ((await db?.getVersion() ?? 0) < DB_VERSION) {
      //there is a new version of the db so close and delete the old database so you can create the new one
      db?.close();
      await sql.deleteDatabase(fullPath);
      //re-open with the onCreate as the database has changed
      db = await sql.openDatabase(
        fullPath,
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE $TABLE_WIKI ("
              "id INTEGER PRIMARY KEY,"
              "reference TEXT,"
              "question TEXT,"
              "answer TEXT,"
              "tags TEXT,"
              "lessonID INTEGER,"
              "moduleID INTEGER,"
              "isFavorite INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_APP_HELP ("
              "id INTEGER PRIMARY KEY,"
              "reference TEXT,"
              "question TEXT,"
              "answer TEXT,"
              "tags TEXT,"
              "isFavorite INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_COURSE_QUESTION ("
              "id INTEGER PRIMARY KEY,"
              "reference TEXT,"
              "question TEXT,"
              "answer TEXT,"
              "tags TEXT,"
              "isFavorite INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_RECIPE ("
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
          await db.execute("CREATE TABLE $TABLE_WORKOUT ("
              "workoutID INTEGER PRIMARY KEY,"
              "title TEXT,"
              "description TEXT,"
              "tags TEXT,"
              "minsToComplete INTEGER,"
              "orderIndex INTEGER,"
              "imageUrl TEXT,"
              "isFavorite INTEGER,"
              "isComplete INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_WORKOUT_EXERCISE ("
              "exerciseID INTEGER PRIMARY KEY,"
              "workoutID INTEGER,"
              "title TEXT,"
              "description TEXT,"
              "imageUrl TEXT,"
              "mediaUrl TEXT,"
              "equipmentRequired TEXT,"
              "tags TEXT,"
              "setsMinimum INTEGER,"
              "setsMaximum INTEGER,"
              "repsMinimum INTEGER,"
              "repsMaximum INTEGER,"
              "secsBetweenSets INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_MESSAGE ("
              "id INTEGER PRIMARY KEY,"
              "notificationId INTEGER,"
              "title TEXT,"
              "message TEXT,"
              "isRead INTEGER,"
              "action TEXT,"
              "dateReadUTC TEXT,"
              "dateCreatedUTC TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_CMS_TEXT ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "cmsText TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_MODULE ("
              "moduleID INTEGER PRIMARY KEY,"
              "title TEXT,"
              "iconUrl TEXT,"
              "isComplete INTEGER,"
              "orderIndex INTEGER,"
              "dateCreatedUTC TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_LESSON ("
              "lessonID INTEGER,"
              "moduleID INTEGER,"
              "title TEXT,"
              "introduction TEXT,"
              "hoursToNextLesson INTEGER,"
              "hoursUntilAvailable INTEGER,"
              "minsToComplete INTEGER,"
              "imageUrl TEXT,"
              "orderIndex INTEGER,"
              "isFavorite INTEGER,"
              "isComplete INTEGER,"
              "isToolkit INTEGER,"
              "dateCreatedUTC TEXT,"
              "PRIMARY KEY (lessonID, moduleID)"
              ")");
          await db.execute("CREATE TABLE $TABLE_LESSON_CONTENT ("
              "lessonContentID INTEGER PRIMARY KEY,"
              "lessonID INTEGER,"
              "title TEXT,"
              "mediaUrl TEXT,"
              "mediaMimeType TEXT,"
              "body TEXT,"
              "summary TEXT,"
              "orderIndex INTEGER,"
              "dateCreatedUTC TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_LESSON_TASK ("
              "lessonTaskID INTEGER PRIMARY KEY,"
              "lessonID INTEGER,"
              "metaName TEXT,"
              "title TEXT,"
              "description TEXT,"
              "taskType TEXT,"
              "orderIndex INTEGER,"
              "isComplete INTEGER,"
              "dateCreatedUTC TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_LESSON_LINK ("
              "lessonLinkID INTEGER PRIMARY KEY,"
              "lessonID INTEGER,"
              "moduleID INTEGER,"
              "objectID INTEGER,"
              "objectType TEXT,"
              "orderIndex INTEGER,"
              "dateCreatedUTC TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_QUIZ ("
              "quizID INTEGER PRIMARY KEY,"
              "lessonID INTEGER,"
              "title TEXT,"
              "isComplete INTEGER,"
              "description TEXT,"
              "endTitle TEXT,"
              "endMessage TEXT"
              ")");
          await db.execute("CREATE TABLE $TABLE_QUIZ_QUESTION ("
              "quizQuestionID INTEGER PRIMARY KEY,"
              "quizID INTEGER,"
              "questionType TEXT,"
              "questionText TEXT,"
              "response TEXT,"
              "orderIndex INTEGER"
              ")");
          await db.execute("CREATE TABLE $TABLE_QUIZ_ANSWER ("
              "quizAnswerID INTEGER PRIMARY KEY,"
              "quizQuestionID INTEGER,"
              "answerText TEXT,"
              "isCorrect INTEGER,"
              "response TEXT,"
              "orderIndex INTEGER"
              ")");
        },
        version: DB_VERSION,
      );
    }
    // the init function is async so it won't block the main thread
    // notify provider that depends on it when done
    notifyListeners();
  }

  Future<void> insert(
      final String table, final Map<String, Object?> data) async {
    await db?.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>?> getData(
      final String table,
      final String orderByColumn,
      final bool incompleteOnly,
      final bool favouritesOnly,
      final bool toolkitsOnly) async {
    if (orderByColumn.length > 0) {
      if (incompleteOnly) {
        return await db?.query(table,
            orderBy: orderByColumn, where: 'isComplete = 0');
      }
      if (favouritesOnly) {
        return await db?.query(table,
            orderBy: orderByColumn, where: 'isFavorite = 1');
      }
      if (table == TABLE_LESSON && toolkitsOnly) {
        return await db?.query(table,
            orderBy: orderByColumn, where: 'isToolkit = 1 AND isComplete = 1');
      }
      return await db?.query(table, orderBy: orderByColumn);
    }
    if (incompleteOnly) {
      return await db?.query(table, where: 'isComplete = 0');
    }
    if (favouritesOnly) {
      return await db?.query(table, where: 'isFavorite = 1');
    }
    if (table == TABLE_LESSON && toolkitsOnly) {
      return await db?.query(table, where: 'isToolkit = 1 AND isComplete = 1');
    }
    return await db?.query(table);
  }

  Future<List<Map<String, Object?>>?> getDataQuery(
      final String table, final String where) async {
    return await db?.rawQuery("SELECT * FROM $table $where");
  }

  Future<List<Map<String, Object?>>?> getDataQueryWithJoin(final String select,
      final String tablesAndJoin, final String where) async {
    return await db?.rawQuery("SELECT $select FROM $tablesAndJoin $where");
  }

  Future<int?> getTableRowCount(final String table) async {
    return sql.Sqflite.firstIntValue(
        await db?.rawQuery('SELECT COUNT(*) FROM $table') ?? []);
  }

  Future<void> deleteAll(final String table) async {
    db?.delete(table);
  }

  Future<void> updateQuery({
    final String? table,
    final String? setFields,
    final String? whereClause,
    final int? limitRowCount,
  }) async {
    String updateStatement = "UPDATE $table SET $setFields WHERE $whereClause";
    await db?.rawQuery(updateStatement);
  }

  Future<void> deleteQuery({
    final String? table,
    final String? whereClause,
    final int? limitRowCount,
  }) async {
    String deleteStatement = "DELETE FROM $table";
    if ((whereClause ?? "").length > 0) {
      deleteStatement += " WHERE $whereClause";
    }

    await db?.rawQuery(deleteStatement);
  }

  Future<void> deleteAllData() async {
    deleteQuery(table: TABLE_WIKI, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_APP_HELP, whereClause: "", limitRowCount: 0);
    deleteQuery(
        table: TABLE_COURSE_QUESTION, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_RECIPE, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_WORKOUT, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_MESSAGE, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_CMS_TEXT, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_MODULE, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_LESSON, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_LESSON_CONTENT, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_LESSON_TASK, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_LESSON_LINK, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_QUIZ, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_QUIZ_QUESTION, whereClause: "", limitRowCount: 0);
    deleteQuery(table: TABLE_QUIZ_ANSWER, whereClause: "", limitRowCount: 0);
  }
}
