import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/order/order_history/widget/order_history_tabs.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import '../../../domain/models/custom_user.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../../widgets/navigation_helper.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4;

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final customUser = authProvider.user;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            scaffoldKey: _scaffoldKey,
            selectedIndex: _selectedIndex,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          ),
          body: _buildBody(customUser, isWeb: kIsWeb, isNarrow: constraints.maxWidth <= 660),
          bottomNavigationBar: constraints.maxWidth <= 660
              ? CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          )
              : null,
        );
      },
    );
  }

  Widget _buildBody(CustomUser? customUser, {required bool isWeb, required bool isNarrow}) {
    if (customUser == null) {
      return Center(
        child: Text('로그인이 필요합니다.'),
      );
    }
    print('customUser.uid: ${customUser.uid}');
    return OrderHistoryTabs(uid: customUser.uid);
  }
}

