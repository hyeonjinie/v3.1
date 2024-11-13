// /*
// 마이페이지 > 내 정보 수정 페이지
// - 관련 파일
//   - screen/my_profile : 정보 업데이트 시, 내 정보 페이지로 이동
//   - screen/common_widget.dart : 공통 텍스트필드 ui 사용
//   - user_provider.dart : 정보 업데이트 및 이미지 업로드 처리
// */
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../../services/auth_provider.dart';
//
// class MyProfileModify extends StatefulWidget {
//   const MyProfileModify({super.key});
//
//   @override
//   State<MyProfileModify> createState() => _MyProfileModifyState();
// }
//
// class _MyProfileModifyState extends State<MyProfileModify> {
//   XFile? _image;
//   final ImagePicker picker = ImagePicker();
//
//   // 이미지 불러오기
//   Future getImage(ImageSource imageSource) async {
//     final XFile? pickedFile = await picker.pickImage(source: imageSource);
//     if (pickedFile != null) {
//       setState(() {
//         _image = XFile(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProviderService>(context);
//     final user = authProvider.user;
//     TextEditingController repNameController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.representativeName}');
//     TextEditingController bizFieldController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.businessField}');
//     TextEditingController bizTypeController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.businessType}');
//     TextEditingController cpnController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.contactPersonName}');
//     TextEditingController cpphnController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.contactPersonPhoneNumber}');
//     TextEditingController cpeController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.contactPersonEmail}');
//     TextEditingController bizAdressController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.businessAddress}');
//     TextEditingController bizTelController = TextEditingController(
//         text:
//             '${Provider.of<AuthProviderService>(context).user?.companyTelNumber}');
//
//     final authProvider = Provider.of<AuthProviderService>(context);
//     final user = authProvider.user;
//
//     if (user != null) {
//       repNameController.text = user.representativeName;
//       bizFieldController.text = user.businessField;
//       bizTypeController.text = user.businessType;
//       cpnController.text = user.contactPersonName;
//       cpphnController.text = user.contactPersonPhoneNumber;
//       cpeController.text = user.contactPersonEmail;
//       bizAdressController.text = user.businessAddress;
//       bizTelController.text = user.companyTelNumber;
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           '내 정보',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
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
//                       SizedBox(height: 3),
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
//                             Spacer(),
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
//                 Container(
//                   padding: EdgeInsets.only(top: 20, left: 25, bottom: 20),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // 기업 정보
//                       const Text(
//                         '기업 정보',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       buildTextField(
//                         labelText: '대표자명',
//                         controller: repNameController,
//                       ),
//                       buildTextField(
//                         labelText: '업태',
//                         controller: bizFieldController,
//                       ),
//                       buildTextField(
//                         labelText: '종목',
//                         controller: bizTypeController,
//                       ),
//
//                       // 사업자 등록 - 파일 선택
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: [
//                             const Text(
//                               '사업자 등록증',
//                               style: TextStyle(
//                                 color: Color(0xFF323232),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Spacer(),
//                             OutlinedButton.icon(
//                               onPressed: () {
//                                 getImage(ImageSource.gallery);
//                               },
//                               icon: const Icon(
//                                 Icons.add,
//                                 size: 18,
//                                 color: Color(0xFF00AF66),
//                               ),
//                               label: const Text(
//                                 "파일 선택",
//                                 style: TextStyle(
//                                     color: Color(0xFF00AF66)),
//                               ),
//                               style: OutlinedButton.styleFrom(
//                                 side: const BorderSide(
//                                     color: Color(0xFF00AF66)),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 32,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       _image == null
//                           ? Text('')
//                           : Padding(
//                             padding: const EdgeInsets.only(left: 100.0, right: 32),
//                             child: Image.file(
//                                 height: 200,
//                                 File(_image!.path),
//                                 fit: BoxFit.cover,
//                               ),
//                           ),
//
//                       // 담당자 정보
//                       const Padding(
//                         padding: EdgeInsets.only(top: 40.0),
//                         child: Text(
//                           '담당자 정보',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       buildTextField(
//                         labelText: '담당자명',
//                         controller: cpnController,
//                       ),
//                       buildTextField(
//                         labelText: '연락처',
//                         controller: cpphnController,
//                       ),
//                       buildTextField(
//                         labelText: '이메일',
//                         controller: cpeController,
//                       ),
//
//                       // 기타 정보
//                       const Padding(
//                         padding: EdgeInsets.only(top: 40.0),
//                         child: Text(
//                           '기타 정보',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       buildTextField(
//                         labelText: '사업장 주소',
//                         controller: bizAdressController,
//                       ),
//                       buildTextField(
//                         labelText: '연락처',
//                         controller: bizTelController,
//                       ),
//
//                       // 취소 및 저장 버튼
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 40.0, right: 32, bottom: 40, left: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // 취소 버튼
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => MyProfile()),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0xFFD5D5D5),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(26),
//                                   ),
//                                   minimumSize: Size(120, 50),
//                                   elevation: 0,
//                                 ),
//                                 child: const Text(
//                                   '취소',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 25,
//                             ),
//                             // 저장 버튼
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   if (user != null) {
//                                     await authProvider.uploadImage(uid: user.uid, uploadImage: _image!);
//                                     await authProvider.updateUserInfo(
//                                       uid: user.uid,
//                                       representativeName:
//                                           repNameController.text,
//                                       businessField: bizFieldController.text,
//                                       businessType: bizTypeController.text,
//                                       contactPersonName: cpnController.text,
//                                       contactPersonPhoneNumber:
//                                           cpphnController.text,
//                                       contactPersonEmail: cpeController.text,
//                                       businessAddress: bizAdressController.text,
//                                       companyTelNumber: bizTelController.text,
//                                       onSuccess: () {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(content: Text('업데이트 성공')),
//                                         );
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   MyProfile()),
//                                         );
//                                       },
//                                       onError: (err) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(
//                                               content: Text('업데이트 실패: $err')),
//                                         );
//                                       },
//                                     );
//
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0xFF00AF66),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(26),
//                                   ),
//                                   minimumSize: Size(120, 50),
//                                   elevation: 0,
//                                 ),
//                                 child: const Text(
//                                   '저장',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
