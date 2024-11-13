// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import 'package:v3_mvp/screens/Inquiry/inquiry_management_screen.dart';
// import 'package:v3_mvp/screens/products/product_list.dart';
// import 'package:v3_mvp/widgets/custom_appbar/custom_appbar.dart';
// import 'package:v3_mvp/screens/info_center/info_center_screen.dart';
// import '../../widgets/navigation_helper.dart';
// import '../Inquiry/order_list.dart';
// import '../info_center/info_center_screen.dart';
// import '../order/order_screen.dart';
// import 'main_contents_screen.dart';
// import '../../services/auth_provider.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   void _updateIndex(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   void _onItemTapped(int index) {
//     final authProvider = Provider.of<AuthProviderService>(context, listen: false);
//     final user = authProvider.user;
//
//     if (user != null) {
//       _updateIndex(index);
//     } else {
//       _showLoginRequiredDialog();
//     }
//   }
//
//   void _showLoginRequiredDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('로그인 필요'),
//           content: Text('로그인 후 이용 가능합니다.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('확인'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildScaffold();
//   }
//
//   Widget _buildScaffold() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (kIsWeb) {
//           if (constraints.maxWidth > 660) {
//             return Scaffold(
//               key: _scaffoldKey,
//               appBar: CustomAppBar(
//                 scaffoldKey: _scaffoldKey,
//                 selectedIndex: _selectedIndex,
//                 onItemTapped: _onItemTapped,
//               ),
//               body: _buildBody(),
//             );
//           } else {
//             return Scaffold(
//               key: _scaffoldKey,
//               appBar: CustomAppBar(
//                 scaffoldKey: _scaffoldKey,
//                 selectedIndex: _selectedIndex,
//                 onItemTapped: _onItemTapped,
//               ),
//               body: _buildBody(),
//               bottomNavigationBar: _buildBottomNavigationBar(),
//             );
//           }
//         } else {
//           return Scaffold(
//             key: _scaffoldKey,
//             appBar: CustomAppBar(
//               scaffoldKey: _scaffoldKey,
//               selectedIndex: _selectedIndex,
//               onItemTapped: _onItemTapped,
//             ),
//             body: _buildBody(),
//             bottomNavigationBar: _buildBottomNavigationBar(),
//           );
//         }
//       },
//     );
//   }
//
//   Widget _buildBody() {
//     List<Widget> pages = [
//       MainContentsScreen(onCategorySelected: (index) => NavigationHelper.onItemTapped(context, index, _updateIndex)),
//       InfoCenterScreen(),
//       InquiryManagementScreen(),
//       OrderListScreen(),
//       const ProductList(),
//     ];
//
//     return IndexedStack(
//       index: _selectedIndex,
//       children: pages,
//     );
//   }
//
//   BottomNavigationBar _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       items: <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: _icon(0, 'assets/bg_svg/icon-home.svg'), label: '홈'),
//         BottomNavigationBarItem(icon: _icon(1, 'assets/bg_svg/information_center.svg'), label: '정보센터'),
//         BottomNavigationBarItem(icon: _icon(2, 'assets/bg_svg/question.svg'), label: '문의관리'),
//         BottomNavigationBarItem(icon: _icon(3, 'assets/bg_svg/icon-order_manage.svg'), label: '주문관리'),
//         BottomNavigationBarItem(icon: _icon(4, 'assets/bg_svg/mdi_cart.svg'), label: '비굿마켓'),
//       ],
//       currentIndex: _selectedIndex,
//       selectedItemColor: Colors.green,
//       unselectedItemColor: Colors.grey,
//       onTap: _onItemTapped,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//     );
//   }
//
//   Widget _icon(int index, String assetName) {
//     return SvgPicture.asset(
//       assetName,
//       width: 24,
//       color: _selectedIndex == index ? Colors.green : Colors.grey,
//     );
//   }
// }
