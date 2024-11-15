import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/bpi_screen.dart';
import 'package:v3_mvp/screens/info_center/subscription/sub_price_info.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted_page.dart';
import 'package:v3_mvp/screens/info_center/widget/sd_market_info_list.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/font_size_helper/font_size_helper.dart';
import '../../widgets/navigation_helper.dart'; // Import NavigationHelper

class InfoCenterScreen extends StatefulWidget {
  @override
  InfoCenterScreenState createState() => InfoCenterScreenState();
}

class InfoCenterScreenState extends State<InfoCenterScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        if (kIsWeb && constraints.maxWidth > 660) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: SingleChildScrollView(
              // Scaffold 전체에 스크롤 추가
              child: _buildBody(),
            ),
          );
        } else {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: SingleChildScrollView(
              child: _buildBody(),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalInset = screenWidth * 0.1;
    if (horizontalInset < 20) horizontalInset = 20;
    if (horizontalInset > 300) horizontalInset = 300;

    return DefaultTabController(
      length: 4,
      child: Center(
        child: SizedBox(
          width: screenWidth > 1200 ? 1200 : screenWidth,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  labelStyle: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium),
                      fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium)),
                  indicatorColor: Color(0xFF00AF66),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  tabs: const [
                    Tab(text: '품목정보'),
                    Tab(text: 'BPI'),
                    Tab(text: 'B급'),
                    Tab(text: '구독'),
                  ],
                ),
                if (user != null)
                  Container(
                    height: 2000,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(child: MarketInfoList()),
                        SingleChildScrollView(child: BpiScreen()),
                        SingleChildScrollView(child: Container(child: Text('못난이 농산물 내용'))),
                        SubscriptedPage(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStockCard(Map<String, dynamic> stock) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(stock['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Current: ${stock['currentValue']}",
              style: TextStyle(fontSize: 18)),
          Text("Change: ${stock['change']} (${stock['changePercent']})",
              style: TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       if (kIsWeb) {
  //         if (constraints.maxWidth > 660) {
  //           return Scaffold(
  //             key: _scaffoldKey,
  //             appBar: CustomAppBar(
  //               scaffoldKey: _scaffoldKey,
  //               selectedIndex: _selectedIndex,
  //               onItemTapped: (index) =>
  //                   NavigationHelper.onItemTapped(context, index, _updateIndex),
  //             ),
  //             body: _buildBody(),
  //           );
  //         } else {
  //           return Scaffold(
  //             key: _scaffoldKey,
  //             appBar: CustomAppBar(
  //               // Ensure CustomAppBar is shown for 660 or less
  //               scaffoldKey: _scaffoldKey,
  //               selectedIndex: _selectedIndex,
  //               onItemTapped: (index) =>
  //                   NavigationHelper.onItemTapped(context, index, _updateIndex),
  //             ),
  //             body: _buildBody(),
  //             bottomNavigationBar: CustomBottomNavigationBar(
  //               selectedIndex: _selectedIndex,
  //               onItemTapped: (index) =>
  //                   NavigationHelper.onItemTapped(context, index, _updateIndex),
  //             ),
  //           );
  //         }
  //       } else {
  //         return Scaffold(
  //           key: _scaffoldKey,
  //           appBar: CustomAppBar(
  //             scaffoldKey: _scaffoldKey,
  //             selectedIndex: _selectedIndex,
  //             onItemTapped: (index) =>
  //                 NavigationHelper.onItemTapped(context, index, _updateIndex),
  //           ),
  //           body: _buildBody(),
  //           bottomNavigationBar: CustomBottomNavigationBar(
  //             selectedIndex: _selectedIndex,
  //             onItemTapped: (index) =>
  //                 NavigationHelper.onItemTapped(context, index, _updateIndex),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget _buildBody() {
  //   final authProvider = Provider.of<AuthProviderService>(context);
  //   final user = authProvider.user;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   double horizontalInset = screenWidth * 0.1;
  //   if (horizontalInset < 20) horizontalInset = 20;
  //   if (horizontalInset > 300) horizontalInset = 300;

  //   return DefaultTabController(
  //     // length: 3,
  //     length: 4,
  //     child: Center(
  //       child: SizedBox(
  //         width: screenWidth > 1200 ? 1200 : screenWidth,
  //         child: Center(
  //           child: Container(
  //             child: ConstrainedBox(
  //               constraints: const BoxConstraints(maxWidth: 1200),
  //               child: Column(
  //                 children: <Widget>[
  //                   TabBar(
  //                     controller: _tabController,
  //                     labelColor: Colors.black,
  //                     unselectedLabelColor: Colors.grey[700],
  //                     labelStyle: TextStyle(
  //                         fontSize: getFontSize(context, FontSizeType.medium),
  //                         fontWeight: FontWeight.bold),
  //                     unselectedLabelStyle: TextStyle(
  //                         fontSize: getFontSize(context, FontSizeType.medium)),
  //                     indicatorColor: Color(0xFF00AF66),
  //                     indicatorSize: TabBarIndicatorSize.tab,
  //                     indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
  //                     tabs: const [
  //                       Tab(text: '품목정보'),
  //                       Tab(text: 'BPI'),
  //                       Tab(text: 'B급'),
  //                       Tab(text: '구독'),
  //                     ],
  //                   ),
  //                   if (user != null)
  //                     Expanded(
  //                       child: TabBarView(
  //                         controller: _tabController,
  //                         children: [
  //                           SingleChildScrollView(
  //                             child: MarketInfoList(),
  //                           ),
  //                           SingleChildScrollView(
  //                             child: BpiScreen(),
  //                           ),
  //                           SingleChildScrollView(
  //                             child: Center(child: Text('못난이 농산물 내용')),
  //                           ),
  //                           SingleChildScrollView(
  //                             child: SubsInfoPage(),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }