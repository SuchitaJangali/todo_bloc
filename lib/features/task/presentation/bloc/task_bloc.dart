import 'package:todo_bloc_new/features/task/domain/entities/category.dart';
import 'package:todo_bloc_new/features/task/domain/usecases/add_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_new/features/task/domain/usecases/get_all_category.dart';
import 'package:todo_bloc_new/features/task/domain/usecases/get_all_tasks.dart';
import 'package:todo_bloc_new/features/task/domain/usecases/update_task_status.dart';
import '../../domain/usecases/search_tittle.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTask addTask;
  final GetAllTasks getAllTasksUseCase;
  final GetAllCategory getAllCategory;
  final SearchTittle searchTittle;
  final UpdateTaskStatus updateTaskStatus;

  TaskBloc({
    required this.addTask,
    required this.getAllTasksUseCase,
    required this.getAllCategory,
    required this.searchTittle,
    required this.updateTaskStatus,
  }) : super(TaskInitial()) {
    on<AddTaskEvent>(_onAddTask);
    on<GetAllTasksEvents>(_onGetAllTasks);
    on<GetAllCategoryEvent>(_onGetAllCategory);
    on<SearchTittleEvent>(_onSearchTittle);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    print("AddEvent ${event.task.priority}");
    emit(TaskLoading());
    try {
      await addTask(event.task);
      final tasks = await getAllTasksUseCase(); // ⬅️ simple `.call()`
      emit(TaskSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onGetAllTasks(
      GetAllTasksEvents events, Emitter<TaskState> emit) async {
    print("data");
    emit(TaskLoading());
    try {
      final tasks = await getAllTasksUseCase(); // ⬅️ simple `.call()`
      emit(TaskSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onGetAllCategory(
      GetAllCategoryEvent events, Emitter<TaskState> emit) async {
    try {
      final category = await getAllCategory(); // ⬅️ simple `.call()`
      print("DAt0 ${category}");
      emit(TaskSuccess(category: category));
    } catch (e) {}
  }

  Future<void> _onSearchTittle(
      SearchTittleEvent events, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final task = await searchTittle(events.tittle);
      if (state is TaskSuccess) {
        emit(TaskSuccess(
          tasks: task,
          category: (state as TaskSuccess).category, // retain previous category
        ));
      } else {
        emit(TaskSuccess(tasks: task));
      }
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatusEvent events, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateTaskStatus(events.id, events.isCompleted);
      final task = await getAllTasksUseCase(); // ⬅️ simple `.call()`
      print("DAt0 ${task}");
      emit(TaskSuccess(tasks: task));

      print("tasl");
      emit(TaskSuccess());
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
}
