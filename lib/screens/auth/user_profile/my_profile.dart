// /*
// 마이페이지 > 내 정보 확인 페이지
// - '진행 중인 문의 및 주문 영역'은 제외
// - 관련 파일
//   - screen/my_profile_modify : '정보 수정' 클릭 시, 정보 수정 페이지로 이동
//   - user_provider.dart : 현재 유저 정보 불러옴
// */
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../services/auth_provider.dart';
// import 'my_profile_modify.dart';
//
// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});
//
//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }
//
// class _MyProfileState extends State<MyProfile> {
//   @override
//   Widget build(BuildContext context) {
//     String? imageUrl =
//         '${Provider.of<AuthProviderService>(context).user?.uploadedFileURL}';
//     return Scaffold(
//       appBar: AppBar(
//         // automaticallyImplyLeading: true,
//         title: const Text(
//           '내 정보',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             constraints: BoxConstraints(maxWidth: 800),
//             child: Column(
//               children: [
//                 //상단 정보
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   width: double.infinity,
//                   height: 100,
//                   color: Color(0xFFF5F8FF),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16, top: 10.0),
//                         child: Text(
//                           '${Provider.of<AuthProviderService>(context).user?.companyName}',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//                         child: Row(
//                           children: [
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.email}',
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             const Spacer(),
//                             Text(
//                               '가입일 | ${Provider.of<AuthProviderService>(context).user?.createDate}',
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//
//                 //정보수정 버튼
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MyProfileModify()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         side: const BorderSide(color: Color(0xFF00AF66), width: 1),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(26),
//                         ),
//                         minimumSize: Size(120, 40),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         '정보 수정',
//                         style: TextStyle(
//                           color: Color(0xFF00AF66),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 25),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(color: Colors.grey[300]),
//                 ),
//
//                 //기업 정보
//                 Container(
//                   padding: EdgeInsets.only(top: 20, left: 25),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '기업 정보',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '대표자명',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.representativeName}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '업태',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.businessField}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '종목',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.businessType}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '사업자 등록증',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             imageUrl == null
//                             ? Text('')
//                             : Padding(
//                                 padding: const EdgeInsets.only(right: 32),
//                                 child: Image.network(
//                                   imageUrl,
//                                   width: 200,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 //담당자 정보
//                 Container(
//                   padding: EdgeInsets.only(top: 40, left: 25),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '담당자 정보',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '담당자명',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.contactPersonName}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '연락처',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.contactPersonPhoneNumber}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '이메일',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.contactPersonEmail}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 //기타 정보
//                 Container(
//                   padding: EdgeInsets.only(top: 40, left: 25, bottom: 20),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '기타 정보',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '사업장 주소',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.businessAddress}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 '연락처',
//                                 style: TextStyle(
//                                   color: Color(0xFF323232),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${Provider.of<AuthProviderService>(context).user?.companyTelNumber}',
//                               style: const TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(color: Colors.grey[300]),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
