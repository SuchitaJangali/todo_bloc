import 'category.dart';

class Task {
  // final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final Category category;
  final DateTime? createdAt;

  Task({
    this.createdAt,
    // required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
  });
}
