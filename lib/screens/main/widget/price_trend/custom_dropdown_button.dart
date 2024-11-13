import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/main/widget/price_trend/more_button.dart';
import 'package:v3_mvp/screens/main/widget/price_trend/price_trend_chart.dart';
import 'package:v3_mvp/screens/main/widget/price_trend/rolling_notification.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

import '../../../../services/provider/garak_item_provider.dart';
import '../../../../services/provider/price_provider.dart';
import '../../../../services/market_data_service.dart';
import '../../../../domain/models/item.dart'; // Item 모델 임포트

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton();

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String selectedMarket = '가락';
  String selectedFruit = '';
  String selectedVariety = '';
  String selectedGrade = '';
  List<String> varieties = [];
  List<bool> buttonStates = [];
  List<String> availableGrades = [];
  bool _isDataLoaded = false; // 데이터 로드 상태를 추적하는 변수 추가

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDataLoaded) {
        _isDataLoaded = true; // 데이터를 로드 상태로 변경
        Provider.of<GarakItemProvider>(context, listen: false)
            .fetchGarakItems()
            .then((_) {
          final garakProvider =
          Provider.of<GarakItemProvider>(context, listen: false);
          if (garakProvider.items.isNotEmpty) {
            setState(() {
              selectedFruit = garakProvider.items.first.name;
              varieties = garakProvider.items.first.varieties;
              selectedVariety = varieties.isNotEmpty ? varieties.first : '';
            });
            fetchInitialPriceData();
          }
        });
      }
    });
  }

  Future<void> fetchInitialPriceData() async {
    if (selectedFruit.isNotEmpty && selectedVariety.isNotEmpty) {
      await Provider.of<PriceProvider>(context, listen: false)
          .fetchPriceData(selectedFruit, selectedVariety);
      updateAvailableGrades();
    }
  }

  void updateAvailableGrades() {
    final priceProvider = Provider.of<PriceProvider>(context, listen: false);
    List<String> grades = ['특', '상', '중', '하'];
    availableGrades = grades.where((grade) {
      return priceProvider.getGradeData(grade).isNotEmpty;
    }).toList();

    setState(() {
      if (availableGrades.isNotEmpty) {
        selectedGrade = availableGrades.first;
        buttonStates = List<bool>.filled(availableGrades.length, false);
        buttonStates[0] = true;
      } else {
        selectedGrade = '';
        buttonStates = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 1200
        ? 1200
        : (screenWidth > 600 ? screenWidth : screenWidth - 60);

    return Consumer3<GarakItemProvider, PriceProvider, MarketDataService>(
      builder: (context, garakProvider, priceProvider, marketDataService, child) {
        if (garakProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (garakProvider.errorMessage.isNotEmpty) {
          return Center(child: Text(garakProvider.errorMessage));
        } else if (garakProvider.items.isEmpty) {
          return const Center(child: Text('No items available'));
        } else {
          final fruitItems =
          garakProvider.items.map((item) => item.name).toList();
          final varietyItems =
          garakProvider.items.map((item) => item.varieties).toList();

          if (!fruitItems.contains(selectedFruit) && fruitItems.isNotEmpty) {
            selectedFruit = fruitItems.first;
            final index = fruitItems.indexOf(selectedFruit);
            varieties = varietyItems[index];
            selectedVariety = varieties.isNotEmpty ? varieties.first : '';
          }

          final selectedItem = Item(
            name: selectedVariety,
            price: '0',
            change: '0',
            changePercent: '0',
            isPredict: 0.0,
            itemName: selectedVariety,
          );

          return Column(
            children: [
              SizedBox(
                width: screenWidth > 1200 ? 1200 : screenWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('시세정보',
                        style: TextStyle(
                            fontSize:
                            getFontSize(context, FontSizeType.extraLarge),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: screenWidth > 1200 ? 1200 : screenWidth,
                color: const Color(0xFFF6F6F6),
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: SizedBox(
                    width: containerWidth,
                    child: Column(
                      children: [
                        buildDropdowns(fruitItems, varietyItems),
                        const SizedBox(height: 8),
                        buildGradeButtons(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              if (priceProvider.isLoading)
                const CircularProgressIndicator()
              else if (priceProvider.errorMessage.isNotEmpty)
                Text(priceProvider.errorMessage)
              else if (priceProvider.priceData.isNotEmpty)
                  PriceTrendChart(
                      data: priceProvider.getGradeData(selectedGrade)),
              const SizedBox(height: 8),
              MoreButton(
                selectedVariety: selectedItem,
                marketDataService: marketDataService,
              ),
              const SizedBox(height: 8),
              // const RollingNotification(),
            ],
          );
        }
      },
    );
  }

  Widget buildDropdowns(List<String> fruitItems, List<List<String>> varietyItems) {
    final index = fruitItems.indexOf(selectedFruit);
    final currentVarieties = index != -1 ? varietyItems[index] : <String>[];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          // child: buildDropdown('Market', selectedMarket, ['가락', '전국']),
          child: buildDropdown('Market', selectedMarket, ['가락']),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: buildDropdown('Fruit', selectedFruit, fruitItems),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: buildDropdown('Variety', selectedVariety, currentVarieties),
        ),
      ],
    );
  }

  Widget buildDropdown(String key, String value, List<String> items) {
    final validValue =
    items.contains(value) ? value : (items.isNotEmpty ? items.first : null);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: (getFontSize(context, FontSizeType.small) / 2),
          ),
        ),
        value: validValue,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
                fontSize: getFontSize(context, FontSizeType.small)),
          ),
        ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            updateSelectedValue(key, newValue);
          });
        },
        dropdownColor: Colors.white,
        menuMaxHeight: 200, // 드롭다운 최대 높이 설정
      ),
    );
  }

  Widget buildGradeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: availableGrades
          .asMap()
          .entries
          .map((entry) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ElevatedButton(
            onPressed: () {
              updateButtonState(entry.key);
              final grade = availableGrades[entry.key];
              setState(() {
                selectedGrade = grade;
              });
            },
            style: ElevatedButton.styleFrom(
              fixedSize: getButtonSize(context, ButtonSizeType.medium),
              backgroundColor: buttonStates[entry.key]
                  ? const Color(0xFF11C278)
                  : Colors.white,
              disabledForegroundColor: buttonStates[entry.key]
                  ? const Color(0xFFD9D9D9)
                  : Colors.white,
              disabledBackgroundColor: buttonStates[entry.key]
                  ? const Color(0xFFD9D9D9)
                  : Colors.white.withOpacity(0.12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                      color: Color(0xFFD9D9D9), width: 1)),
              elevation: 0,
            ),
            child: Text(entry.value,
                style: TextStyle(
                  fontSize: getFontSize(context, FontSizeType.medium),
                  color: buttonStates[entry.key]
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ))
          .toList(),
    );
  }

  void updateSelectedValue(String key, String? newValue) {
    if (newValue == null) return;
    setState(() {
      switch (key) {
        case 'Market':
          selectedMarket = newValue;
          break;
        case 'Fruit':
          selectedFruit = newValue;
          final garakProvider =
          Provider.of<GarakItemProvider>(context, listen: false);
          final varietyItems =
          garakProvider.items.map((item) => item.varieties).toList();
          final index =
          garakProvider.items.indexWhere((item) => item.name == selectedFruit);
          if (index != -1) {
            final currentVarieties = varietyItems[index];
            selectedVariety =
            currentVarieties.isNotEmpty ? currentVarieties.first : '';
            varieties = currentVarieties;
          }
          fetchInitialPriceData();
          break;
        case 'Variety':
          selectedVariety = newValue;
          fetchInitialPriceData();
          break;
      }
    });
  }

  void updateButtonState(int index) {
    setState(() {
      for (int i = 0; i < buttonStates.length; i++) {
        buttonStates[i] = i == index;
      }
    });
  }
}
