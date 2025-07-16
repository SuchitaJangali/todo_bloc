import '../../domain/entities/category.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int id,
    required String title,
    required String description,
    required bool isCompleted,
    required Category category,
  }) : super(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         category: category,
       );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] == 1,
      category: Category(
        id: json['category_id'],
        name: json['category_name'],
        color: json['category_color'],
        imagePath: json['category_imagePath'],
      ), // to  fromm jaosn
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'categoryId': category.id,
    };
  }
}
