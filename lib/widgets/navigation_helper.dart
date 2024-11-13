import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NavigationHelper {
  static void onItemTapped(BuildContext context, int index, Function(int) updateIndex) {
    updateIndex(index);

    // 각 탭에 따라 적절한 경로로 이동하도록 설정
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/info_center_screen');
        break;
      case 2:
        context.go('/inquiry_management_screen');
        break;
      case 3:
        context.go('/order_management_screen');
        break;
      case 4:
        context.go('/product_list');
        break;
      default:
        context.go('/');
        break;
    }
  }
}
