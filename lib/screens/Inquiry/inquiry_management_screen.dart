import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/custom_appbar/custom_appbar.dart';
import '../../domain/models/sd_order.dart';
import '../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../widgets/navigation_helper.dart';
import '../utils/number_formatter.dart';
import 'package:intl/intl.dart';

class InquiryManagementScreen extends StatefulWidget {
  @override
  InquiryManagementScreenState createState() => InquiryManagementScreenState();
}

class InquiryManagementScreenState extends State<InquiryManagementScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;
  late Future<Map<String, List<QueryDocumentSnapshot>>> futureData;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProviderService>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      futureData = _fetchData(user.uid);
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, List<QueryDocumentSnapshot>>> _fetchData(String userId) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('client')
        .doc(userId)
        .collection('sundoinquiry')
        .get();

    var docs = querySnapshot.docs;

    Map<String, List<QueryDocumentSnapshot>> categorizedData = {
      '대기': [],
      '진행': []
    };

    for (var doc in docs) {
      var status = doc['status'] as String;
      if (categorizedData.containsKey(status)) {
        categorizedData[status]!.add(doc);
      }
    }

    return categorizedData;
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _removeInquiry(String docId) {
    setState(() {
      futureData = futureData.then((categorizedData) {
        categorizedData['진행'] =
            categorizedData['진행']!.where((doc) => doc.id != docId).toList();
        return categorizedData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

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
              body: _buildBody(user, context),
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
              body: _buildBody(user, context),
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
            body: _buildBody(user, context),
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

  Widget _buildBody(user, context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalInset = screenWidth * 0.1;
    if (horizontalInset < 20) horizontalInset = 20;
    if (horizontalInset > 300) horizontalInset = 300;

    return FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('주문 내역이 없습니다.'));
        }

        var data = snapshot.data!;
        var waitingList = data['대기']!;
        var inProgressList = data['진행']!;

        return DefaultTabController(
          length: 2,
          child: Center(
            child: SizedBox(
              width: screenWidth > 1200 ? 1200 : screenWidth,
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[700],
                    labelStyle: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium)),
                    indicatorColor: Color(0xFF00AF66),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                    tabs: [
                      Tab(text: '대기'),
                      Tab(text: '진행'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInquiryList(waitingList),
                        _buildInquiryList(inProgressList),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInquiryList(List<QueryDocumentSnapshot> documents) {
    if (documents.isEmpty) {
      return Center(child: Text('주문 내역이 없습니다.'));
    }

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        var doc = documents[index];
        var data = doc.data() as Map<String, dynamic>;
        var docPath = doc.reference.path; // 문서의 전체 경로를 가져옴

        String formattedDate;
        if (data['date'] is Timestamp) {
          formattedDate = DateFormat('yyyy-MM-dd')
              .format((data['date'] as Timestamp).toDate());
        } else if (data['date'] is String) {
          formattedDate = data['date'];
        } else {
          formattedDate = 'Unknown date';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFFF6F6F6),
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    '거래명  :  ${data['title']}',
                    style: TextStyle(
                        fontSize: getFontSize(context, FontSizeType.medium),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer()
                ],
              ),
            ),
            if (data['status'] == '대기')
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize:
                              getFontSize(context, FontSizeType.small),
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${data['variety']}',
                          style: TextStyle(
                              fontSize:
                              getFontSize(context, FontSizeType.large),
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004629)),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '(${data['grade']})',
                          style: TextStyle(
                              fontSize:
                              getFontSize(context, FontSizeType.medium),
                              color: Color(0xFF004629)),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      children: [
                        Text('공급물량',
                            style: TextStyle(
                                fontSize:
                                getFontSize(context, FontSizeType.medium))),
                        Spacer(),
                        Text(
                          '${data['hVolume'] != null ? NumberFormatter.formatNumber(double.tryParse(data['hVolume'].toString()) ?? 0) : '-'} kg',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                              getFontSize(context, FontSizeType.large),
                              color: Color(0xFF4470F6)),
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Text('공급기간',
                            style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.medium))),
                        Spacer(),
                        Text(
                          '${data['hStartDate'] ?? '-'} ~ ${data['hEndDate'] ?? '-'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(context, FontSizeType.large),
                              color: Color(0xFF4470F6)),
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Text('희망가격',
                            style: TextStyle(
                                fontSize:
                                getFontSize(context, FontSizeType.medium))),
                        Spacer(),
                        Text(
                          '${data['hPrice'] != null ? NumberFormatter.formatNumber(double.tryParse(data['hPrice'].toString()) ?? 0) : '-'} 원',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                              getFontSize(context, FontSizeType.large),
                              color: Color(0xFF4470F6)),
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Text('희망배송일',
                            style: TextStyle(
                                fontSize:
                                getFontSize(context, FontSizeType.medium))),
                        Spacer(),
                        Text(
                          '${data['hDeliveryDate']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                              getFontSize(context, FontSizeType.large),
                              color: Color(0xFF4470F6)),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Divider(color: Colors.grey),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            if (data['status'] == '진행')
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize:
                                  getFontSize(context, FontSizeType.small),
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${data['variety']}',
                              style: TextStyle(
                                fontSize:
                                getFontSize(context, FontSizeType.large),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004629),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              '(${data['grade']})',
                              style: TextStyle(
                                fontSize:
                                getFontSize(context, FontSizeType.medium),
                                color: Color(0xFF004629),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          children: [
                            Text('확정단가',
                                style: TextStyle(
                                    fontSize: getFontSize(
                                        context, FontSizeType.medium))),
                            Spacer(),
                            Text(
                                '${data['price'] != null ? NumberFormatter.formatNumber(double.tryParse(data['price'].toString()) ?? 0) : '-'} 원',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(
                                        context, FontSizeType.large),
                                    color: Color(0xFFFF7070))),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text('확정물량',
                                style: TextStyle(
                                    fontSize: getFontSize(
                                        context, FontSizeType.medium))),
                            Spacer(),
                            Text(
                                '${data['totalVolume'] != null ? NumberFormatter.formatNumber(double.tryParse(data['totalVolume'].toString()) ?? 0) : '-'} kg',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(
                                        context, FontSizeType.large),
                                    color: Color(0xFFFF7070))),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text('공급기간',
                                style: TextStyle(
                                    fontSize: getFontSize(
                                        context, FontSizeType.medium))),
                            Spacer(),
                            Text('${data['startDate'] ?? '-'} ~ ${data['endDate'] ?? '-'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getFontSize(
                                        context, FontSizeType.large),
                                    color: Color(0xFFFF7070))),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text('원산지',
                                style: TextStyle(
                                    fontSize: getFontSize(
                                        context, FontSizeType.medium))),
                            Spacer(),
                            Text(
                              '${data['origin'] ?? '-'}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  getFontSize(context, FontSizeType.large),
                                  color: Color(0xFFFF7070)),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            _showAgreementDialog(context, data, docPath);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                            getButtonSize(context, ButtonSizeType.medium),
                            backgroundColor: Color(0xFF00AF66),
                          ),
                          child: Text('약관동의',
                              style: TextStyle(
                                  fontSize:
                                  getFontSize(context, FontSizeType.medium),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 30.0),
                        Divider(color: Colors.grey),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _icon(int index, String assetName) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      color: _selectedIndex == index ? Colors.green : Colors.grey,
    );
  }

  void _showAgreementDialog(
      BuildContext context, Map<String, dynamic> data, String docPath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool agree1 = false;
        bool agree2 = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '약관 동의',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "선도거래 이용약관",
                                style: TextStyle(
                                  fontSize: getFontSize(context, FontSizeType.medium),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: agree1,
                              onChanged: (value) {
                                setState(() {
                                  agree1 = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '''
선도거래 이용약관

제1조 (목적) 
이 약관은 (주)에스앤이컴퍼니 (이하 "회사"라 한다)가 제공하는 농산물 선도거래 서비스 (이하 "서비스"라 한다)를 이용함에 있어 회사와 이용자의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.
제2조 (정의)
1.	"이용자"란 이 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 말합니다.
2.	"선도거래"란 이용자 간에 미래의 특정 시점에 농산물을 정해진 가격에 거래하기로 하는 계약을 의미합니다.
3.	"농산물"이란 선도거래의 대상이 되는 모든 농수축산물을 말합니다.
4.	"계약"이란 이용자 간에 체결된 선도거래 계약을 의미합니다.
5.	"기업"이란 농산물을 구매하는 기업을 의미합니다.
6.	"농가"란 농산물을 생산하고 판매하는 농업 생산자를 의미합니다.
7.	기타 정의되지 않은 사항은 일반적인 전자상거래법에 따릅니다.
제3조 (약관의 효력 및 변경)
1.	이 약관은 이용자가 동의함으로써 효력이 발생합니다.
2.	회사는 필요한 경우 관련 법령을 위반하지 않는 범위 내에서 이 약관을 변경할 수 있으며, 변경된 약관은 회사의 웹사이트에 게시함으로써 효력이 발생합니다.
3.	이용자는 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 회원탈퇴를 할 수 있습니다.
제4조 (이용계약의 체결)
1.	이용계약은 이용자가 이 약관에 동의하고, 회사가 정한 절차에 따라 서비스 이용을 신청한 후, 회사가 이를 승낙함으로써 체결됩니다.
2.	이용자는 서비스 신청 시 필요한 모든 정보를 정확하게 제공하여야 합니다.
3.	회사는 다음 각 호에 해당하는 신청에 대해서는 승낙을 하지 않을 수 있습니다.
①	타인의 명의를 사용하거나 허위 정보를 제공한 경우
②	기타 회사의 기준에 부합하지 않는 경우
제5조 (서비스의 제공 및 중단)
1.	회사는 이용자에게 다음과 같은 서비스를 제공합니다.
①	농산물 선도거래 서비스
②	거래 관련 정보 제공 서비스
2.	회사는 다음 각 호의 경우 서비스 제공을 중단할 수 있습니다.
①	시스템 점검 및 유지보수
②	천재지변 등 불가항력적인 사유
3.	회사는 사전 공지 없이 서비스 내용을 변경할 수 없으며, 변경된 내용은 사이트에 게시합니다.
제6조 (이용자의 의무)
1.	이용자는 서비스 이용 시 관련 법령 및 이 약관을 준수하여야 합니다.
2.	이용자는 허위 정보 제공, 타인의 명의 도용 등의 행위를 해서는 안 됩니다.
3.	이용자는 서비스 이용 시 발생하는 모든 활동에 대해 책임을 집니다.
제7조 (선도거래의 유형 및 성립)
1.	회사와 기업 간의 선도거래: 회사가 농산물을 기업에 납품하는 계약.
2.	회사와 농가 간의 선도거래: 농가가 농산물을 회사에 납품하는 계약.
3.	기업과 농가 간의 선도거래: 농가가 농산물을 기업에 납품하는 계약.
4.	각 유형의 거래는 이용자 간의 계약 체결로 성립됩니다.
제8조 (거래의 해지 및 변경)
1.	이용자는 계약 체결 후 상대방의 동의 없이 거래를 해지할 수 없습니다.
2.	계약 내용 변경 시에는 당사자 간 협의 후 변경된 조건을 회사에 통지하여야 합니다.
제9조 (대금 결제)
1.	대금 결제는 계약 체결 시 정한 방식에 따라 이루어집니다.
2.	이용자는 대금 결제와 관련된 모든 정보를 정확하게 제공하여야 합니다.
3.	이용자가 제공한 결제 정보에 오류가 있는 경우 발생하는 모든 책임은 이용자에게 있습니다.
제10조 (납품 및 인도)
1.	농산물의 납품은 계약에서 정한 일자와 장소, 가격에 이루어져야 하며 변경이 필요한 경우 상대방의 동의를 받아야합니다.
2.	이용자는 납품 시 농산물의 품질, 수량, 포장 상태 등을 확인할 의무가 있습니다.
제11조 (품질 보증 및 클레임)
1.	농산물의 품질은 계약 시 정한 기준을 충족해야 합니다.
2.	이용자는 농산물 수령 후 일정 기간 내에 품질 문제를 제기할 수 있으며, 이 기간은 계약에서 정합니다.
3.	품질 문제 발생 시, 당사자 간 협의를 통해 문제를 해결하며, 필요한 경우 회사의 중재를 요청할 수 있습니다.
제12조 (책임 및 면책)
1.	불가항력에 대한 면책
①	회사는 천재지변, 전쟁, 정부의 규제 등 불가항력적인 사유로 인해 서비스를 제공할 수 없는 경우 책임을 지지 않습니다.
②	불가항력적인 사유로 인해 계약 이행이 불가능한 경우, 계약 당사자들은 해당 사유가 종료된 후 가능한 빨리 계약을 이행하거나 재협상합니다.
2.	시스템 장애 및 오류에 대한 면책
①	회사는 예기치 않은 시스템 오류나 장애로 인해 발생한 손해에 대해 책임을 지지 않습니다.
②	이용자는 시스템 장애 및 오류 발생 시 회사에 즉시 통지하여야 하며, 회사는 이를 신속히 복구하기 위해 노력합니다.
3.	농산물 가격 변동에 대한 재협상
①	농산물의 시장가격이 계약서에 명시된 가격 대비 20% 이상 변동하는 경우, 당사자들은 계약 조건을 재협상할 수 있습니다.
②	재협상 요청은 가격 변동이 확인된 시점부터 7일 이내에 서면으로 상대방에게 통지하여야 하며, 당사자들은 성실히 협의하여 새로운 계약 조건을 도출합니다. 
4.	회사는 이용자가 제공한 정보의 정확성에 대해 책임지지 않습니다. 이용자는 모든 정보를 정확하고 최신 상태로 유지하여야 합니다.
5.	회사는 이용자의 고의 또는 과실로 인해 발생한 손해에 대해 책임을 지지 않습니다.
제13조 (개인정보 보호)
1.	회사는 이용자의 개인정보를 관련 법령에 따라 보호하며, 개인정보의 수집, 이용, 보관, 처리 등에 관한 자세한 사항은 회사의 개인정보 처리방침에 따릅니다.
제14조 (분쟁의 해결)
1.	이 약관에 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다.
2.	서비스 이용과 관련하여 분쟁이 발생한 경우, 회사와 이용자는 성실히 협의하여 해결하도록 노력합니다.
3.	분쟁이 해결되지 않을 경우 관할 법원은 회사의 본사 소재지 관할 법원으로 합니다.
부칙
이 약관은 2024년 7월 1일부터 시행합니다.

''',
                              style: TextStyle(
                                fontSize: getFontSize(context, FontSizeType.small),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: agree1
                            ? () async {
                          final sdOrder = SdOrder(
                            documentId: docPath,
                            title: data['title'] ?? '',
                            itemName: data['itemName'] ?? '',
                            variety: data['variety'] ?? '',
                            orderCount: 0,
                            // 누적 주문 횟수
                            totalCount: (data['totalCount'] != null
                                ? double.tryParse(data['totalCount']
                                .toString()) ??
                                0
                                : 0)
                                .toInt(),
                            volume: 0,
                            totalVolume: (data['totalVolume'] != null
                                ? double.tryParse(data['totalVolume']
                                .toString()) ??
                                0
                                : 0)
                                .toInt(),
                            // 총 거래량
                            origin: data['origin'] ?? '',
                            startDate: data['startDate'] ?? '',
                            endDate: data['endDate'] ?? '',
                            grade: data['grade'] ?? '',
                            price: (data['price'] != null
                                ? double.tryParse(
                                data['price'].toString()) ??
                                0
                                : 0)
                                .toInt(),
                            subOrders: [],
                            assignedAdmin: '',
                            uid: '',
                          );

                          final user = Provider.of<AuthProviderService>(
                              context,
                              listen: false)
                              .user;
                          if (user != null) {
                            // Firestore에서 문서가 존재하는지 확인
                            final docRef =
                            FirebaseFirestore.instance.doc(docPath);
                            final docSnapshot = await docRef.get();

                            if (docSnapshot.exists) {
                              await FirebaseFirestore.instance
                                  .collection('client')
                                  .doc(user.uid)
                                  .collection('sundohistory')
                                  .add(sdOrder.toMap());

                              await docRef.update({'status': '완료'});

                              _removeInquiry(docPath);

                              Navigator.pop(context);
                              _showCompletionDialog(context);
                            } else {
                              Navigator.pop(context);
                              _showErrorDialog(
                                  context, '해당 문서를 찾을 수 없습니다.');
                            }
                          }
                        }
                            : null, // 두 체크박스 모두 체크해야 버튼 활성화
                        style: ElevatedButton.styleFrom(
                          fixedSize: getButtonSize(context, ButtonSizeType.large),
                          backgroundColor: Color(0xFF00AF66),
                          disabledForegroundColor: Colors.grey.withOpacity(0.38),
                          disabledBackgroundColor:
                          Colors.grey.withOpacity(0.12), // 비활성화 상태의 버튼 색상
                        ),
                        child: Text('주문완료',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                getFontSize(context, FontSizeType.medium))),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('주문 완료'),
          content: Text('주문이 성공적으로 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(
                    '/order_management_screen'); // MainScreen으로 이동하여 OrderListScreen이 보이도록 수정
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
