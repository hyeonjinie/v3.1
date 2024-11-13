import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3_mvp/services/api_service.dart';
import 'package:v3_mvp/services/auth_provider.dart';

class MarketDataService extends ChangeNotifier {
  List<Map<String, dynamic>> marketData = [];
  List<Map<String, dynamic>> predictedMarketData = [];
  List<bool> marketFavorites = [];  // 전체 품목에 대한 즐겨찾기 상태
  List<bool> predictedFavorites = [];  // 예측 품목에 대한 즐겨찾기 상태
  bool isLoading = true;
  bool _isDisposed = false;
  final AuthProviderService authProvider;

  MarketDataService({required this.authProvider}) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var queryParams = {'grade': '상'};
      var response = await ApiService().AllPrices(queryParams: queryParams);

      if (_isDisposed) return;

      var itemPrice = List<Map<String, dynamic>>.from(response.map((item) {
        var prediction = item['prediction'] ?? {};
        var predictedPrices = prediction['predicted_price'] ?? {};
        var predictionError = prediction['error'] ?? {};

        var predictedPriceIncrease = false;
        if (predictedPrices.isNotEmpty) {
          var firstPredictedPriceEntry = predictedPrices.entries.first;
          var firstRealPriceEntry = prediction['real_price'][firstPredictedPriceEntry.key];
          var firstErrorEntry = predictionError[firstPredictedPriceEntry.key];

          if (firstPredictedPriceEntry.value != null && firstRealPriceEntry != null) {
            if (firstErrorEntry >= 1) {
              predictedPriceIncrease = true;
            }
          }
        }

        return {
          "name": item['pum_nm'] ?? 'Unknown',
          "price": item['av_p'] != null ? "${item['av_p'].toString()}원" : 'N/A',
          "change": item['fluc'] != null ? "${item['fluc'].toString()}원" : 'N/A',
          "changePercent": item['d_mark_r'] != null ? "${item['d_mark_r'].toString()}%" : 'N/A',
          "item": item['item_name'] ?? 'Unknown',
          "categoryCode": item['category_code'] ?? "Unknown",
          "categoryName": item['category_name'] ?? "Unknown",
          "itemCode": item['item_code'] ?? "Unknown",
          "itemName": item['item_name'] ?? "Unknown",
          "varietyCode": item['variety_code'] ?? "Unknown",
          "grade": item['g_name'] ?? "Unknown",
          "yesterdayPrice": item['d_mark_p'] != null ? "${item['d_mark_p'].toString()}원" : "N/A",
          "yesterdayChange": item['d_mark_r'] != null ? "${item['d_mark_r'].toString()}%" : "N/A",
          "date": item['std_dt'] ?? "Unknown",
          "prediction": prediction,
          "predictedPriceIncrease": predictedPriceIncrease,
        };
      }).toList());

      if (_isDisposed) return;

      predictedMarketData = itemPrice.where((item) => item['prediction'].isNotEmpty).toList();
      marketData = itemPrice;

      // 초기 즐겨찾기 상태 설정
      marketFavorites = List.filled(marketData.length, false);
      predictedFavorites = List.filled(predictedMarketData.length, false);

      isLoading = false;
      notifyListeners();

      await _loadFavorites();
    } catch (e) {
      if (_isDisposed) return; // 추가: _isDisposed를 이용하여 dispose 상태 확인
      print('Error loading market data: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    var user = authProvider.user;
    if (user != null) {
      try {
        var favoritesSnapshot = await FirebaseFirestore.instance
            .collection('client')
            .doc(user.uid)
            .collection('favorites')
            .get();

        if (_isDisposed) return;

        var favoriteItems = favoritesSnapshot.docs.map((doc) => doc.id).toSet();

        for (int i = 0; i < marketData.length; i++) {
          marketFavorites[i] = favoriteItems.contains(marketData[i]['name']);
        }
        for (int i = 0; i < predictedMarketData.length; i++) {
          predictedFavorites[i] = favoriteItems.contains(predictedMarketData[i]['name']);
        }

        notifyListeners();
      } catch (e) {
        print('Error loading favorites: $e');
        notifyListeners();
      }
    }
  }

  void toggleFavorite(int index, bool isPredicted) async {
    var user = authProvider.user;
    var item = isPredicted ? predictedMarketData[index] : marketData[index];
    var favoritesList = isPredicted ? predictedFavorites : marketFavorites;

    favoritesList[index] = !favoritesList[index];
    notifyListeners();

    if (favoritesList[index]) {
      try {
        await FirebaseFirestore.instance
            .collection('client')
            .doc(user?.uid)
            .collection('favorites')
            .doc(item['name'])
            .set({
          'name': item['name'],
          'price': item['price'],
          'change': item['change'],
          'changePercent': item['changePercent'],
          'timestamp': FieldValue.serverTimestamp()
        });
      } catch (e) {
        favoritesList[index] = !favoritesList[index];
        notifyListeners();
        rethrow;
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('client')
            .doc(user?.uid)
            .collection('favorites')
            .doc(item['name'])
            .delete();
      } catch (e) {
        favoritesList[index] = !favoritesList[index];
        notifyListeners();
        rethrow;
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // dispose 호출 시 _isDisposed를 true로 설정
    super.dispose();
  }
}
