import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/exception.dart';
import '../../domain/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<Product> getProductById(String uid);
  Future<List<Product>> getAllProducts(); // 추가된 메서드
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Product> getProductById(String uid) async {
    try {
      final doc = await firestore.collection('products').doc(uid).get();
      if (doc.exists) {
        return Product.fromDocument(doc);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await firestore.collection('products').get();
      return querySnapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching all products: $e');
      throw ServerException();
    }
  }
}
