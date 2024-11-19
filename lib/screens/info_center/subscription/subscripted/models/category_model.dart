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

class Index {
  final String name;
  final int price;
  final String imgUrl;
  final Map<String, String> filters;

  Index({
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.filters,
  });

  factory Index.fromMap(Map<String, dynamic> map) {
    return Index(
      name: map['name'] as String,
      price: map['price'] as int,
      imgUrl: map['img_url'] as String,
      filters: Map<String, String>.from(map['filters']),
    );
  }
}
