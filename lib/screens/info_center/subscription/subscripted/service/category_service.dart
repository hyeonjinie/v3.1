import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/subs_mock.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/category_model.dart';

class CategoryService {
  List<Category> getPriceCategories() {
    final categories = priceCategory['categories'] as List<dynamic>;
    return categories.map((e) => Category.fromMap(e)).toList();
  }

  List<Product> getPriceProducts() {
    final products = priceCategory['products'] as List<dynamic>;
    return products.map((e) => Product.fromMap(e)).toList();
  }

  List<Category> getIndexCategories() {
    final categories = indexCategory['categories'] as List<dynamic>;
    return categories.map((e) => Category.fromMap(e)).toList();
  }

  List<Product> getIndexProducts() {
    final products = indexCategory['indices'] as List<dynamic>;
    return products.map((e) => Product.fromMap(e)).toList();
  }
}
