import 'package:intl/intl.dart';

class SimpleProductModel {
  final String productId;
  final String image;
  final String name;
  final String bgoodPrice;
  final String? wholesalePrice;
  final String? discountRate;

  SimpleProductModel({
    required this.productId,
    required this.image,
    required this.name,
    required this.bgoodPrice,
    this.wholesalePrice,
    this.discountRate,
  });

  factory SimpleProductModel.fromMap(Map<String, dynamic> data) {
    final item = data['items'][0];
    return SimpleProductModel(
      productId: data['productId'],
      image: item['productImageUrl'],
      name: item['productName'],
      bgoodPrice: '${NumberFormat("#,###", "en_US").format(item['bgoodPrice'])}원',
      wholesalePrice: item['wholesalePrice'] != null
          ? '${NumberFormat("#,###", "en_US").format(item['wholesalePrice'])}원'
          : null,
      discountRate: item['discountRate'] != null
          ? '${item['discountRate']}%'
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'image': image,
      'name': name,
      'bgoodPrice': bgoodPrice,
      'wholesalePrice': wholesalePrice,
      'discountRate': discountRate,
    };
  }
}
