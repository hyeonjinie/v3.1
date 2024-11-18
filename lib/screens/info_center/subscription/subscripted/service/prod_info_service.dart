import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/price_model.dart';

class PriceService {
  static Future<PriceData> getPriceData(String cropName) async {
    // For mock data, assume it's in a file called 'subs_mock.dart'
    final data = await _loadPriceMockData();
    final cropData = data[cropName];
    
    return PriceData.fromJson(cropData);
  }

  static Future<Map<String, dynamic>> _loadPriceMockData() async {
    // Load mock data from the file (assuming it's in JSON format)
    final String response = await rootBundle.loadString('assets/subs_mock.dart');
    return json.decode(response); // assuming the file is in the correct format
  }
}
