class Category {
  final int? id;
  final String? name;
  final int? color; // Stored as int (e.g. 0xFFAABBCC)
  final String? imagePath;

  Category({
    this.id,
    this.name,
    this.color,
    this.imagePath,
  });
}
