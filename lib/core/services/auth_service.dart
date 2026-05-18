import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:honnyapp/core/services/database.dart';
// import 'package:honnyapp/customer_app/screens/ login_screen.dart';
import 'package:honnyapp/customer_app/screens/cart_screen.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CURRENT USER
  getCurrentUser() async {
    return auth.currentUser;
  }

  // EMAIL LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // EMAIL SIGNUP
  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map<String, dynamic> userInfoMap = {
        'uid': userCredential.user!.uid,
        'name': fullName,
        'email': email,
        'role': 'customer',
        "phone": "",

        "address": "",
 "createdAt": DateTime.now(),
        "image": "",
      };

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userInfoMap);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // GOOGLE SIGN IN
  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);

      User? userDetails = result.user;

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          'uid': userDetails.uid,
          'email': userDetails.email,
          'name': userDetails.displayName,
          'imgURL': userDetails.photoURL,
          'role': 'customer',
        };

        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
