import 'package:flutter/material.dart';

// 지수 데이터 모델
class Index {
  final String name;
  final List<int> price;
  final String? imgUrl;
  final IndexFilters filters;

  Index({
    required this.name,
    required this.price,
    this.imgUrl,
    required this.filters
  });

  factory Index.fromJson(Map<String, dynamic> json) {
    return Index(
      name: json['name'] as String,
      price: List<int>.from(json['price'].map((x) => x as int)),
      imgUrl: json['img_url'] as String?,
      filters: IndexFilters.fromJson(json['filters'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.map((p) => p.toString()).toList(),
      'img_url': imgUrl,
      'filters': filters.toJson(),
    };
  }
}

class IndexFilters {
  final List<String> terms;
  final String category;
  final String subtype;
  final String detail;
  final String? subDetail;  // 레벨 6를 위한 필드 추가

  IndexFilters({
    required this.terms,
    required this.category,
    required this.subtype,
    required this.detail,
    this.subDetail,  // optional parameter
  });

  factory IndexFilters.fromJson(Map<String, dynamic> json) {
    return IndexFilters(
      terms: List<String>.from(json['terms'] as List),
      category: json['category'] as String,
      subtype: json['subtype'] as String,
      detail: json['detail'] as String,
      subDetail: json['sub_detail'] as String?,  // null이 가능하도록 설정
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terms': terms,
      'category': category,
      'subtype': subtype,
      'detail': detail,
      'sub_detail': subDetail,
    };
  }
}