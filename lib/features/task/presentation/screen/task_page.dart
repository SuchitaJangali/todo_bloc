import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_new/core/theme/app_color.dart';
import 'package:todo_bloc_new/features/task/presentation/widget/search_widget.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widget/task_card.dart';
import 'add_new_task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Tasks'),
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
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/img/Empty_task.png"),
                      height: 350.0,
                      width: 300.0,
                    ),
                    Text(
                      'What do you want to work today?',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Text('Tap +to add yours tasks'),
                  ],
                ));
              }

              return Column(
                children: [
                  SearchBarWidget(
                    hintText: "Search for Your Tasks....",
                    onChanged: (query) {
                      query.isNotEmpty
                          ? context
                              .read<TaskBloc>()
                              .add(SearchTittleEvent(query))
                          : context.read<TaskBloc>().add(GetAllTasksEvents());
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.tasks?.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks?[index];
                        return TaskCard(task: task);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Welcome to your task manager!'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            context.read<TaskBloc>().add(const GetAllCategoryEvent());
            context.read<TaskBloc>().add(const GetAllTasksEvents());

            Navigator.push(context, AddTaskScreen.route());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Route _createAddTaskRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const AddTaskScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: curved,
          child: child,
        ),
      );
    },
  );
}
