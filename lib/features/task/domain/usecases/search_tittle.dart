import 'package:todo_bloc_new/features/task/data/models/category_model.dart';

import '../entities/task.dart';
import '../repositories/task_repository.dart';

class SearchTittle {
  final TaskRepository repository;

  SearchTittle(this.repository);

  Future<List<Task>> call(String query) async {
    return await repository.searchTasks(query);
  }
}
