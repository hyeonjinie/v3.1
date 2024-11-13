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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildSectionTitle(context, userData['companyName'],
                            userData['businessRegistrationNumber'] ?? '사업자번호 없음'),
                        // Divider(),
                        _buildInfoSection(
                          title: '기업정보',
                          context: context,
                          tiles: [
                            _buildListTile(
                                title: '대표자명',
                                subtitle:
                                    userData['representativeName'] ?? '대표자명 없음'),
                            _buildListTile(
                                title: '업태',
                                subtitle: userData['businessType'] ?? '업태 정보 없음'),
                            _buildListTile(
                                title: '종목',
                                subtitle:
                                    userData['businessField'] ?? '종목 정보 없음'),
                          ],
                        ),
                        Divider(),
                        _buildInfoSection(
                          title: '담당자 정보',
                          context: context,
                          tiles: [
                            _buildListTile(
                                title: '담당자명',
                                subtitle:
                                    userData['contactPersonName'] ?? '담당자명 없음'),
                            _buildListTile(
                                title: '담당자휴대폰번호',
                                subtitle: userData['contactPersonPhoneNumber'] ??
                                    '담당자 전화번호 없음'),
                            _buildListTile(
                                title: '담당자이메일',
                                subtitle: userData['contactPersonEmail'] ??
                                    '담당자 이메일 없음'),
                          ],
                        ),
                        Divider(),
                        _buildInfoSection(
                          title: '기타정보',
                          context: context,
                          tiles: [
                            _buildListTile(
                                title: '사업장 주소',
                                subtitle:
                                    userData['businessAddress'] ?? '사업장 주소 없음'),
                            _buildListTile(
                                title: '전화번호',
                                subtitle:
                                    userData['companyTelNumber'] ?? '전화번호 없음'),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 50.0), // 하단 여백을 150으로 설정
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '로그아웃',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  tooltip: '로그아웃',
                                  onPressed: () {
                                    // 로그아웃 함수 호출
                                    context.read<AuthProviderService>().signOut(context).catchError((error) {
                                      // 로그아웃 실패 시 에러 메시지 표시
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('로그아웃 실패: $error'))
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
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
