import 'package:flutter/material.dart';
import 'package:v3_mvp/services/firestore_service.dart';

class CartNotifier extends ChangeNotifier {
  final FirestoreService firestoreService;
  final String userId;
  List<Map<String, dynamic>> cartItems = [];
  Map<String, bool> selectedItems = {};

  CartNotifier({required this.firestoreService, required this.userId}) {
    _loadCartItems();
  }

  void _loadCartItems() async {
    firestoreService.getCartItems(userId).listen((items) {
      cartItems = items;
      notifyListeners();
    });
  }

  void toggleSelection(String itemId, bool isSelected) {
    selectedItems[itemId] = isSelected;
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    firestoreService.updateCartItemQuantity(userId, itemId, quantity);
    notifyListeners();
  }

  void deleteItem(String itemId) {
    firestoreService.deleteCartItem(userId, itemId);
    selectedItems.remove(itemId);
    notifyListeners();
  }

  double calculateTotalAmount() {
    double totalAmount = 0;
    for (var item in cartItems) {
      if (selectedItems[item['id']] ?? false) {
        double price = item['bgoodPrice']?.toDouble() ?? 0.0;
        int quantity = item['quantity']?.toInt() ?? 0;
        totalAmount += price * quantity;
      }
    }
    return totalAmount;
  }

  double calculateTotalOriginalAmount() {
    double totalOriginalAmount = 0;
    for (var item in cartItems) {
      if (selectedItems[item['id']] ?? false) {
        double price = item['bgoodPrice']?.toDouble() ?? 0.0;
        double originalPrice = item['wholesalePrice']?.toDouble() ?? price;
        int quantity = item['quantity']?.toInt() ?? 0;
        totalOriginalAmount += originalPrice * quantity;
      }
    }
    return totalOriginalAmount;
  }

  double calculateTotalDiscount() {
    double totalOriginalAmount = calculateTotalOriginalAmount();
    double totalAmount = calculateTotalAmount();
    return totalOriginalAmount - totalAmount;
  }
}
