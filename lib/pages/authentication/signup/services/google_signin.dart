import 'dart:developer';
import 'package:edt/pages/authentication/signup/services/google_service.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class GoogleButton {
  final GoogleAuthService googleAuthService = GoogleAuthService();

  Future<void> signupWithGoogle(context) async {
  var roleProvider=Provider.of<UserRoleProvider>(context);
    final user = await googleAuthService.signInWithGoogle();
    if (user != null) {
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        VxToast.show(context,
            msg: 'Already signed up using this account',
            bgColor: Colors.red,
            textColor: Colors.white);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomBar()));
        await GoogleAuthService().storeUserData(user, null,context);
      }
    } else {
      log("Sign-In canceled");
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final user = await googleAuthService.signInWithGoogle();
 var roleProvider1=Provider.of<UserRoleProvider>(context);
    if (user != null) {
      String role = roleProvider1.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isEmpty) {
        VxToast.show(
          context,
          msg: 'User is not signed up with this email',
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      }
    } else {
      log("Sign-In canceled");
    }
  }
}
