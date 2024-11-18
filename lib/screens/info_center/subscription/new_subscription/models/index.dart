import 'package:flutter/material.dart';

// 지수 데이터 모델
class Index {
  final String name;
  final List<int> price;
  final IndexFilters filters;

  Index({required this.name, required this.price, required this.filters});

  factory Index.fromJson(Map<String, dynamic> json) {
    return Index(
      name: json['name'],
      price: json['price'],
      filters: IndexFilters.fromJson(json['filters']),
    );
  }
}

class IndexFilters {
  final List<String> term;
  final String category;
  final String type;
  final String detail;

  IndexFilters({
    required this.term,
    required this.category,
    required this.type,
    required this.detail,
  });

  factory IndexFilters.fromJson(Map<String, dynamic> json) {
    return IndexFilters(
      term: List<String>.from(json['term']),
      category: json['category'],
      type: json['type'],
      detail: json['detail'],
    );
  }
}