import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/bpi_screen.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/new_subscription.dart';
import 'package:v3_mvp/screens/info_center/subscription/sub_price_info.dart';

import 'package:v3_mvp/screens/info_center/widget/sd_market_info_list.dart';

import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/font_size_helper/font_size_helper.dart';
import '../../widgets/navigation_helper.dart';
import '../main/widget/footer/footer.dart'; // Import NavigationHelper

class InfoCenterScreen extends StatefulWidget {
  const InfoCenterScreen({Key? key}) : super(key: key);

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
            body: _buildBody(),
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
            body: _buildBody(),
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
                  indicatorColor: const Color(0xFF00AF66),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: const [
                    Tab(text: '품목정보'),
                    Tab(text: 'BPI'),
                    Tab(text: 'B급'),
                    Tab(text: '구독'),
                  ],
                ),
                if (user != null)
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        const SingleChildScrollView(
                          child: MarketInfoList(),
                        ),
                        SingleChildScrollView(
                          child: BpiScreen(),
                        ),
                        const SingleChildScrollView(
                          child: SubsInfoPage(),
                        ),
                        const SingleChildScrollView(
                          child: SubscriptionPage(),
                        ),
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
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Current: ${stock['currentValue']}",
              style: const TextStyle(fontSize: 18)),
          Text("Change: ${stock['change']} (${stock['changePercent']})",
              style: const TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}
