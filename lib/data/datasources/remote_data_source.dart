import 'package:dio/dio.dart';
import 'package:v3_mvp/core/exception.dart';
import '../models/garak_item_model.dart';

abstract class RemoteDataSource {
  Future<List<GarakItemModel>> getGarakItems();
  Future<Map<String, dynamic>> fetchPriceData(String item, String pumNm);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio = Dio();

  @override
  Future<List<GarakItemModel>> getGarakItems() async {
    try {
      final response = await _dio
          .get('https://bgoodserver.xyz:8000/price/garak_item_variety_list');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data.entries
            .map((entry) => GarakItemModel.fromJson({entry.key: entry.value}))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      if (e.type == DioExceptionType.badResponse) {
        throw ServerException();
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else if (e.type == DioExceptionType.unknown) {
        throw NetworkException();
      } else {
        throw UnexpectedException();
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw UnexpectedException();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPriceData(
      String itemNm, String pumNm) async {
    final url =
        'https://bgoodserver.xyz:8000/price/garak_year_prices?item_nm=$itemNm&pum_nm=$pumNm';
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
