import 'package:flutter/material.dart';
import '../../../widgets/font_size_helper/font_size_helper.dart';


class CustomScrollableTabBar extends StatefulWidget {
  final TabController tabController;
  final List<String>? tabs;

  const CustomScrollableTabBar(
      {Key? key, required this.tabController, this.tabs})
      : super(key: key);

  @override
  _CustomScrollableTabBarState createState() => _CustomScrollableTabBarState();
}

class _CustomScrollableTabBarState extends State<CustomScrollableTabBar> {
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs?.length ?? 0,
        itemBuilder: (context, index) {
          bool isActive = widget.tabController.index == index;
          return GestureDetector(
            onTap: () {
              widget.tabController.animateTo(index);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                widget.tabs?[index] ?? '',
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: getFontSize(context, FontSizeType.medium),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
