class Category {
  final int id;
  final String name;
  final int color;       // Stored as int (e.g. 0xFFAABBCC)
  final String imagePath;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.imagePath,
  });
}
