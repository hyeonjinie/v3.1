import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        // baseUrl: 'http://localhost:8080',
        // baseUrl: 'http://43.202.4.236:8000',
        baseUrl: 'https://bgoodserver.xyz:8000'
      ),
    );
  }

  Future<dynamic> getAgricultureData() async {
    try {
      // final response = await _dio.get('/indices/all');
      final response = await _dio.get('/price/top_10');
      return response.data;
    } on DioException catch (dioError) {
      // DioError 처리
      if (dioError.response != null) {
        // 서버 에러 응답
        print('Server responded with error: ${dioError.response}');
      } else {
        // 요청이 전송되지 않았거나 응답이 없는 경우
        print('Error sending request or no response received: $dioError');
      }
      return null;
    } catch (error) {
      // 그 외 모든 에러 처리
      print('Unexpected error: $error');
      return null;
    }
  }


  Future<dynamic> AllPrices({Map<String, dynamic>? queryParams}) async {
    try {
      final response =
      await _dio.get('/price/latest_prices', queryParameters: queryParams);
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Server responded with error: ${dioError.response}');
      } else {
        print('Error sending request or no response received: $dioError');
      }
      return null;
    } catch (error) {
      print('Unexpected error: $error');
      return null;
    }
  }


  Future<dynamic> getYearPrices({Map<String, dynamic>? queryParams}) async {
    try {
      final response =
          await _dio.get('/price/garak_year_prices', queryParameters: queryParams);
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Server responded with error: ${dioError.response}');
      } else {
        print('Error sending request or no response received: $dioError');
      }
      return null;
    } catch (error) {
      print('Unexpected error: $error');
      return null;
    }
  }



  Future<dynamic> getBpi({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get('/bpi/bundle', queryParameters: queryParams);
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Server responded with error: ${dioError.response}');
      } else {
        print('Error sending request or no response received: $dioError');
      }
      return null;
    } catch (error) {
      print('Unexpected error: $error');
      return null;
    }
  }


  Future<dynamic> getMenu({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get('/bpi/menu', queryParameters: queryParams);
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Server responded with error: ${dioError.response}');
      } else {
        print('Error sending request or no response received: $dioError');
      }
      return null;
    } catch (error) {
      print('Unexpected error: $error');
      return null;
    }
  }


  Future<List<Map<String, dynamic>>> getBpiItemPrice() async {
    try {
      final response = await _dio.get('/price/latest_prices');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (dioError) {
      print('Error: ${dioError.message}');
      return [];
    } catch (error) {
      print('Unexpected error: $error');
      return [];
    }
  }
}
