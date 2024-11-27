import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/subs_mock.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/index_model.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/price_model.dart';

class PriceService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.100.40:8001',
  ));

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

  Future<CropData?> getPriceData(String productName, int day) async {
    try {
      // 사용자 토큰 가져오기
      final token = await _getUserToken();
      if (token == null) {
        throw Exception("유효한 토큰이 없습니다. 로그인 상태를 확인하세요.");
      }

      // API 요청
      final response = await _dio.get(
        '/sub_data/predicted_price',
        queryParameters: {'variety': productName, 'day': day},
        options: Options(
          headers: {
            'accept': 'application/json',
            // 'authorization': token, // Bearer 토큰 추가
          },
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        final data = CropData.fromJson(
            response.data[productName] as Map<String, dynamic>);
        return data;
      } else {
        throw Exception(
            'Failed to load price_data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching price_data: $e');
      return null;
    }
  }
}

class IndexService {
  Future<ProdData?> getIndexData(String lclass, String mclass, String sclass,
      String variety, int day) async {
    final productData = indexProd[variety];
    if (productData == null) {
      throw Exception("Product not found");
    }
    return ProdData.fromJson(Map<String, dynamic>.from(productData));
  }
}
