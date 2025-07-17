import 'category.dart';

class Task {
  final int? id;
  late final String title;
  final String description;
  final bool isCompleted;
  final Category category;
  final DateTime createdAt;
  final int priority;

  Task({
    required this.createdAt,
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
    required this.priority,
  });
}
