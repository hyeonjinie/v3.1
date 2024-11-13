import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/domain/models/custom_user.dart';
import 'package:v3_mvp/screens/info_center/item_detail/widget/category_duration_selector.dart';
import 'package:v3_mvp/screens/info_center/item_detail/widget/inquiry_buttom.dart';
import 'package:v3_mvp/screens/info_center/item_detail/widget/market_price_list.dart';
import 'package:v3_mvp/screens/info_center/item_detail/widget/price_chart.dart';
import 'package:v3_mvp/screens/info_center/item_detail/widget/top_price_detail.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../domain/models/item.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../../widgets/navigation_helper.dart';

class SdPriceDetailScreen extends StatefulWidget {
  final Item item;
  final double? errorValue;

  SdPriceDetailScreen({required this.item, this.errorValue});

  @override
  _SdPriceDetailScreenState createState() => _SdPriceDetailScreenState();
}

class _SdPriceDetailScreenState extends State<SdPriceDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  Map<String, Map<DateTime, double>> allData = {
    '특': {},
    '상': {},
    '중': {},
    '하': {}
  };
  Map<DateTime, double> currentData = {};
  String currentCategory = '특';
  Duration visibleDuration = const Duration(days: 365);
  double averagePrice = 0.0;
  double maxPrice = 0.0;
  double minPrice = 0.0;
  double nowPrice = 0.0;
  double nowChange = 0.0;
  double nowChangePercent = 0.0;
  String name = '';
  Map<String, Map<String, double>> stats = {
    '특': {'average': 0.0, 'max': 0.0, 'min': 0.0},
    '상': {'average': 0.0, 'max': 0.0, 'min': 0.0},
    '중': {'average': 0.0, 'max': 0.0, 'min': 0.0},
    '하': {'average': 0.0, 'max': 0.0, 'min': 0.0}
  };
  Map<String, Map<String, double>> nowStats = {
    '특': {'nowPrice': 0.0, 'nowChange': 0.0, 'nowChangePercent': 0.0},
    '상': {'nowPrice': 0.0, 'nowChange': 0.0, 'nowChangePercent': 0.0},
    '중': {'nowPrice': 0.0, 'nowChange': 0.0, 'nowChangePercent': 0.0},
    '하': {'nowPrice': 0.0, 'nowChange': 0.0, 'nowChangePercent': 0.0},
  };

  @override
  void initState() {
    super.initState();
    fetchItemPrices();
  }

  void fetchItemPrices() async {
    var queryParams = {'pum_nm': widget.item.name};

    var data = await ApiService().getYearPrices(queryParams: queryParams);

    if (data != null) {
      Map<String, String> categories = {
        '특': 'av_p_t',
        '상': 'av_p_h',
        '중': 'av_p_m',
        '하': 'av_p_l'
      };

      bool foundValidData = false;
      categories.forEach((key, value) {
        if (data[value] != null) {
          List<double> prices = [];
          Map<DateTime, double> formattedData = {};
          data[value].forEach((dateKey, priceValue) {
            double? price = priceValue?.toDouble();
            if (price != null) {
              prices.add(price);
              formattedData[DateTime.parse(dateKey)] = price;
            }
          });
          if (formattedData.isNotEmpty) {
            allData[key] = formattedData;
            double average = prices.reduce((a, b) => a + b) / prices.length;
            double max = prices.reduce((a, b) => a > b ? a : b);
            double min = prices.reduce((a, b) => a < b ? a : b);
            stats[key] = {'average': average, 'max': max, 'min': min};
            nowStats[key] = {
              'nowPrice': prices.last.round().toDouble(),
              'nowChange':
              (prices.last - prices[prices.length - 2]).round().toDouble(),
              'nowChangePercent': ((prices.last - prices[prices.length - 2]) /
                  prices[prices.length - 2] *
                  100)
                  .round()
                  .toDouble()
            };
            if (!foundValidData) {
              foundValidData = true;
              currentCategory = key; // 첫 번째 유효한 데이터 등급으로 변경
            }
          }
        } else {
          print('No data for category: $key'); // 로그 추가
        }
      });

      if (!foundValidData) {
        print('No valid data found across all categories.');
        // 모든 카테고리에 유효한 데이터가 없는 경우 사용자에게 알림
      }

      if (mounted) {
        setState(() {
          updateCategory(currentCategory);
        });
      }
    } else {
      print('Failed to fetch data.');
    }
  }

  void updateCategory(String category) {
    if (allData.containsKey(category)) {
      setState(() {
        currentCategory = category;
        currentData = allData[category]!;
        averagePrice = stats[category]!['average'] ?? 0.0;
        maxPrice = stats[category]!['max'] ?? 0.0;
        minPrice = stats[category]!['min'] ?? double.infinity;
        nowPrice = nowStats[category]!['nowPrice'] ?? 0.0;
        nowChange = nowStats[category]!['nowChange'] ?? 0.0;
        nowChangePercent = nowStats[category]!['nowChangePercent'] ?? 0.0;
        name = widget.item.itemName;
      });
    } else {
      print('No data available for category: $category');
    }
  }

  void updateDuration(int days) {
    setState(() {
      visibleDuration = Duration(days: days);
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(visibleDuration);

      // 현재 카테고리의 모든 데이터 중, startDate 이후의 데이터만 필터링
      Map<DateTime, double> filteredData = {};
      allData[currentCategory]!.forEach((date, value) {
        if (date.isAfter(startDate)) {
          filteredData[date] = value;
        }
      });

      currentData = filteredData;
    });
  }

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
              body: Stack(
                children: [
                  _buildBody(customUser),
                  InquiryButton(
                    item: {
                      'name': widget.item.name,
                      'item': widget.item.itemName,
                    },
                    currentGrade: currentCategory,
                  ),
                ],
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
              body: Stack(
                children: [
                  _buildBody(customUser),
                  InquiryButton(
                    item: {
                      'name': widget.item.name,
                      'item': widget.item.itemName,
                    },
                    currentGrade: currentCategory,
                  ),
                ],
              ),
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
            body: Stack(
              children: [
                _buildBody(customUser),
                InquiryButton(
                  item: {
                    'name': widget.item.name,
                    'item': widget.item.itemName,
                  },
                  currentGrade: currentCategory,
                ),
              ],
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

  Widget _buildBody(CustomUser? customUser) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children:[
        Center(
          child: SizedBox(
            width: screenWidth > 1200 ? 1200 : screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  TopPriceDetail(
                    item: widget.item,
                    nowPrice: nowPrice,
                    nowChange: nowChange,
                    nowChangePercent: nowChangePercent,
                    errorValue: widget.errorValue,
                  ),
                  PriceChart(data: currentData),
                  CategoryDurationSelector(
                    currentCategory: currentCategory,
                    currentDuration: visibleDuration.inDays,
                    onCategorySelected: updateCategory,
                    onDurationSelected: updateDuration,
                  ),
                  MarketPricesList(
                    averagePrice: averagePrice,
                    maxPrice: maxPrice,
                    minPrice: minPrice,
                    currentData: currentData,
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        InquiryButton(
          item: {
            'name': widget.item.name,
            'item': widget.item.itemName,
          },
          currentGrade: currentCategory,
        ),
      ]
    );
  }
}
