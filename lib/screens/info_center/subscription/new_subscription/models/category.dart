class CategoryLevel {
  final int level;
  final List<String> options;

  CategoryLevel({required this.level, required this.options});

  factory CategoryLevel.fromJson(Map<String, dynamic> json) {
    return CategoryLevel(
      level: json['level'],
      options: List<String>.from(json['options']),
    );
  }
}