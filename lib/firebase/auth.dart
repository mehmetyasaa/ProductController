import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imtapp/routes/routes.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required int phone,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await _addUserToFirestore(user.uid, email, displayName, phone);
    }
  }

  Future<void> signOute() async {
    await _firebaseAuth.signOut();

    Get.toNamed(RoutesClass.login);
  }

  Future<void> deleteAccount() async {
    var user = Auth().currentUser;
    try {
      if (user != null) {
        await _firestore.collection('users').doc(user?.uid).delete();
      } else {
        print('Document ID not found for product');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
    try {
      await user?.delete();
      Get.toNamed(RoutesClass.login);
    } catch (e) {
      return print('Error parsing date: $e');
    }
  }

  Future<void> _addUserToFirestore(
      String uid, String email, String displayName, int phone) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'displayName': displayName, 'phone': phone});
  }
}
