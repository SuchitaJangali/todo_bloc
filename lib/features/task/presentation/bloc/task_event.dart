import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class GetAllTasksEvents extends TaskEvent {
  const GetAllTasksEvents();
}

class GetAllCategoryEvent extends TaskEvent {
  const GetAllCategoryEvent();
}

class SearchTittleEvent extends TaskEvent {
  final String tittle;

  const SearchTittleEvent(this.tittle);
}

class UpdateTaskStatusEvent extends TaskEvent {
  final int id;
  final bool isCompleted;
  const UpdateTaskStatusEvent(this.id, this.isCompleted);
}
