import '../models/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById({required this.repository});

  Future<Product> call(String uid) async {
    return await repository.getProductById(uid);
  }
}
