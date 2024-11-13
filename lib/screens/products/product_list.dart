import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/custom_appbar/custom_appbar.dart';
import 'package:v3_mvp/screens/products/widget/category_view.dart';
import 'package:v3_mvp/screens/products/widget/custom_scrollable_tab_bar.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../domain/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/auth_provider.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/navigation_helper.dart';
import '../auth/login/login_screen.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String>? mainCategories;
  Map<String, List<String>> categorySubcategories = {};
  late Future<List<Product>> productsFuture;
  final Map<String, int> selectedSubcategoryIndex = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4;

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    _tabController = TabController(length: 0, vsync: this);
    final productRemoteDataSource =
    ProductRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
    productsFuture = productRemoteDataSource.getAllProducts();
    productsFuture.then((products) {
      _initializeCategories(products);
      _updateTabController();
    }).catchError((error) {
      print('Error loading products: $error');
    });
  }

  void _initializeCategories(List<Product> products) {
    final categories = <String>{};
    final subcategories = <String, Set<String>>{};

    for (var product in products) {
      final mainCategory = product.mainCategory;
      final subCategory = product.subCategory;
      categories.add(mainCategory);
      subcategories
          .putIfAbsent(mainCategory, () => <String>{})
          .add(subCategory);
    }

    // 지정된 순서로 카테고리 정렬
    const categoryOrder = ['농산물', '수산물', '축산물', '가공식품', '반찬가게'];
    mainCategories = categoryOrder.where((category) => categories.contains(category)).toList();
    categorySubcategories =
        subcategories.map((key, value) => MapEntry(key, value.toList()));

    for (var category in categorySubcategories.keys) {
      selectedSubcategoryIndex[category] = 0;
    }
  }

  void _updateTabController() {
    _tabController.dispose();
    _tabController = TabController(length: mainCategories!.length, vsync: this);
    setState(() {});
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
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                // Ensure CustomAppBar is shown for 660 or less
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
    if (user == null) return LoginScreen();
    return mainCategories == null
        ? const Center(child: CircularProgressIndicator())
        : Center(
      child: ResponsiveSafeArea(
        child: SizedBox(
          child: Column(
            children: [
              CustomScrollableTabBar(
                  tabController: _tabController, tabs: mainCategories),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: mainCategories!
                      .map((category) => CategoryView(
                    category: category,
                    subcategories:
                    categorySubcategories[category]!,
                    selectedSubcategoryIndex:
                    selectedSubcategoryIndex,
                    productsFuture: productsFuture,
                    onSubcategorySelected: (index) {
                      setState(() {
                        selectedSubcategoryIndex[category] =
                            index;
                      });
                    },
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: _icon(0, 'assets/bg_svg/icon-home.svg'), label: '홈'),
        BottomNavigationBarItem(
            icon: _icon(1, 'assets/bg_svg/information_center.svg'),
            label: '정보센터'),
        BottomNavigationBarItem(
            icon: _icon(2, 'assets/bg_svg/question.svg'), label: '문의관리'),
        BottomNavigationBarItem(
            icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'),
            label: '주문관리'),
        BottomNavigationBarItem(
            icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'), label: '비굿마켓'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) =>
          NavigationHelper.onItemTapped(context, index, _updateIndex),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // 애니메이션 제거
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
