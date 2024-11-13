// /*
// 뉴스 목록 페이지
// - 정보센터 > 농산물 뉴스 탭만 구현
// - 관련 파일
//   - service/news_service.dart : 기사 조회 처리
//   - model/newsArticle.dart : 뉴스데이터
// */
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:v3_hyeonjin/model/newsArticle.dart';
// import 'package:v3_hyeonjin/screen/login.dart'; //로그인 안됐을 경우, 접근 불가 처리에 사용
// import 'package:v3_hyeonjin/screen/mypage.dart'; // 상단 마이페이지 이동에 사용
// import 'package:v3_hyeonjin/service/news_service.dart';
// import 'package:v3_hyeonjin/user_provider.dart';
//
// class NewsListPage extends StatefulWidget {
//   @override
//   _NewsListPageState createState() => _NewsListPageState();
// }
//
// class _NewsListPageState extends State<NewsListPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<NewsArticle> articles = [];
//   int currentPage = 0;
//   bool hasMore = true; // 뉴스 더 있는지 확인
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     loadMoreArticles();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//               _scrollController.position.maxScrollExtent &&
//           hasMore) {
//         loadMoreArticles();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   // 뉴스 10개씩 불러오기
//   void loadMoreArticles() async {
//     if (!hasMore) return;
//
//     List<NewsArticle> newArticles =
//         await NewsService().fetchNewsArticles(page: currentPage, limit: 10);
//     if (newArticles.length < 10) {
//       hasMore = false;
//     }
//     setState(() {
//       articles.addAll(newArticles);
//       currentPage++;
//     });
//     //print(newArticles);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<AuthProviderService>(context).user;
//     if (user == null) return LoginPage();
//     return Center(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: 800),
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('News Example!!'),
//             bottom: TabBar(
//               controller: _tabController,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey[700],
//               labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               unselectedLabelStyle: TextStyle(fontSize: 16),
//               indicatorColor: Colors.blue[700],
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
//               tabs: const [
//                 Tab(text: '품목정보'),
//                 Tab(text: 'BPI'),
//                 Tab(text: '농산물 뉴스'),
//               ],
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 5, right: 16),
//                 child: IconButton(
//                   icon: Icon(Icons.person_outline, color: Color(0xFF00AF66)),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MyPage()),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 Center(child: Text('Screen A')),
//                 Center(child: Text('Screen B')),
//                 viewList(context),
//               ],
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             child: Icon(Icons.logout),
//             onPressed: () {
//               // 로그아웃
//               context.read<AuthProviderService>().signOut();
//
//               // 로그인 페이지로 이동
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginPage()),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// 뉴스 클릭 시, 해당 url로 이동
//   void _launchURL(String urlString) async {
//     final Uri url = Uri.parse(urlString);
//     // print(url);
//     try {
//       if (await canLaunchUrl(url)) {
//         bool launched = await launchUrl(url);
//         if (!launched) {
//           print('Launching URL failed.');
//         }
//       } else {
//         print('URL cannot be launched.');
//       }
//     } catch (e) {
//       print('Error launching URL: $e');
//     }
//   }
//
//   // 뉴스 불러오기
//   Widget viewList(BuildContext context) {
//     return ListView.separated(
//       controller: _scrollController,
//       itemCount: articles.length + 1,
//       itemBuilder: (context, index) {
//         if (index < articles.length) {
//           NewsArticle article = articles[index];
//           return Container(
//             height: 90,
//             child: ListTile(
//               title: Text(article.title,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               subtitle: Text(article.date),
//               trailing: article.imageurl.isNotEmpty
//                   ? Image.network(article.imageurl,
//                       fit: BoxFit.cover, width: 100)
//                   : null,
//               onTap: () => _launchURL(article.newsurl),
//             ),
//           );
//         } else {
//           if (hasMore) {
//             return Container(
//               alignment: Alignment.center,
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               Fluttertoast.showToast(
//                 msg: "마지막입니다",
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//               );
//             });
//             return Container();
//           }
//         }
//       },
//       separatorBuilder: (context, index) {
//         if (index < articles.length - 1 ||
//             (index == articles.length - 1 && hasMore)) {
//           return Divider(color: Colors.grey[300]);
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
