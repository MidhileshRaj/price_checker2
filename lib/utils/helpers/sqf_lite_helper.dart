import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'images.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE images (id INTEGER PRIMARY KEY, name TEXT, path TEXT)',
        );
      },
    );
  }

  Future<void> insertImage(String name, String path) async {
    final db = await database;
    await db.insert(
      'images',
      {'name': name, 'path': path},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getAllImagePaths() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('images');
    return maps.map((map) => map['path'] as String).toList();
  }

  Future<void> clearImages() async {
    final db = await database;
    await db.delete('images');
  }
}
