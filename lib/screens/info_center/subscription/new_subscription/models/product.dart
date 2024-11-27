import 'package:flutter/material.dart';

// 가격예측 데이터 모델
class Product {
  final String name;
  final List<int> price;
  final ProductFilters filters;
  final String information;

  Product({
    required this.name,
    required this.price,
    required this.filters,
    required this.information,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      price: List<int>.from(json['price'].map((x) => x as int)),
      filters: ProductFilters.fromJson(json['filters'] as Map<String, dynamic>),
      information: json['information'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.map((p) => p.toString()).toList(),
      'filters': filters.toJson(),
      'information': information,
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
    return ProductFilters(
      terms: List<String>.from(json['terms'].map((x) => x as String)),
      markets: json['markets'] != null ? List<String>.from(json['markets'].map((x) => x as String)) : null,
      category: json['category'] as String,
      subtype: json['subtype'] as String,
      detail: json['detail'] as String,
    );
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