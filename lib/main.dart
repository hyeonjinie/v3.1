import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:v3_mvp/domain/models/bpi/bpi_index.dart';
import 'package:v3_mvp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:v3_mvp/screens/Inquiry/inquiry_management_screen.dart';
import 'package:v3_mvp/screens/Inquiry/inquiry_screen.dart';
import 'package:v3_mvp/screens/Inquiry/order_list.dart';
import 'package:v3_mvp/screens/Inquiry/order_progress.dart';
import 'package:v3_mvp/screens/auth/login/login_screen.dart';
import 'package:v3_mvp/screens/auth/register/register_screen.dart';
import 'package:v3_mvp/screens/auth/register/term_and_condition_screen.dart';
import 'package:v3_mvp/screens/auth/user_profile/mypage.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/bpi_screen.dart';
import 'package:v3_mvp/screens/info_center/bpi_detail/widget/bpi_detail_screen.dart';
import 'package:v3_mvp/screens/info_center/info_center_screen.dart';
import 'package:v3_mvp/screens/info_center/item_detail/sd_price_detail_screen.dart';
import 'package:v3_mvp/screens/main/main_contents_screen.dart';

import 'package:v3_mvp/screens/order/cart/cart_page.dart';
import 'package:v3_mvp/screens/order/order_history/order_history_screen.dart';
import 'package:v3_mvp/screens/products/detail/detail_page.dart';
import 'package:v3_mvp/screens/products/product_list.dart';

import 'package:v3_mvp/services/auth_provider.dart';
import 'package:v3_mvp/data/datasources/product_remote_data_source.dart';
import 'package:v3_mvp/data/datasources/remote_data_source.dart';
import 'package:v3_mvp/data/datasources/repositories/garak_item_repository_impl.dart';
import 'package:v3_mvp/data/datasources/repositories/price_repository_impl.dart';
import 'package:v3_mvp/domain/repositories/product_repository.dart';
import 'package:v3_mvp/domain/usecases/get_garak_items.dart';
import 'package:v3_mvp/domain/usecases/get_product_by_id.dart';

import 'package:v3_mvp/domain/models/product.dart';
import 'package:v3_mvp/services/market_data_service.dart';
import 'package:v3_mvp/services/provider/garak_item_provider.dart';
import 'package:v3_mvp/services/provider/navigation_index_provider.dart';
import 'package:v3_mvp/services/provider/order_provider.dart';
import 'package:v3_mvp/services/provider/price_provider.dart';
import 'package:v3_mvp/services/provider/product_provider.dart';

