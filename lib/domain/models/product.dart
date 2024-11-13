import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String productName;
  final double bgoodPrice;
  final double? originalPrice;
  final double? wholesalePrice;
  final String productImageUrl;
  final String productDetailUrl;
  final int? discountRate;
  final String mainCategory;
  final String subCategory;
  final List<Map<String, String>> productInfoLaw;
  int ProductWeight; // 추가된 필드

  Product({
    required this.id,
    required this.productName,
    required this.bgoodPrice,
    this.originalPrice,
    this.wholesalePrice,
    required this.productImageUrl,
    required this.productDetailUrl,
    this.discountRate,
    required this.mainCategory,
    this.subCategory = '',
    required this.productInfoLaw,
    this.ProductWeight = 1, // 기본값을 1로 설정
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      productName: data['product_name'] ?? '',
      bgoodPrice: (data['bgood_price'] ?? 0).toDouble(),
      originalPrice: (data['original_price'] ?? 0).toDouble(),
      wholesalePrice: (data['wholesale_price'] ?? 0).toDouble(),
      productImageUrl: data['product_image_url'] ?? '',
      productDetailUrl: data['product_detail_url'] ?? '',
      discountRate: data['discount_rate'],
      mainCategory: data['main_category'] ?? '',
      subCategory: data['sub_category'] ?? '',
      productInfoLaw: (data['product_info_law'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ?? [],
      ProductWeight: data['quantity'] ?? 1, // 데이터에서 수량을 가져오거나 기본값을 사용
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productName: json['product_name'] ?? '',
      bgoodPrice: (json['bgood_price'] ?? 0).toDouble(),
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      wholesalePrice: (json['wholesale_price'] ?? 0).toDouble(),
      productImageUrl: json['product_image_url'] ?? '',
      productDetailUrl: json['product_detail_url'] ?? '',
      discountRate: json['discount_rate'],
      mainCategory: json['main_category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      productInfoLaw: (json['product_info_law'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ?? [],
      ProductWeight: json['product_weight'] ?? 1, // 데이터에서 수량을 가져오거나 기본값을 사용
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'bgood_price': bgoodPrice,
      'original_price': originalPrice,
      'wholesale_price': wholesalePrice,
      'product_image_url': productImageUrl,
      'product_detail_url': productDetailUrl,
      'discount_rate': discountRate,
      'main_category': mainCategory,
      'sub_category': subCategory,
      'product_info_law': productInfoLaw,
      'product_weight': ProductWeight, // 추가된 필드
    };
  }
}
