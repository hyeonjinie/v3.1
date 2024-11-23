import 'package:v3_mvp/screens/info_center/subscription/subscripted/mock_data/subs_mock.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/models/price_model.dart';

class PriceService {
  Future<CropData> getPriceData(String productName) async {
    // 데이터가 없을 경우 기본값 제공
    final productData = priceProd[productName];
    if (productData == null) {
      throw Exception("Product not found");
    }

    // JSON 변환 중 null 방지
    return CropData.fromJson(productData as Map<String, dynamic>);
  }
}
