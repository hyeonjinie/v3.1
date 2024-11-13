import '../../data/datasources/product_remote_data_source.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<Product> getProductById(String uid);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> getProductById(String uid) async {
    return await remoteDataSource.getProductById(uid);
  }
}
