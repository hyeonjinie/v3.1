import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _icon(0, 'assets/bg_svg/icon-home.svg'),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: _icon(1, 'assets/bg_svg/information_center.svg'),
          label: '정보센터',
        ),
        BottomNavigationBarItem(
          icon: _icon(2, 'assets/bg_svg/question.svg'),
          label: '문의관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'),
          label: '주문관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'),
          label: '비굿마켓',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (user == null) {
          context.go('/login_screen');
        } else {
          onItemTapped(index);
        }
      },
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // 애니메이션 제거
    );
  }

  Widget _icon(int index, String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      color: selectedIndex == index ? Colors.green : Colors.grey,
    );
  }
}
