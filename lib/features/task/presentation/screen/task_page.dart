import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_new/features/task/data/models/category_model.dart';
import 'package:todo_bloc_new/features/task/domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widget/task_card.dart';

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
                return TaskCard(task: task);
              },
            );
          } else {
            return const Center(child: Text('Welcome to your task manager!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TaskBloc>().add(AddTaskEvent(Task(
              // id: 1,
              title: "hmeeko",
              description: "tygd",
              isCompleted: false,
              category: CategoryModel(
                  id: 1,
                  name: 'Grocery',
                  color: 0xFFB2FF59,
                  imagePath:
                      "https://thewowstyle.com/wp-content/uploads/2015/01/nature-images..jpg")))); // TODO: Navigate to add task screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
