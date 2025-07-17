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
      id: json['category_id'],
      name: json['category_name'],
      color: json['category_color'],
      imagePath: json['category_imagePath'],
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
