import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/screens/Inquiry/inquiry_management_screen.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

import '../../domain/models/custom_user.dart';
import '../../services/auth_provider.dart';
import '../../widgets/custom_appbar/custom_appbar.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/navigation_helper.dart';
import '../utils/date_picker.dart';
import '../utils/duration_date_picker.dart';

enum Category { general, notPretty }

class InquiryScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final String currentGrade;

  InquiryScreen({required this.item, required this.currentGrade});

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;
  final TextEditingController _durationPeriodController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _inquiryController = TextEditingController();

  Category selectedCategory = Category.general;
  String? selectedGrade;
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedGrade = widget.currentGrade;
  }

  void _getDate() async {
    final String? pickedDate = await DatePicker.selectDate(context);
    if (pickedDate != null) {
      setState(() {
        _deliveryDateController.text = pickedDate;
      });
    }
  }

  void _durationGetDate() async {
    final Map<String, String?>? dateRange =
        await DurationDatePicker.selectDateRange(context);
    if (dateRange != null) {
      String formattedRange = "${dateRange['start']} - ${dateRange['end']}";
      setState(() {
        _durationPeriodController.text = formattedRange;
        _startDateController.text = dateRange['start']!;
        _endDateController.text = dateRange['end']!;
      });
    }
  }

  Future<void> saveInquiryToFirestore({
    required String uid,
    required Map<String, dynamic> inquiryData,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('client')
          .doc(uid)
          .collection('sundoinquiry')
          .add(inquiryData);
      print('문의가 성공적으로 저장되었습니다.');
    } catch (e) {
      print('파이어스토어 저장 오류: $e');
    }
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
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(customUser),
            );
          } else {
            return Scaffold(
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
              body: _buildBody(customUser),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: (index) =>
                    NavigationHelper.onItemTapped(context, index, _updateIndex),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
              selectedIndex: _selectedIndex,
              onItemTapped: (index) =>
                  NavigationHelper.onItemTapped(context, index, _updateIndex),
            ),
            body: _buildBody(customUser),
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
    final screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleHeight = (screenHeight * 0.1).clamp(40.0, 70.0);

    String currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String companyName = customUser?.companyName ?? "YourCompany";
    String name = widget.item['name'];
    String item = widget.item['item'];

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: screenWidth > 1200 ? 1200 : screenWidth,
          child: Column(
            children: [
              const SizedBox(height: 25),
              Container(
                alignment: Alignment.centerLeft,
                color: const Color(0xFFF5F8FF),
                height: titleHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    '거래명 :  ${companyName}_${item}_${currentDateTime}',
                    style: TextStyle(
                      fontSize: getFontSize(context, FontSizeType.medium),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '문의 품목',
                      style: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text('못난이로 변경'),
                        SizedBox(width: 8),
                        Switch(
                          value: selectedCategory == Category.notPretty,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory =
                                  value ? Category.notPretty : Category.general;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFDEE6FF), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '품목 : $item  /  품종 : $name',
                        style: TextStyle(
                          fontSize: getFontSize(context, FontSizeType.medium),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '종류 : ${selectedCategory == Category.notPretty ? "못난이" : "일반"} / 등급 : ${selectedCategory == Category.notPretty ? "못난이" : selectedGrade}',
                      ),
                      if (selectedCategory == Category.notPretty) ...[
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Color(0xFF0FA958),
                              size: getFontSize(context, FontSizeType.medium),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '못난이란 흠집이나 찌그러짐 등 외관이 B급인 상품을 말하며, 맛에는 지장이 없습니다.',
                                style: TextStyle(
                                  fontSize:
                                      getFontSize(context, FontSizeType.small),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Visibility(
                  visible: selectedCategory != Category.notPretty,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['특', '상', '중', '하'].map((category) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedGrade = category;
                              });
                            },
                            style: TextButton.styleFrom(
                              fixedSize:
                                  getButtonSize(context, ButtonSizeType.medium),
                              backgroundColor: selectedGrade == category
                                  ? Color(0xFF0FA958)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color: selectedGrade == category
                                      ? Colors.transparent
                                      : Colors.grey,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: selectedGrade == category
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: selectedGrade == category
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: getFontSize(context, FontSizeType.medium),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '공급기간',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: getFontSize(context, FontSizeType.medium),
                        ),
                        children:[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: getFontSize(context, FontSizeType.small)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _durationGetDate,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _startDateController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF3F3F3),
                                  hintText: 'YYYY-MM-DD',
                                  hintStyle: const TextStyle(color: Colors.black38),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('~', style: TextStyle(fontSize: getFontSize(context, FontSizeType.small))),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _durationGetDate,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _endDateController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF3F3F3),
                                  hintText: 'YYYY-MM-DD',
                                  hintStyle: const TextStyle(color: Colors.black38),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '희망배송일',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: getFontSize(context, FontSizeType.medium),
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: getFontSize(context, FontSizeType.small),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _getDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _deliveryDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF3F3F3),
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: Colors.black38),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomInputField(
                  controller: _volumeController,
                  label: '공급물량(kg)',
                  hintText: '공급수량을 입력해주세요.',
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomInputField(
                  controller: _priceController,
                  label: '희망단가',
                  hintText: '희망단가을 입력해주세요.',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomInputField(
                  controller: _contactController,
                  label: '담당자 연락처',
                  hintText: '연락처를 입력해주세요.',
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text('※ 위 내용을 입력하여 문의 요청하시면, 확인 후 연락 드리겠습니다.',
                      style: TextStyle(
                          fontSize: getFontSize(context, FontSizeType.small)))),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final inquiryData = {
                        "title": "${companyName}_${item}_${currentDateTime}",
                        "itemName": item,
                        "variety": name,
                        "status": "대기",
                        'hVolume': _volumeController.text,
                        'hStartDate': _startDateController.text,
                        'hEndDate': _endDateController.text,
                        'hPrice': _priceController.text,
                        'hDeliveryDate': _deliveryDateController.text,
                        'contact': _contactController.text,
                        'date': currentDateTime,
                        'grade': selectedCategory == Category.notPretty
                            ? '못난이'
                            : selectedGrade,
                        'category':
                            selectedCategory == Category.notPretty ? '못난이' : '일반',
                        'totalCount': '0',
                        'unit': 'ton',
                        'totalVolume': '0',
                        'startDate': '',
                        'endDate': '',
                        "price": '',
                        'origin': '',
                        'volume': '',
                      };
                      await saveInquiryToFirestore(
                          uid: customUser!.uid, inquiryData: inquiryData);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InquiryManagementScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: getButtonSize(context, ButtonSizeType.large),
                      backgroundColor: Color(0xFF0FA958),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getFontSize(context, FontSizeType.large),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('문의 요청'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _durationPeriodController.dispose();
    _periodController.dispose();
    _priceController.dispose();
    _deliveryDateController.dispose();
    _contactController.dispose();
    _inquiryController.dispose();
    super.dispose();
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _icon(0, 'assets/bg_svg/icon-home.svg'),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: _icon(1, 'assets/bg_svg/information_center.svg'),
          label: '정보센터',
        ),
        BottomNavigationBarItem(
          icon: _icon(2, 'assets/bg_svg/question.svg'),
          label: '문의관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'),
          label: '주문관리',
        ),
        BottomNavigationBarItem(
          icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'),
          label: '비굿마켓',
        ),
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

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;

  CustomInputField({
    required this.controller,
    required this.label,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '$label',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: getFontSize(context, FontSizeType.medium),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: getFontSize(context, FontSizeType.medium),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF3F3F3),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.black38,
                fontSize: getFontSize(context, FontSizeType.medium),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDateInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final VoidCallback onTap;

  CustomDateInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '$label',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: getFontSize(context, FontSizeType.medium),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: getFontSize(context, FontSizeType.medium)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
