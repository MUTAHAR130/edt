import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserProfile(String fullName, String phone, String email,
      String street, String city, String district) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var userRef = _firestore.collection('users').doc(currentUser.uid);
        await userRef.update({
          'fullName': fullName,
          'phone': phone,
          'email': email,
          'street': street,
          'city': city,
          'district': district,
        });
        log('User profile updated successfully');
      } else {
        log('No user is signed in');
      }
    } catch (e) {
      log('Error updating user profile: $e');
    }
  }

  Future<void> signupUser({
    required String username,
    required String email,
    required String phone,
    required String gender,
    required String role,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'gender': gender,
        'role': role,
        'uid': uid,
      });
    } catch (e) {
      log('Signup failed: $e');
    }
  }
}
