import 'package:todo_bloc_new/features/task/domain/usecases/add_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_new/features/task/domain/usecases/get_all_tasks.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTask addTask;
  final GetAllTasks getAllTasksUseCase;

  TaskBloc({required this.addTask, required this.getAllTasksUseCase})
      : super(TaskInitial()) {
    on<AddTaskEvent>(_onAddTask);
    on<GetAllTasksEvents>(_onGetAllTasks);
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
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
}
