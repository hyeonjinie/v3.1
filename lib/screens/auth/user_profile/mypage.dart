import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../domain/models/custom_user.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../../widgets/navigation_helper.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late double buttonSpacing;

  @override
  Widget build(BuildContext context) {
    buttonSpacing = MediaQuery.of(context).size.width > 600 ? 40 : 20;

    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            scaffoldKey: _scaffoldKey,
            selectedIndex: 0,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          ),
          body: _buildBody(user),
          bottomNavigationBar: constraints.maxWidth <= 660
              ? CustomBottomNavigationBar(
            selectedIndex: 0,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          )
              : null,
        );
      },
    );
  }

  void _updateIndex(int index) {
    setState(() {
      // Update your state
    });
  }

  Widget _buildBody(CustomUser? user) {
    if (user == null) {
      return Center(child: Text('로그인이 필요합니다.'));
    }

    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SizedBox(height: 25),
              // 상단 정보
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16,
                ),
                width: double.infinity,
                color: Color(0xFFF5F8FF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${user.companyName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(context, FontSizeType.extraLarge),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${user.email}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Navigate to profile edit screen
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Color(0xFF00AF66),
                          //     side: const BorderSide(color: Color(0xFF00AF66), width: 1),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(26),
                          //     ),
                          //     minimumSize: Size(140, 50),
                          //     elevation: 0,
                          //   ),
                          //   child: Text(
                          //     '정보 수정',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: getFontSize(context, FontSizeType.medium),
                          //       fontWeight: FontWeight.w700,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthProviderService>().signOut(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF00AF66), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              minimumSize: Size(140, 50),
                              elevation: 0,
                            ),
                            child: Text(
                              '로그아웃',
                              style: TextStyle(
                                color: Color(0xFF00AF66),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Sections in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 비굿마켓 관리
                  Expanded(
                    child: _buildSection(
                      '비굿마켓 관리',
                      [
                        _buildButton('assets/png/won.png', '구매내역', '/product_order_list_screen'),
                        _buildButton('assets/png/cart.png', '장바구니', '/cart_screen'),
                      ],
                    ),
                  ),
                  SizedBox(width: buttonSpacing),

                  // 선도거래 관리
                  Expanded(
                    child: _buildSection(
                      '선도거래 관리',
                      [
                        _buildButton('assets/png/info.png', '문의관리', '/inquiry_management_screen'),
                        _buildButton('assets/png/list.png', '주문관리', '/order_management_screen'),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(color: Colors.grey[300]),
              ),

              // User profile details
              _buildUserProfile(user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(CustomUser user) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // 기업 정보
              Container(
                padding: EdgeInsets.only(top: 20, left: 25),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '기업 정보',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '대표자명',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.representativeName}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '업태',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.businessType}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '종목',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.businessField}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double maxWidth = constraints.maxWidth > 200 ? 200 : constraints.maxWidth;

                              return SizedBox(
                                width: maxWidth,
                                child: Text(
                                  '사업자 등록증',
                                  style: TextStyle(
                                    color: Color(0xFF323232),
                                    fontSize: getFontSize(context, FontSizeType.medium),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                          user.uploadedFileURL == null
                              ? Text('')
                              : Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                                            maxHeight: MediaQuery.of(context).size.height * 0.9,
                                          ),
                                          child: Image.network(
                                            user.uploadedFileURL!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Text('닫기'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    user.uploadedFileURL!,
                                    width: 200,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '확대해서 보기',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: getFontSize(context, FontSizeType.small),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // 담당자 정보
              Container(
                padding: EdgeInsets.only(top: 40, left: 25),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '담당자 정보',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '담당자명',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.contactPersonName}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '연락처',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.contactPersonPhoneNumber}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '이메일',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.contactPersonEmail}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 기타 정보
              Container(
                padding: EdgeInsets.only(top: 40, left: 25, bottom: 20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '기타 정보',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '사업장 주소',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.businessAddress}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '연락처',
                              style: TextStyle(
                                color: Color(0xFF323232),
                                fontSize: getFontSize(context, FontSizeType.medium),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${user.companyTelNumber}',
                            style: TextStyle(
                              color: Color(0xFF323232),
                              fontSize: getFontSize(context, FontSizeType.medium),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 섹션 생성 ui
  Widget _buildSection(String title, List<Widget> buttons) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD3D3D3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: getFontSize(context, FontSizeType.medium),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons.map((button) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: button,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 이미지 버튼 생성 ui
  Widget _buildButton(String assetPath, String label, String route) {
    return InkWell(
      onTap: () {
        context.go(route);
      },
      child: Column(
        children: [
          Image.asset(
            assetPath,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF323232),
              fontSize: getFontSize(context, FontSizeType.medium),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
