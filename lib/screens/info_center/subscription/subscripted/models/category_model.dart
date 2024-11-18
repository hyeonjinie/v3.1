// category_model.dart
class Category {
  final int level;
  final List<String> options;

  Category({required this.level, required this.options});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      level: map['level'],
      options: List<String>.from(map['options']),
    );
  }
}

class Product {
  final String name;
  final int price;
  final Map<String, String> filters;

  Product({required this.name, required this.price, required this.filters});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      price: map['price'],
      filters: Map<String, String>.from(map['filters']),
    );
  }
}
