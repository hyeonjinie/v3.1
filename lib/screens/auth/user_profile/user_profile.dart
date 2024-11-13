import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';
import '../../../services/auth_provider.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('내 정보')),
        body: Center(child: Text('로그인 상태가 아닙니다.')),
      );
    }

    return ResponsiveSafeArea(
      child: Scaffold(
        // backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('내 정보'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('client')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot);
              if (snapshot.hasData && snapshot.data!.data() != null) {
                Map<String, dynamic>? userData =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (userData == null) {
                  return Center(child: Text('유저 데이터를 찾을 수 없습니다.'));
                }
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: Column(
                        children: [
                          //상단 정보
                          Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            height: 100,
                            color: Color(0xFFF5F8FF),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 10.0),
                                  child: Text(
                                    '${userData['companyName']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${userData['email']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '가입일 | ${userData['createDate']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          //정보수정 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MyProfileModify()),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFF00AF66), width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  minimumSize: Size(120, 40),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  '정보 수정',
                                  style: TextStyle(
                                    color: Color(0xFF00AF66),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(color: Colors.grey[300]),
                          ),

                          //기업 정보
                          Container(
                            padding: EdgeInsets.only(top: 20, left: 25),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '기업 정보',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '대표자명',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['representativeName']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '업태',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['businessType']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '종목',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['businessField']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '사업자 등록증',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      userData['uploadedFileURL'] == null
                                          ? Text('')
                                          : Padding(
                                        padding: const EdgeInsets.only(right: 32),
                                        child: Image.network(
                                          userData['uploadedFileURL'],
                                          width: 200,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //담당자 정보
                          Container(
                            padding: EdgeInsets.only(top: 40, left: 25),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '담당자 정보',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '담당자명',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['contactPersonName']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '연락처',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['contactPersonPhoneNumber']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '이메일',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['contactPersonEmail']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //기타 정보
                          Container(
                            padding: EdgeInsets.only(top: 40, left: 25, bottom: 20),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '기타 정보',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '사업장 주소',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${Provider.of<AuthProviderService>(context).user?.businessAddress}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          '연락처',
                                          style: TextStyle(
                                            color: Color(0xFF323232),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${userData['companyTelNumber']}',
                                        style: const TextStyle(
                                          color: Color(0xFF323232),
                                          fontSize: 16,
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
              } else if (snapshot.hasError) {
                return Center(child: Text("데이터 로드 실패: ${snapshot.error}"));
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String companyName,
      String businessRegistrationNumber) {
    return Container(
      color: Color(0xFFE4F5EE),
      // Light green background color for the section
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align text to the left of the column
        children: <Widget>[
          Text(
            companyName, // Company name
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4), // Space between texts
          Row(
            children: [
              Text(
                businessRegistrationNumber, // Business registration number
                style: const TextStyle(fontSize: 20),
              ),
              Spacer(),
              // This will just push the icon button to the right of this row
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement editing functionality
                },
                color: Colors.green,
              ),
            ],
          ),
        ],
      ), // Aligns the IconButton to the right
    );
  }

  Widget _buildInfoSection({
    required String title,
    required BuildContext context,
    required List<Widget> tiles,
  }) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...tiles,
        ],
      ),
    );
  }

  ListTile _buildListTile({required String title, required String subtitle}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
