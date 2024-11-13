import 'package:v3_mvp/core/failure.dart';

import '../entities/garak_item.dart';
import '../repositories/garak_item_repository.dart';

class GetGarakItems {
  final GarakItemRepository repository;

  GetGarakItems({required this.repository});

  Future<List<GarakItem>> call() async {
    try {
      return await repository.getGarakItems();
    } catch (e) {
      throw ServerFailure();
    }
  }
}
