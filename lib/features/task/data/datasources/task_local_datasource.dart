import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> insertTask(TaskModel task);
  Future<List<TaskModel>> getAllTasks();
  Future<void> updateTaskStatus(int id, bool isCompleted);
  Future<List<TaskModel>> searchTasksByTitle(String query);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_db.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
  //jsut deafult categeru

  final List<Map<String, dynamic>> defaultCategories = [
    {
      'id': 1,
      'name': 'Grocery',
      'color': 0xFFB2FF59,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg"
    },
    {
      'id': 2,
      'name': 'Work',
      'color': 0xFFFF8A65,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 3,
      'name': 'Sport',
      'color': 0xFF00E676,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 4,
      'name': 'Home',
      'color': 0xFFFF5252,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 5,
      'name': 'University',
      'color': 0xFF448AFF,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 6,
      'name': 'Social',
      'color': 0xFFE040FB,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 7,
      'name': 'Music',
      'color': 0xFFEA80FC,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg",
    },
    {
      'id': 8,
      'name': 'Health',
      'color': 0xFF69F0AE,
      'imagePath':
          "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg"
    },
    {
      'id': 9,
      'name': 'Movie',
      'color': 0xFF40C4FF,
      'imagePath':
          'https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg'
    },
  ];

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY,
      name TEXT,
      color INTEGER,
      imagePath TEXT
    )
  ''');
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
          categoryId INTEGER,
        description TEXT,
        isCompleted INTEGER,
       createdAt TEXT ,
  FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');
    for (final category in defaultCategories) {
      await db.insert('categories', category);
    }
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final result = await db.rawQuery('''
  SELECT t.id, t.title, t.description, t.isCompleted, 
  t.createdAt as created_at,
         c.id as category_id, c.name as category_name, c.color as category_color, c.imagePath as category_imagePath
  FROM tasks t
  LEFT JOIN categories c ON t.categoryId = c.id
''');

    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateTaskStatus(int id, bool isCompleted) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<TaskModel>> searchTasksByTitle(String query) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }
}
