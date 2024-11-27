import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/bpi_screen.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/new_subscription.dart';
import 'package:v3_mvp/screens/info_center/subscription/subscripted/subscripted_page.dart';
import 'package:v3_mvp/screens/info_center/widget/sd_market_info_list.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../services/subscription_service.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/font_size_helper/font_size_helper.dart';
import '../../widgets/navigation_helper.dart';
import 'dart:convert';

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
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 2) {
      setState(() {}); // 탭이 변경될 때 FutureBuilder를 다시 실행하도록 상태 갱신
    }
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
            body: FutureBuilder<Widget>(
              future: _buildBody(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return snapshot.data ?? const SizedBox();
              },
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
            body: FutureBuilder<Widget>(
              future: _buildBody(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return snapshot.data ?? const SizedBox();
              },
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

  Future<Widget> _buildBody() async {
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
                      fontWeight: FontWeight.bold
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium)
                  ),
                  indicatorColor: const Color(0xFF00AF66),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: const [
                    Tab(text: '품목정보'),
                    Tab(text: 'BPI'),
                    // Tab(text: 'B급'),
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
                        // const SingleChildScrollView(
                        //   child: SubscriptedPage()
                        //   ),
                        Builder(
                          builder: (context) => FutureBuilder<bool>(
                            future: _checkSubscriptionStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              
                              final bool isSubscribed = snapshot.data ?? false;
                              return SingleChildScrollView(
                                child: isSubscribed 
                                  ? const SubscriptedPage()
                                  : const SubscriptionPage(),
                              );
                            },
                          ),
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

  Future<bool> _checkSubscriptionStatus() async {
    final authProvider = Provider.of<AuthProviderService>(context, listen: false);
    String? token = await authProvider.getCurrentUserToken();
    if (token != null) {
      try {
        final result = await SubscriptionApiService.checkSubscriptionStatus(token);
        if (result.statusCode == 200) {
          final statusData = json.decode(result.body);
          return statusData['sub_status'] ?? false;
        }
      } catch (e) {
        print('Error checking subscription: $e');
      }
    }
    return false;
  }

  Widget buildStockCard(Map<String, dynamic> stock) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(stock['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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