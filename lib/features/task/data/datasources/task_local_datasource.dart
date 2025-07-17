import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_bloc_new/features/task/data/models/category_model.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> insertTask(TaskModel task);
  Future<List<TaskModel>> getAllTasks();
  Future<void> updateTaskStatus(int id, bool isCompleted);
  Future<List<TaskModel>> searchTasksByTitle(String query);
  Future<List<CategoryModel>> getAllCategory();
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
      'color': 0xFF33691E, // Dark Green
      'imagePath': "assets/img/grocery.png"
    },
    {
      'id': 2,
      'name': 'Work',
      'color': 0xFFBF360C, // Deep Orange
      'imagePath': "assets/img/img.png"
    },
    {
      'id': 3,
      'name': 'Sport',
      'color': 0xFF1B5E20, // Dark Green
      'imagePath': "assets/img/img_7.png"
    },
    {
      'id': 4,
      'name': 'Home',
      'color': 0xFFB71C1C, // Dark Red
      'imagePath': "assets/img/img_1.png"
    },
    {
      'id': 5,
      'name': 'University',
      'color': 0xFF0D47A1, // Dark Blue

      'imagePath': "assets/img/img_2.png"
    },
    {
      'id': 6,
      'name': 'Social',
      'color': 0xFF4A148C, // Deep Purple

      'imagePath': "assets/img/img_3.png"
    },
    {
      'id': 7,
      'name': 'Music',
      'color': 0xFF6A1B9A, // Purple

      'imagePath': "assets/img/img_4.png"
    },
    {
      'id': 8,
      'name': 'Health',
      'color': 0xFF00695C, // Teal Dark

      'imagePath': "assets/img/img_5.png"
    },
    {
      'id': 9,
      'name': 'Movie',
      'color': 0xFF01579B, // Dark Cyan Blue

      'imagePath': "assets/img/img_6.png"
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
 priority INTEGER,
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
  t.createdAt as created_at,t.priority as priority,
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
    final result = await db.rawQuery('''
    SELECT 
      t.id as id, 
      t.title as title, 
      t.description as description, 
      t.isCompleted as isCompleted, 
      t.createdAt as created_at, 
      t.priority as priority,
      c.id as category_id, 
      c.name as category_name, 
      c.color as category_color, 
      c.imagePath as category_imagePath
    FROM tasks t
    LEFT JOIN categories c ON t.categoryId = c.id
    WHERE t.title LIKE ?
  ''', ['%$query%']);

    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final db = await database;
    final result = await db.rawQuery(
        ''' SELECT  c.id as category_id, c.name as category_name, c.color as category_color, c.imagePath as category_imagePath FROM categories c''');
    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
