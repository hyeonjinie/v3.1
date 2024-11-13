import 'package:flutter/material.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';

import '../../../widgets/custom_appbar/global_custom_appbar.dart';

class FullMarketInfoList extends StatefulWidget {
  const FullMarketInfoList();

  @override
  _FullMarketInfoListState createState() => _FullMarketInfoListState();
}

class _FullMarketInfoListState extends State<FullMarketInfoList> {
  List<Map<String, dynamic>> marketData = List.generate(
      35,
          (index) => {
        "name": "Stock ${index + 1}",
        "price": 100 + (index * 5),
        "change": index % 2 == 0 ? "+${index * 0.1}" : "-${index * 0.1}",
        "changePercent": index % 2 == 0 ? "+${index * 0.5}%" : "-${index * 0.5}%",
      });
  List<bool> favorites = List.generate(35, (index) => false);

  int displayedItems = 10;

  void _showMore() {
    setState(() {
      displayedItems += 10;
      if (displayedItems > marketData.length) {
        displayedItems = marketData.length;
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      favorites[index] = !favorites[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      child: Scaffold(
        appBar: GlobalCustomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '시세정보',
                    style: TextStyle(fontSize: getFontSize(context, FontSizeType.extraLarge), fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedItems,
                  itemBuilder: (context, index) {
                    var item = marketData[index];
                    return Card(
                      color: Colors.transparent,
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Color(0x40C6C6C6), width: 2),
                      ),
                      child: ListTile(
                        trailing: GestureDetector(
                          onTap: () => _toggleFavorite(index),
                          child: Icon(
                            favorites[index] ? Icons.favorite : Icons.favorite_border,
                            color: favorites[index] ? Colors.red : Colors.red[700],
                            size: 24,
                          ),
                        ),
                        title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("가격: ${item['price']} | 변동: ${item['change']} (${item['changePercent']})"),
                      ),
                    );
                  },
                ),
                if (displayedItems < marketData.length)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00AF66),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: _showMore,
                      child: Text("더보기", style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
