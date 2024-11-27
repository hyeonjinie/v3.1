import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/category_model.dart';

class CategoryService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.100.40:8001',
  ));

  Map<String, dynamic>? _cachedResponse;
  String? _cachedLevel1;

  // Firebase 사용자 토큰 가져오기
  Future<String?> _getUserToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.getIdToken(); // 사용자 토큰 가져오기
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // 랜딩 데이터 가져오기
  Future<Map<String, dynamic>> _fetchLandingData(String level1) async {
    // 캐시된 데이터가 있고 같은 level1이면 캐시된 데이터 반환
    if (_cachedResponse != null && _cachedLevel1 == level1) {
      return _cachedResponse!;
    }

    final token = await _getUserToken();
    if (token == null) {
      throw Exception("유효한 토큰이 없습니다. 로그인 상태를 확인하세요.");
    }

    final response = await _dio.get(
      '/subscription/landing',
      queryParameters: {'level_1': level1},
      options: Options(
        headers: {
          'accept': 'application/json',
          'authorization': token, // Bearer 토큰 추가
        },
      ),
    );

    if (response.statusCode == 200) {

      // 응답 데이터 캐시
      _cachedResponse = response.data;
      _cachedLevel1 = level1;
      
      return response.data;
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  // 카테고리 데이터 가져오기
  Future<List<Category>> fetchCategories(String level1) async {
    try {
      final data = await _fetchLandingData(level1);
      final categories = (data['categories'] as List<dynamic>)
          .map((e) => Category.fromMap(e))
          .toList();
      
      final products = (data['products'] as List<dynamic>)
          .map((e) => Product.fromMap(e))
          .toList();
      
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // 가격 데이터 가져오기
  Future<List<Product>> fetchProducts(String level1) async {
    try {
      final data = await _fetchLandingData(level1);
      return (data['products'] as List<dynamic>)
          .map((e) => Product.fromMap(e))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // 지수 데이터 가져오기
  Future<List<Index>> fetchIndices(String level1) async {
    try {
      final token = await _getUserToken();
      if (token == null) {
        throw Exception("유효한 토큰이 없습니다. 로그인 상태를 확인하세요.");
      }

      final response = await _dio.get(
        '/subscription/landing',
        queryParameters: {'level_1': level1},
        options: Options(
          headers: {
            'accept': 'application/json',
            'authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['indices'] as List<dynamic>;
        return data.map((e) => Index.fromMap(e)).toList();
      } else {
        throw Exception('Failed to load indices. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching indices: $e');
      return [];
    }
  }
}