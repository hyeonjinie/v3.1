import 'package:flutter/material.dart';
import '../../domain/models/product.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../data/datasources/product_remote_data_source.dart';

class ProductProvider with ChangeNotifier {
  final GetProductById getProductById;
  final ProductRemoteDataSource productRemoteDataSource;

  ProductProvider({
    required this.getProductById,
    required this.productRemoteDataSource,
  });

  List<Product> _products = [];
  List<Product> get products => _products;
  bool isLoading = true;

  Future<void> fetchProduct(String uid) async {
    _products = [await getProductById(uid)];
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _products = await productRemoteDataSource.getAllProducts();
    isLoading = false;
    notifyListeners();
  }
}
