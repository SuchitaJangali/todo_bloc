import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required int id,
    required String name,
    required int color,
    required String imagePath,
  }) : super(
    id: id,
    name: name,
    color: color,
    imagePath: imagePath,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'imagePath': imagePath,
    };
  }
}
