import 'package:v3_mvp/core/exception.dart';
import 'package:v3_mvp/core/failure.dart';
import 'package:v3_mvp/data/datasources/remote_data_source.dart';
import 'package:v3_mvp/domain/repositories/price_repository.dart';

class PriceRepositoryImpl implements PriceRepository {
  final RemoteDataSource remoteDataSource;

  PriceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> fetchPriceData(String item, String pumNm) async {
    try {
      return await remoteDataSource.fetchPriceData(item, pumNm);
    } on ServerException {
      throw ServerFailure();
    }
  }
}
