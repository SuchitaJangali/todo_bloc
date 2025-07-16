import 'package:get_it/get_it.dart';
import 'features/task/data/datasources/task_local_datasource.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/task/domain/repositories/task_repository.dart';
import 'features/task/domain/usecases/add_task.dart';
import 'features/task/domain/usecases/get_all_tasks.dart';
import 'features/task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 🔹 Bloc
  sl.registerFactory(() => TaskBloc(addTask: sl(), getAllTasksUseCase: sl()));

  // 🔹 Use cases  // 🔹 Use Cases
  sl.registerLazySingleton(() => AddTask(sl())); // uses repo
  sl.registerLazySingleton(() => GetAllTasks(sl()));

  // 🔹 Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // 🔹 Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );
}
