import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/category_model.dart';

class CategoryService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.100.40:8001',
  ));

  // Firebase 사용자 토큰 가져오기
  Future<String?> _getUserToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.getIdToken(); // 사용자 토큰 가져오기
      } else {
        print("사용자가 로그인되어 있지 않습니다.");
        return null;
      }
    } catch (e) {
      print("토큰 가져오기 오류: $e");
      return null;
    }
  }

  // 카테고리 데이터 가져오기
  Future<List<Category>> fetchCategories(String level1) async {
    try {
      // 사용자 토큰 가져오기
      final token = await _getUserToken();
      if (token == null) {
        throw Exception("유효한 토큰이 없습니다. 로그인 상태를 확인하세요.");
      }

      // API 요청
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

      // 응답 처리
      if (response.statusCode == 200) {
        final data = response.data['categories'] as List<dynamic>;
        return data.map((e) => Category.fromMap(e)).toList();
      } else {
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // 가격 데이터 가져오기
  Future<List<Product>> fetchProducts(String level1) async {
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
        final data = response.data['products'] as List<dynamic>;
        return data.map((e) => Product.fromMap(e)).toList();
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
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

  //  List<Category> getPriceCategories() {
  //   final categories = priceCategory['categories'] as List<dynamic>;
  //   return categories.map((e) => Category.fromMap(e)).toList();
  // }


}



//  List<Category> getPriceCategories() {
//     final categories = priceCategory['categories'] as List<dynamic>;
//     return categories.map((e) => Category.fromMap(e)).toList();
//   }

//   List<Product> getPriceProducts() {
//     final products = priceCategory['products'] as List<dynamic>;
//     return products.map((e) => Product.fromMap(e)).toList();
//   }

//   List<Category> getIndexCategories() {
//     final categories = indexCategory['categories'] as List<dynamic>;
//     return categories.map((e) => Category.fromMap(e)).toList();
//   }

//   List<Product> getIndexProducts() {
//     final products = indexCategory['indices'] as List<dynamic>;
//     return products.map((e) => Product.fromMap(e)).toList();
//   }