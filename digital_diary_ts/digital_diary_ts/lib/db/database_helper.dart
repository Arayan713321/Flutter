import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT,
        imagePath TEXT,
        audioPath TEXT
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE diary ADD COLUMN imagePath TEXT");
      await db.execute("ALTER TABLE diary ADD COLUMN audioPath TEXT");
    }
  }

  Future<int> insertEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.insert('diary', entry.toMap());
  }

  Future<List<DiaryEntry>> getEntries() async {
    final db = await database;
    final maps = await db.query('diary', orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return DiaryEntry(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        content: maps[i]['content'] as String,
        date: maps[i]['date'] as String,
        imagePath: maps[i]['imagePath'] as String?,
        audioPath: maps[i]['audioPath'] as String?,
      );
    });
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete('diary', where: 'id = ?', whereArgs: [id]);
  }
}
