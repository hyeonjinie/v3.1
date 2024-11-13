import 'package:v3_mvp/core/exception.dart';
import 'package:v3_mvp/core/failure.dart';
import 'package:v3_mvp/data/datasources/remote_data_source.dart';
import 'package:v3_mvp/domain/entities/garak_item.dart';
import 'package:v3_mvp/domain/repositories/garak_item_repository.dart';

class GarakItemRepositoryImpl implements GarakItemRepository {
  final RemoteDataSource remoteDataSource;

  GarakItemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GarakItem>> getGarakItems() async {
    try {
      final items = await remoteDataSource.getGarakItems();
      return items;
    } on ServerException {
      throw ServerFailure();
    }
  }
}
