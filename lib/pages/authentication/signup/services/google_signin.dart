import 'dart:developer';
import 'package:edt/pages/authentication/signup/services/google_service.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GoogleButton {
  final GoogleAuthService googleAuthService = GoogleAuthService();

  Future<void> signupWithGoogle(BuildContext context) async {
    var roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    final user = await googleAuthService.signInWithGoogle();

    if (user != null) {
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        EasyLoading.showError('Already signed up using this account');
      } else {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance.collection(collectionName).doc(user.uid).set({
          'username': user.displayName ?? 'Unnamed',
          'email': user.email ?? '',
          'passengerImage': user.photoURL ?? '',
          'uid': user.uid,
          'role': role,
          'tokens': fcmToken != null ? [fcmToken] : [],
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
          (route) => false,
        );
      }
    } else {
      log("Sign-In canceled");
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
  final user = await googleAuthService.signInWithGoogle();

  if (user != null) {
    var roleProvider = Provider.of<UserRoleProvider>(context, listen: false);

    DocumentSnapshot driverDoc = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(user.uid)
        .get();

    DocumentSnapshot passengerDoc = await FirebaseFirestore.instance
        .collection('passengers')
        .doc(user.uid)
        .get();

    if (driverDoc.exists) {
      roleProvider.setRole('Driver');
    } else if (passengerDoc.exists) {
      roleProvider.setRole('Passenger');
    } else {
      EasyLoading.showError('User is not signed up with this email');
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomBar()), 
      (route) => false,
    );
  } else {
    log("Sign-In canceled");
  }
}

}
