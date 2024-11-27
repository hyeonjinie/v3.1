import 'package:flutter/material.dart';

// 가격예측 데이터 모델
class Product {
  final String name;
  final List<int> price;
  final ProductFilters filters;

  Product({required this.name, required this.price, required this.filters});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: List<int>.from(json['price'].map((x) => x as int)),
      filters: ProductFilters.fromJson(json['filters']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.map((p) => p.toString()).toList(),
      'filters': filters.toJson(),
    };
  }
}

class ProductFilters {
  final List<String> terms;
  final List<String>? markets;  
  final String category;
  final String subtype;
  final String detail;

  ProductFilters({
    required this.terms,
    this.markets,  
    required this.category,
    required this.subtype,
    required this.detail,
  });

  factory ProductFilters.fromJson(Map<String, dynamic> json) {
    print('Parsing ProductFilters from JSON: $json');  
    try {
      return ProductFilters(
        terms: List<String>.from(json['terms']),
        markets: json['markets'] != null ? List<String>.from(json['markets']) : null,
        category: json['category'],
        subtype: json['subtype'],
        detail: json['detail'],
      );
    } catch (e) {
      print('Error parsing ProductFilters: $e');  
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'terms': terms,
      'markets': markets,
      'category': category,
      'subtype': subtype,
      'detail': detail,
    };
  }
}