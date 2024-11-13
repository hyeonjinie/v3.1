import 'package:v3_mvp/services/mock_data.dart';

class MockApi {
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return sampleProducts;
  }
}
