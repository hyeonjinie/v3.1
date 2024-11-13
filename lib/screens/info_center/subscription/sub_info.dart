import 'package:flutter/material.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

class SubsInfoPage extends StatefulWidget {
  const SubsInfoPage({Key? key}) : super(key: key);

  @override
  State<SubsInfoPage> createState() => _SubsInfoPageState();
}

class _SubsInfoPageState extends State<SubsInfoPage> {
  bool isBundleSelected = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void _toggleSelection() {
    setState(() {
      isBundleSelected = !isBundleSelected;
      if (isBundleSelected) {
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerSize = screenWidth > 1200 ? (1200 / 2) - 30 : (screenWidth / 2) - 30;

    return SingleChildScrollView(
      child: Container(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Color(0xFFF6F6F6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'BPI(B・good Price Index): 농산물을 구입할 때 지불하는 가격의 평균변동을 측정한 수치입니다. (기준: 2020년 평균가격)\n\n'
                          '메뉴지수: 음식에 사용되는 농산물의 가격의 평균변동을 측정한 수치로 소매가격을 기준으로 구성되어 있습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getFontSize(context, FontSizeType.small), color: Colors.black),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton('묶음지수', isBundleSelected, _toggleSelection),
                        SizedBox(width: 8.0),
                        _buildButton('메뉴지수', !isBundleSelected, _toggleSelection),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF11C278) : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected ? Color(0xFF11C278) : Color(0xFFE6E6E6),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

}