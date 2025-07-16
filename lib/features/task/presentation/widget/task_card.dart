import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc_new/features/task/domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              //Chage caompleston
            },
            child: Container(
              height: 10,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  color: (task?.isCompleted ?? false)
                      ? Colors.green
                      : Colors.transparent),
            ),
          ),
          Column(
            children: [
              Text(
                task?.title ?? "",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy')
                        .format(task?.createdAt ?? DateTime.now())
                        .toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: Colors.white),
                      color: Color(task?.category.color ?? 0000),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          height: 20,
                          width: 20,
                          imageUrl: task?.category.imagePath ?? "",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(width: 4),
                        Text(
                          task?.category.name ?? "",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue),
                      // color: Color(task?.category.color ?? 0000),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flag_outlined),
                        SizedBox(width: 4),
                        Text(
                          "1" ?? "",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
