import 'package:flutter/src/foundation/annotations.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel(
      priority: task.priority,
      // id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      category: task.category,
      createdAt: task.createdAt,
    );
    await localDataSource.insertTask(taskModel);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<void> updateTaskStatus(int id, bool isCompleted) async {
    await localDataSource.updateTaskStatus(id, isCompleted);
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    return await localDataSource.searchTasksByTitle(query);
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    // TODO: implement getAllCategory
    return await localDataSource.getAllCategory();
  }
}
