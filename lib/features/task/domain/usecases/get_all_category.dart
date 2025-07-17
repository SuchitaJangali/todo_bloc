import 'package:todo_bloc_new/features/task/data/models/category_model.dart';

import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllCategory {
  final TaskRepository repository;

  GetAllCategory(this.repository);

  Future<List<CategoryModel>> call() async {
    return await repository.getAllCategory();
  }
}
