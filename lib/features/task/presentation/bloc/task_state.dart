import 'package:equatable/equatable.dart';
import 'package:todo_bloc_new/features/task/domain/entities/category.dart';
import 'package:todo_bloc_new/features/task/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<Task>? tasks;
  final List<Category>? category;
  const TaskSuccess({this.tasks, this.category});
}

class TaskFailure extends TaskState {
  final String error;

  const TaskFailure(this.error);

  @override
  List<Object> get props => [error];
}
