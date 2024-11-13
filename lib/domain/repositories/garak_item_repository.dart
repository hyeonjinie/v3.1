// lib/domain/repositories/garak_item_repository.dart
import '../entities/garak_item.dart';

abstract class GarakItemRepository {
  Future<List<GarakItem>> getGarakItems();
}
