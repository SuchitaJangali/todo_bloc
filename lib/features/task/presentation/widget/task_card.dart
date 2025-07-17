import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc_new/features/task/domain/entities/task.dart';
import 'package:todo_bloc_new/features/task/presentation/bloc/task_event.dart';

import '../bloc/task_bloc.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.black12,
        //ark theme
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  print("task");
                  // Toggle completion
                  if (!(task?.isCompleted ?? false)) {
                    context.read<TaskBloc>().add(UpdateTaskStatusEvent(
                        task?.id ?? 1, !(task?.isCompleted ?? false)));
                  }
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    color: (task?.isCompleted ?? false)
                        ? Colors.green
                        : Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task?.title ?? "",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(task?.createdAt ?? DateTime.now()),
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[400]),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(task?.category.color ?? 0xFF000000)
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        task?.category.imagePath ??
                                            "assets/img/img.png"),
                                    height: 20.0,
                                    width: 20.0,
                                    color: Color(
                                        task?.category.color ?? 0xFF000000),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    task?.category.name ?? "",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.flag_outlined,
                                      size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    "1",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
