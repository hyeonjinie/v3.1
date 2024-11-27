import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/custom_user.dart';

class AuthProviderService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomUser? _customUser;
  String? _currentToken;

  AuthProviderService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _initializeToken();
  }

  CustomUser? get user => _customUser;
  String? get currentToken => _currentToken;

  Future<void> _initializeToken() async {
    if (_auth.currentUser != null) {
      await refreshToken();
    }
  }

  Future<String?> getCurrentUserToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token;
      }
      return null;
    } catch (e) {
      print('토큰 가져오기 실패: $e');
      return null;
    }
  }



  Future<String?> refreshToken() async {
    try {
      final token = await _auth.currentUser?.getIdToken(true);
      _currentToken = token;
      notifyListeners();
      return token;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }

  Stream<CustomUser?> get userChanges {
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return _customUser;
      }
      return null;
    });
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      var userDoc = await _firestore.collection('client').doc(firebaseUser.uid).get();
      _customUser = CustomUser.fromDocument(userDoc);
      await refreshToken();
    } else {
      _customUser = null;
      _currentToken = null;
    }
    notifyListeners();
  }

  Future<void> setUserAfterRegistration(User user) async {
    var userDoc = await _firestore.collection('client').doc(user.uid).get();
    _customUser = CustomUser.fromDocument(userDoc);
    await refreshToken();
    notifyListeners();
  }

  Future<void> updateUserAddress(String uid, String address) async {
    await _firestore.collection('client').doc(uid).update({'deliveryAddress': address});
    _customUser?.deliveryAddress = address;
    notifyListeners();
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final token = await credential.user?.getIdToken();
      _currentToken = token;
      notifyListeners();
      return token;
    } catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _customUser = null;
    _currentToken = null;
    notifyListeners();
    Future.microtask(() => context.go('/'));
  }
}