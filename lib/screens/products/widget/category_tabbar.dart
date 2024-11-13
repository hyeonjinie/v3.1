import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryTabBar extends StatefulWidget {
  const CategoryTabBar();

  @override
  _CategoryTabBarState createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Map<String, List<String>> categorySubcategories = {
    '농산물': ['전체', '과실류', '과채류', '채소류', '곡류', '서류', '버섯류', '기타'],
    '수산물': ['전체', '어류', '패류', '갑각류'],
    '축산물': ['전체', '소고기', '돼지고기', '닭고기'],
    '가공식품': ['전체', '조리식품', '저장식품'],
    '반찬가게': ['전체', '반찬', '김치'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  List<String> activeSubcategories = [];

  void _handleTabSelection() {
    setState(() {
      activeSubcategories = categorySubcategories[_tabController!.index == 0
              ? '농산물'
              : _tabController!.index == 1
                  ? '농산물'
                  : _tabController!.index == 2
                      ? '수산물'
                      : _tabController!.index == 3
                          ? '축산물'
                          : _tabController!.index == 4
                              ? '가공식품'
                              : '반찬가게'] ??
          [];
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
              tabs: const [
                Tab(text: "전체"),
                Tab(text: "농산물"),
                Tab(text: "수산물"),
                Tab(text: "축산물"),
                Tab(text: "가공식품"),
                Tab(text: "반찬가게"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProductList("전체"),
                  _buildCategoryView("농산물"),
                  _buildCategoryView("수산물"),
                  _buildCategoryView("축산물"),
                  _buildCategoryView("가공식품"),
                  _buildCategoryView("반찬가게"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryView(String category) {
    List<String> subcategories = categorySubcategories[category] ?? [];
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: subcategories
                .map((subcategory) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ActionChip(
                        label: Text(subcategory),
                        onPressed: () {
                          print('Selected $subcategory');
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(child: _buildProductList(category)),
      ],
    );
  }

  Widget _buildProductList(String category) {
    final products = List<Map<String, dynamic>>.generate(100, (index) {
      return {
        'name': '$category Product $index',
        'image': 'assets/images/product_$index.jpg',
        'price': 1000 + index * 50,
      };
    });

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Image.asset(product['image'], fit: BoxFit.cover),
              ),
              Text(product['name'], style: const TextStyle(fontSize: 16)),
              Text('${NumberFormat("#,###").format(product['price'])}원',
                  style: const TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
        );
      },
    );
  }
}
