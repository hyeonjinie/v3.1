import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/main/widget/easy_purchase/easy_purchase.dart';
import 'package:v3_mvp/screens/main/widget/market/bgood_market.dart';
import 'package:v3_mvp/screens/main/widget/banner/carousel_banner.dart';
import 'package:v3_mvp/screens/main/widget/footer/footer.dart';
import 'package:v3_mvp/screens/main/widget/price_trend/predict_carousel_banner.dart';
import 'package:v3_mvp/widgets/custom_appbar/custom_appbar.dart';
import 'package:v3_mvp/widgets/navigation_helper.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/auth_provider.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../banner/banner1.dart';
import 'widget/price_trend/custom_dropdown_button.dart';

class MainContentsScreen extends StatefulWidget {
  const MainContentsScreen({Key? key}) : super(key: key);

  @override
  State<MainContentsScreen> createState() => _MainContentsScreenState();
}

class _MainContentsScreenState extends State<MainContentsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          if (constraints.maxWidth > 660) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
            );
          }
        } else {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(height: 26),
          // CarouselBanner(
          //   interval: const Duration(seconds: 10), // 롤링 시간 설정
          //   onBannerTap: handleBannerTap, // 클릭 이벤트 핸들러로 함수 참조 전달
          // ),
          const SizedBox(height: 70),
          PredictCarousel(),
          const SizedBox(height: 26),
          const CustomDropdownButton(),
          const SizedBox(height: 70),
          const EasyPurchaseCarousel(),
          const SizedBox(height: 30),
          const BgoodMarket(),
          if (kIsWeb) CustomFooter(),
        ],
      ),
    );
  }

  void handleBannerTap(int index) {
    print('Banner $index tapped!');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Banner1(bannerIndex: index),
      ),
    );
  }


  Widget _icon(int index, String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      color: _selectedIndex == index ? Colors.green : Colors.grey,
    );
  }
}
