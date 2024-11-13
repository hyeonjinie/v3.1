import 'package:flutter/material.dart';
import 'package:v3_mvp/domain/repositories/price_repository.dart';

class PriceProvider extends ChangeNotifier {
  final PriceRepository priceRepository;

  PriceProvider({required this.priceRepository});

  bool isLoading = false;
  String errorMessage = '';
  Map<String, Map<String, dynamic>> _priceCache = {}; // 캐시 추가
  Map<String, dynamic> priceData = {};

  Future<void> fetchPriceData(String item, String pumNm) async {
    final cacheKey = '$item-$pumNm';
    if (_priceCache.containsKey(cacheKey)) {
      // 캐시에서 데이터 로드
      priceData = _priceCache[cacheKey]!;
      errorMessage = '';
      notifyListeners();
      return;
    }

    // 데이터 로딩 시작
    _setLoadingState(true);

    try {
      priceData = await priceRepository.fetchPriceData(item, pumNm);
      _priceCache[cacheKey] = priceData; // 캐시에 데이터 저장
      errorMessage = ''; // 성공 시 에러 메시지 초기화
    } catch (e) {
      errorMessage = 'Failed to fetch price data';
    } finally {
      // 데이터 로딩 완료
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Map<String, dynamic> getGradeData(String grade) {
    switch (grade) {
      case '특':
        return priceData['av_p_t'] ?? {};
      case '상':
        return priceData['av_p_h'] ?? {};
      case '중':
        return priceData['av_p_m'] ?? {};
      case '하':
        return priceData['av_p_l'] ?? {};
      default:
        return {};
    }
  }
}
