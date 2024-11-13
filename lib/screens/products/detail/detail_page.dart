import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:v3_mvp/domain/models/product.dart';
import 'package:v3_mvp/screens/products/detail/widgets/details_disclosure_and_image.dart';
import 'package:v3_mvp/screens/products/detail/widgets/purchase_modal.dart';
import 'package:v3_mvp/widgets/custom_appbar/custom_appbar.dart';
import 'package:v3_mvp/screens/products/detail/widgets/product_info.dart';
import 'package:v3_mvp/screens/products/detail/widgets/shipping_info.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/custom_user.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import '../../../widgets/font_size_helper/font_size_helper.dart';
import '../../../widgets/navigation_helper.dart';
import '../../main/widget/footer/footer.dart';
import '../../order/cart/cart_notifier.dart';
import '../../order/order_history/order_history_screen.dart';

class DetailPage extends StatefulWidget {
  final String productId; // 여기서 productId는 실제로 Product 객체를 의미합니다.

  const DetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4;
  late Future<Product?> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct(widget.productId);
  }

  Future<Product?> fetchProduct(String productId) async {
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (productDoc.exists) {
      return Product.fromDocument(productDoc);
    } else {
      return null;
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final customUser = authProvider.user;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            scaffoldKey: _scaffoldKey,
            selectedIndex: _selectedIndex,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          ),
          body: FutureBuilder<Product?>(
            future: productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('Product not found'));
              }

              final product = snapshot.data!;
              return _buildBody(customUser, product,
                  isWeb: kIsWeb, isNarrow: constraints.maxWidth <= 660);
            },
          ),
          bottomNavigationBar: constraints.maxWidth <= 660
              ? CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) =>
                NavigationHelper.onItemTapped(context, index, _updateIndex),
          )
              : null,
        );
      },
    );
  }

  Widget _buildBody(CustomUser? customUser, Product product,
      {required bool isWeb, required bool isNarrow}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductInfo(
              product: product,
              customUser: customUser,
              isWeb: isWeb,
            ),

            const SizedBox(height: 50.0),
            if (kIsWeb) CustomFooter(),
          ],
        ),
      ),
    );
  }
}
