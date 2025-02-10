import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    await _googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      log("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> storeUserData(User user,String? role,context) async {
    try {
      var roleProvider=Provider.of<UserRoleProvider>(context);
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final userDoc = await _firestore.collection(collectionName).doc(user.uid).get();
      if (userDoc.exists) {
        log('User data already exists in Firestore');
        return;
      }
      // String? deviceToken = await FirebaseMessaging.instance.getToken();
      await _firestore.collection(collectionName).doc(user.uid).set({
        'city':null,
        'district':null,
        'email': user.email ?? 'No Email',
        'fullname': user.displayName ?? 'No Name',
        'gender':null,
        'phone':null,
        'role':role,
        'street':null,
        'uid': user.uid,
        'username':null
        // 'token':deviceToken,
      });

      log("User data stored successfully");
    } catch (e) {
      log("Error storing user data: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      log("User signed out successfully");
    } catch (e) {
      log("Error signing out: $e");
    }
  }
}
