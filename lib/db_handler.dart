import 'package:ass_four/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();
  static final String databaseName = 'tasksDb.db';
  static final String tableName = 'tasks';
  static final String taskIdColumnName = 'id';
  static final String taskNameColumnName = 'name';
  static final String taskIsCompleteColumnName = 'isComplete';

  Database database;
  Future<Database> initDatabase() async {
    if (database == null) {
      return await createDatabase();
    } else {
      return database;
    }
  }

  Future<Database> createDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName);
      Database database =
          await openDatabase(path, version: 1, onCreate: (db, version) {
        db.execute('''CREATE TABLE $tableName(
          $taskIdColumnName INTEGER PRIMARY KEY AUTOINCRMENT ,
          $taskNameColumnName TEXT NOT NULL,
          $taskIsCompleteColumnName INTEGER
        )''');
      });
      return database;
    } on Exception catch (e) {
      print(e);
    }
  }

  insertNewTask(Task task) async {
    try {
      database = await initDatabase();
      int x = await database.insert(tableName, task.toJson());
      print(x);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Map>> selectAllTasks() async {
    try {
      database = await initDatabase();
      List<Map> result = await database.query(tableName);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<Map> selectSpecificTask(String name) async {
    try {
      database = await initDatabase();
      List<Map> result = await database
          .query(tableName, where: '$taskNameColumnName=?', whereArgs: [name]);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  updateTask(Task task) async {
    try {
      database = await initDatabase();
      int result = await database.update(tableName, task.toJson(),
          where: '$taskNameColumnName=?', whereArgs: [task.taskName]);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  deleteTask(Task task) async {
    try {
      database = await initDatabase();
      int result = await database.delete(tableName,
          where: '$taskNameColumnName=?', whereArgs: [task.taskName]);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }
}