import 'domain/models/item.dart';
import 'domain/models/sd_order.dart';
import 'main_screen_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationIndexProvider()),
        ChangeNotifierProvider(create: (_) => AuthProviderService()),
        ChangeNotifierProxyProvider<AuthProviderService, MarketDataService>(
          create: (context) =>
              MarketDataService(authProvider: context.read<AuthProviderService>()),
          update: (context, authProvider, marketDataService) =>
              MarketDataService(authProvider: authProvider),
        ),
        ChangeNotifierProvider(
          create: (_) => GarakItemProvider(
            getGarakItems: GetGarakItems(
              repository: GarakItemRepositoryImpl(
                remoteDataSource: RemoteDataSourceImpl(),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PriceProvider(
            priceRepository: PriceRepositoryImpl(
              remoteDataSource: RemoteDataSourceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        Provider(
          create: (_) => FirebaseFirestore.instance,
        ),
        Provider<ProductRemoteDataSource>(
          create: (context) => ProductRemoteDataSourceImpl(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            remoteDataSource: context.read<ProductRemoteDataSource>(),
          ),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            getProductById: GetProductById(
              repository: context.read<ProductRepository>(),
            ),
            productRemoteDataSource: context.read<ProductRemoteDataSource>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => MainScreenState()), // 추가된 Provider
      ],
      child: MyAppWithRouter(),
    );
  }
}

class MyAppWithRouter extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainContentsScreen(),
      ),
      GoRoute(
        path: '/terms_and_condition_screen',
        builder: (context, state) => TermsAndConditionsPage(),
      ),
      GoRoute(
        path: '/register_screen',
        builder: (context, state) {
          final extra = state.extra as Map<String, bool>;
          return RegisterScreen(
            isRequiredTermsAgreed: extra['isRequiredTermsAgreed'] ?? false,
            isPrivacyPolicyAgreed: extra['isPrivacyPolicyAgreed'] ?? false,
            isEmailMarketingAgreed: extra['isEmailMarketingAgreed'] ?? false,
            isSMSMarketingAgreed: extra['isSMSMarketingAgreed'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/info_center_screen',
        builder: (context, state) => InfoCenterScreen(),
      ),
      GoRoute(
        path: '/login_screen',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/product_list',
        builder: (context, state) => ProductList(),
      ),
      GoRoute(
        path: '/cart_screen',
        builder: (context, state) => CartPage(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final productIdJson = state.extra as String;
          final productId = Product.fromJson(jsonDecode(productIdJson));
          return DetailPage(productId: productId.id);
        },
      ),
      GoRoute(
        path: '/price_detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final itemJson = extra['itemJson'] as String;
          final errorValue = extra['errorValue'] != null
              ? extra['errorValue'] as double
              : null;
          final item = Item.fromJson(jsonDecode(itemJson));
          return SdPriceDetailScreen(item: item, errorValue: errorValue);
        },
      ),
      GoRoute(
        path: '/bpi_screen',
        builder: (context, state) => BpiScreen(),
      ),
      GoRoute(
        path: '/inquiry_management_screen',
        builder: (context, state) => InquiryManagementScreen(),
      ),
      GoRoute(
        path: '/order_management_screen',
        builder: (context, state) => OrderListScreen(),
      ),
      GoRoute(
        path: '/bpi_detail',
        builder: (context, state) {
          final bpiJson = state.extra as String;
          final bpiMap = jsonDecode(bpiJson) as Map<String, dynamic>;
          final bpi = BpiIndex.fromJson(bpiMap);
          final title = bpiMap['indexName'] as String; // 수정된 부분
          return BpiDetailScreen(bpiIndex: bpi, title: title);
        },
      ),
      GoRoute(
        path: '/menu_detail',
        builder: (context, state) {
          final bpiJson = state.extra as String;
          final bpiMap = jsonDecode(bpiJson) as Map<String, dynamic>;
          final bpi = BpiIndex.fromJson(bpiMap);
          final title = bpiMap['indexName'] as String; // 수정된 부분
          return BpiDetailScreen(bpiIndex: bpi, title: title);
        },
      ),
      GoRoute(
        path: '/inquiry',
        builder: (context, state) {
          final inquiryData = jsonDecode(state.extra as String);
          final inquiryMap = inquiryData['item'] as Map<String, dynamic>;
          final grade = inquiryData['currentGrade'] as String;
          return InquiryScreen(item: inquiryMap, currentGrade: grade);
        },
      ),
      GoRoute(
        path: '/my_page',
        builder: (context, state) => const MyPage(),
      ),
      GoRoute(
        path: '/product_order_list_screen',
        builder: (context, state) => OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/order_progress',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final SdOrder order = extra['order'];
          final String documentId = extra['documentId'];
          return OrderProgressPage(order: order, documentId: documentId);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ko', 'KR'), // Korean
      ],
      theme: ThemeData(
        useMaterial3: false,
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          color: Colors.white, // 카드 배경색
          elevation: 4, // 카드 그림자
        ),
        // textTheme: const TextTheme(
        //   bodyMedium: TextStyle(
        //     fontFamily: 'NanumGothic',
        //   ),
        //   bodyLarge: TextStyle(
        //     fontFamily: 'NanumGothic',
        //   ),
        //   bodySmall: TextStyle(
        //     fontFamily: 'NanumGothic',
        //   ),
        // ),
        cardColor: const Color(0xFFFFFFFF),
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent, // 그림자 색상 제거
          shape: Border(bottom: BorderSide(color: Colors.transparent)),
        ),
      ),
    );
  }
}
