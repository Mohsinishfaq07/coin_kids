import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_data.db'); // Unified database name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table for storing images
    const String createImagesTableQuery = '''
    CREATE TABLE images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT NOT NULL
    );
  ''';

    // Table for storing user credentials
    const String createCredentialsTableQuery = '''
    CREATE TABLE credentials (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    );
  ''';

    await db.execute(createImagesTableQuery);
    await db.execute(createCredentialsTableQuery);
  }

  Future<int> insertImage(String filePath) async {
    final db = await instance.database;

    final data = {'filePath': filePath};
    return await db.insert('images', data);
  }

  Future<List<Map<String, dynamic>>> fetchAllImages() async {
    final db = await instance.database;
    return await db.query('images');
  }

  Future<void> insertCredentials(String email, String password) async {
    final db = await instance.database;
    final data = {'email': email, 'password': password};
    await db.insert('credentials', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch user credentials
  Future<Map<String, String>?> fetchCredentials() async {
    final db = await instance.database;
    final result = await db.query('credentials', limit: 1);

    if (result.isNotEmpty) {
      return {
        'email': result.first['email'] as String,
        'password': result.first['password'] as String,
      };
    }
    return null;
  }

  // Clear credentials
  Future<void> clearCredentials() async {
    final db = await instance.database;
    await db.delete('credentials');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
