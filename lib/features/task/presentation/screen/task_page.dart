import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TaskBloc>().add(const GetAllTasksEvents());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskFailure) {
            return Center(child: Text(state.error));
          } else if (state is TaskSuccess) {
            if (state.tasks?.isEmpty ?? false) {
              return const Center(child: Text('No tasks available.'));
            }

            return ListView.builder(
              itemCount: state.tasks?.length,
              itemBuilder: (context, index) {
                final task = state.tasks?[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(task?.category.color ?? 00000),
                      backgroundImage:
                          AssetImage(task?.category.imagePath ?? ""),
                    ),
                    title: Text(task?.title ?? ""),
                    subtitle: Text(task?.description ?? ""),
                    trailing: IconButton(
                      icon: Icon(
                        task?.isCompleted ?? false
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: task?.isCompleted ?? false
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () {
                        // context.read<TaskBloc>().add(
                        //       UpdateTaskStatusEvent(
                        //         task.id,
                        //         !task.isCompleted,
                        //       ),
                        //     );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Welcome to your task manager!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add task screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
