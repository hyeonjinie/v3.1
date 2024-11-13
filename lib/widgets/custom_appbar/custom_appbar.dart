import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';
import '../navigation_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomAppBar({
    Key? key,
    this.scaffoldKey,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb && constraints.maxWidth > 660) {
          return _buildWebAppBar(context, constraints.maxWidth);
        } else {
          return _buildMobileAppBar(context);
        }
      },
    );
  }

  ResponsiveSafeArea _buildWebAppBar(BuildContext context, double maxWidth) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return ResponsiveSafeArea(
      child: AppBar(
        toolbarHeight: 2 * kToolbarHeight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () => context.go('/'),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/png/bgood.png', fit: BoxFit.contain),
              ),
            ),
            Row(
              children: [
                _buildNavItem(context, 0, '홈'),
                _buildNavItem(context, 1, '정보센터'),
                _buildNavItem(context, 2, '문의관리'),
                _buildNavItem(context, 3, '주문관리'),
                _buildNavItem(context, 4, '비굿마켓'),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                if (user != null) {
                  context.go('/my_page');
                } else {
                  context.go('/login_screen');
                }
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 2.0,
          ),
        ),
      ),
    );
  }

  AppBar _buildMobileAppBar(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => context.go('/'),
            child: SizedBox(
              height: 80,
              width: 80,
              child: Image.asset('assets/png/bgood.png', fit: BoxFit.contain),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              if (user != null) {
                context.go('/my_page');
              } else {
                context.go('/login_screen');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String title) {
    return GestureDetector(
      onTap: () {
        final authProvider = Provider.of<AuthProviderService>(context, listen: false);
        final user = authProvider.user;

        if (user == null) {
          context.go('/login_screen');
        } else {
          NavigationHelper.onItemTapped(context, index, onItemTapped);
        }
      },
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: selectedIndex == index ? Colors.green : Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    if (scaffoldKey == null || scaffoldKey!.currentContext == null) {
      return const Size.fromHeight(kToolbarHeight);
    }
    final BuildContext context = scaffoldKey!.currentContext!;
    final constraints = MediaQuery.of(context).size;
    return Size.fromHeight(kIsWeb && constraints.width > 660 ? 2 * kToolbarHeight : kToolbarHeight);
  }
}
