import '../../domain/entities/category.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel(
      {int? id,
      required String title,
      required String description,
      required bool isCompleted,
      required Category category,
      required DateTime createdAt,
      required int priority})
      : super(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            category: category,
            createdAt: createdAt,
            priority: priority);
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: (json['isCompleted'] ?? 0) == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      priority: int.tryParse(json['priority'].toString()) ?? 1,
      category: Category(
        id: json['category_id'] ?? 0,
        name: json['category_name'] ?? 'Unknown',
        color: json['category_color'] ?? 0xFF000000,
        imagePath: json['category_imagePath'] ?? '',
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'categoryId': category.id,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
    };
  }
}
