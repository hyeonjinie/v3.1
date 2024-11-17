import 'package:flutter/material.dart';

// 가격예측 데이터 모델
class Product {
  final String name;
  final int price;
  final ProductFilters filters;

  Product({required this.name, required this.price, required this.filters});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      filters: ProductFilters.fromJson(json['filters']),
    );
  }
}

class ProductFilters {
  final List<String> terms;
  final List<String> markets;
  final String category;
  final String subtype;
  final String detail;

  ProductFilters({
    required this.terms,
    required this.markets,
    required this.category,
    required this.subtype,
    required this.detail,
  });

  factory ProductFilters.fromJson(Map<String, dynamic> json) {
    return ProductFilters(
      terms: List<String>.from(json['terms']),
      markets: List<String>.from(json['markets']),
      category: json['category'],
      subtype: json['subtype'],
      detail: json['detail'],
    );
  }
}