import '../entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<List<Task>> getAllTasks();
  Future<void> updateTaskStatus(int id, bool isCompleted);
  Future<List<Task>> searchTasks(String query);
}
