import 'package:flutter/material.dart';

class MemberType {
  String currentValue;
  List<DropdownMenuItem<String>> items;

  MemberType({
    required this.currentValue,
    required this.items,
  });

  static List<DropdownMenuItem<String>> getItems() {
    return [
      const DropdownMenuItem(value: '1', child: Text('농민')),
      const DropdownMenuItem(value: '2', child: Text('식품제조가공업체')),
      const DropdownMenuItem(value: '3', child: Text('소상공인')),
      const DropdownMenuItem(value: '4', child: Text('기타')),
    ];
  }
}


String getCollectionPathBasedOnMemberType(String memberType) {
  switch (memberType) {
    case '1':
      return 'farmers';
    case '2':
      return 'food_manufacturers';
    case '3':
      return 'small_businesses';
    case '4':
      return 'others';
    default:
      return 'admin_user'; // Default path if none matches
  }
}