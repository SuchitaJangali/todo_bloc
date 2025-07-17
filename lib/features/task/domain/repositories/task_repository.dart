import 'package:flutter/foundation.dart';
import 'package:todo_bloc_new/features/task/data/models/category_model.dart';

import '../entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<List<Task>> getAllTasks();
  Future<void> updateTaskStatus(int id, bool isCompleted);
  Future<List<Task>> searchTasks(String query);
  Future<List<CategoryModel>> getAllCategory();
}
