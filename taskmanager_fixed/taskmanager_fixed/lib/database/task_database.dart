import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT,
        priority TEXT,
        dueDate TEXT
      )
    ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> delete(int i) async {}
}
