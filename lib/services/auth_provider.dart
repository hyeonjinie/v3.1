import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/custom_user.dart';

class AuthProviderService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomUser? _customUser;

  AuthProviderService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  CustomUser? get user => _customUser;

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
    } else {
      _customUser = null;
    }
    notifyListeners();
  }

  Future<void> setUserAfterRegistration(User user) async {
    var userDoc = await _firestore.collection('client').doc(user.uid).get();
    _customUser = CustomUser.fromDocument(userDoc);
    notifyListeners();
  }

  Future<void> updateUserAddress(String uid, String address) async {
    await _firestore.collection('client').doc(uid).update({'deliveryAddress': address});
    _customUser?.deliveryAddress = address;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _customUser = null;
    notifyListeners();
    Future.microtask(() => context.go('/'));  // Navigate to home after signing out
  }
}
