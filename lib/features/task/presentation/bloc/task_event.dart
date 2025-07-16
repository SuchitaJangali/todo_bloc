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
