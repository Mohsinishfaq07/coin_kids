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

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB('goals_database.db');
    return _database!;
  }
  Future<int> insertImage(String filePath) async {
    final db = await instance.database;

    final data = {'filePath': filePath};
    return await db.insert('images', data);
  }
  Future<void> insertImageForGoals(String goalId, String imagePath) async {
    final db = await _database;
    await db?.insert('images', {
      'goalId': goalId,
      'imagePath': imagePath,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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
   Future<String?> getSavedEmail() async {
    final db = await instance.database;
    final result = await db.query(
      'credentials',
      columns: ['email'],
      orderBy: 'id DESC', // Get the latest saved email
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['email'] as String?;
    }
    return null; // Return null if no email is found
  }
  Future<List<Map<String, dynamic>>> getImages() async {
  final db = await database;
  return await db.query('images_table'); // Table name adjust karein
}
 Future<String?> getImageByGoalId(String  goalId) async {
    final db = await _db;
    // final result = await db.query(
    //   'goals',
    //   columns: ['image'],
    //   where: 'id = ?',
    //   whereArgs: [goalId],
    // );
     final List<Map<String, dynamic>> result = await db.query(
      'images',
      where: 'goalId = ?',
      whereArgs: [goalId],
    );
    
    if (result.isNotEmpty) {
      return result.first['images'] as String;
    }
    return null; // No image found for this goalId
  }
}
