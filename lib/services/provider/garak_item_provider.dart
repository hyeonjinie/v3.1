import 'package:flutter/material.dart';
import '../../domain/entities/garak_item.dart';
import '../../domain/usecases/get_garak_items.dart';

class GarakItemProvider with ChangeNotifier {
  final GetGarakItems getGarakItems;
  List<GarakItem> items = [];
  String errorMessage = '';
  bool isLoading = false;

  GarakItemProvider({required this.getGarakItems});

  Future<void> fetchGarakItems() async {
    if (items.isNotEmpty) {
      return; // 캐시 히트, 이미 데이터가 로드된 경우 재요청하지 않음
    }

    isLoading = true;
    notifyListeners();

    try {
      items = await getGarakItems();
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Failed to fetch data';
      items = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
