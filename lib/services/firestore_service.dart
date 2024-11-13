import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/product/simple_product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addToCart(String uid, Map<String, dynamic> product) async {
    final cartRef = _db.collection('client').doc(uid).collection('cart');
    await cartRef.add(product);
  }

  Stream<List<Map<String, dynamic>>> getCartItems(String uid) {
    final cartRef = _db.collection('client').doc(uid).collection('cart');
    return cartRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Document ID를 데이터에 추가합니다.
        return data;
      }).toList();
    });
  }

  Future<void> updateCartItemQuantity(String uid, String itemId, int quantity) async {
    final cartRef = _db.collection('client').doc(uid).collection('cart').doc(itemId);
    await cartRef.update({'quantity': quantity});
  }

  Future<void> deleteCartItem(String uid, String itemId) async {
    final cartRef = _db.collection('client').doc(uid).collection('cart').doc(itemId);
    await cartRef.delete();
  }

  Future<void> createOrder(String uid, Map<String, dynamic> orderData) async {
    final orderRef = _db.collection('orderhistory').doc();
    final clientOrderRef = _db.collection('client').doc(uid).collection('orderhistory').doc(orderRef.id);
    await orderRef.set(orderData);
    await clientOrderRef.set(orderData);
  }

  Future<List<SimpleProductModel>> getRecentPurchases(String uid) async {
    try {
      final querySnapshot = await _db
          .collection('client')
          .doc(uid)
          .collection('orderhistory')
          .orderBy('orderDate', descending: true)
          .limit(3)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String?;
        if (productId == null) {
          print('Error: productId is null in document with id ${doc.id}');
          return null; // null인 경우 처리하지 않음
        }
        data['id'] = doc.id; // 컬렉션 ID를 추가합니다.
        return SimpleProductModel.fromMap(data);
      }).whereType<SimpleProductModel>().toList(); // null이 아닌 경우만 리스트로 반환
    } catch (e) {
      print('Error getting recent purchases: $e');
      return [];
    }
  }

  Future<DocumentSnapshot> getProduct(String productId) async {
    try {
      print('Fetching product with ID: $productId');
      final productDoc = await _db.collection('products').doc(productId).get();
      print('Fetched ProductDoc: ${productDoc.data()}');
      return productDoc;
    } catch (e) {
      print('Error getting product: $e');
      rethrow;
    }
  }
}
