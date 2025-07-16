import '../../domain/entities/category.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    // required int id,
    required String title,
    required String description,
    required bool isCompleted,
    required Category category,
    required DateTime createdAt,
  }) : super(
          title: title,
          description: description,
          isCompleted: isCompleted,
          category: category,
          createdAt: createdAt,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      // id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] == 1,
      createdAt: DateTime.parse(json['created_at']), // ✅ Fix here
      category: Category(
        id: json['category_id'],
        name: json['category_name'],
        color: json['category_color'],
        imagePath: json['category_imagePath'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'categoryId': category.id,
      'createdAt': createdAt?.toIso8601String(), // ✅ Fix here
    };
  }
}
