import 'package:flutter/material.dart';

class NewSubscription extends StatefulWidget {
  const NewSubscription({Key? key}) : super(key: key);

  @override
  _NewSubscriptionState createState() => _NewSubscriptionState();
}

class _NewSubscriptionState extends State<NewSubscription> {
  final List<Map<String, dynamic>> categories = [
    {
      "level": 1,
      "options": ["가격예측"]
    },
    {
      "level": 2,
      "options": ["D+7", "D+15", "D+30"]
    },
    {
      "level": 3,
      "options": ["경매", "도매", "소매", "수입"]
    },
    {
      "level": 4,
      "options": ["농산물", "축산물", "수산물", "가공식품"]
    },
    {
      "level": 5,
      "options": ["과일", "채소", "기타"]
    },
    {
      "level": 6,
      "options": ["과실류", "잎채류", "뿌리채소"]
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "딸기",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15", "D+30"],
        "markets": ["경매", "도매", "소매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "사과",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15"],
        "markets": ["도매", "소매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "포도",
      "price": 500000,
      "filters": {
        "terms": ["D+15", "D+30"],
        "markets": ["도매", "수입"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "상추",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15"],
        "markets": ["경매"],
        "category": "농산물",
        "subtype": "채소",
        "detail": "잎채류"
      }
    },
    {
      "name": "감자",
      "price": 500000,
      "filters": {
        "terms": ["D+15", "D+30"],
        "markets": ["도매", "소매"],
        "category": "농산물",
        "subtype": "채소",
        "detail": "뿌리채소"
      }
    }
  ];

  Map<int, String> selectedFilters = {}; // 사용자가 선택한 필터 저장
  List<Map<String, dynamic>> selectedProducts = []; // 선택된 조건에 맞는 제품

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters as Buttons
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  int level = index + 1;
                  List<String> options = categories[index]['options'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level $level',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: options.map((option) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFilters[level] = option; // 필터 저장
                                if (level == categories.length) {
                                  filterProducts(); // 마지막 Level에서 필터링 실행
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedFilters[level] == option
                                  ? Colors.green
                                  : Colors.grey[300],
                              foregroundColor: selectedFilters[level] == option
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            // Selected Products
            const Text(
              '선택된 품목',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: selectedProducts.isEmpty
                  ? const Center(child: Text("조건에 맞는 품목이 없습니다."))
                  : ListView.builder(
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        final product = selectedProducts[index];
                        return Card(
                          child: ListTile(
                            title: Text(product['name']),
                            subtitle: Text("Price: ${product['price']}원"),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            // Subscribe Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '1,000,000원',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Subscription logic
                  },
                  child: const Text('구독하기'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void filterProducts() {
    setState(() {
      selectedProducts = products.where((product) {
        final filters = product['filters'];
        return selectedFilters.entries.every((entry) {
          final level = entry.key;
          final value = entry.value;
          final filterKey = mapLevelToFilterKey(level);
          final filterValue = filters[filterKey];
          if (filterValue is List) {
            return filterValue.contains(value);
          }
          return filterValue == value;
        });
      }).toList();
    });
  }

  String mapLevelToFilterKey(int level) {
    switch (level) {
      case 2:
        return "terms";
      case 3:
        return "markets";
      case 4:
        return "category";
      case 5:
        return "subtype";
      case 6:
        return "detail";
      default:
        return "";
    }
  }
}
