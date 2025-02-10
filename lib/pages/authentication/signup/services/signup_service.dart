import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/authentication/signup/complete_profile.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../boarding/provider/role_provider.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserProfile(String fullName, String phone, String email,
      String street, String city, String district,context) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var roleProvider=Provider.of<UserRoleProvider>(context);
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
        var userRef = _firestore.collection(collectionName).doc(currentUser.uid);
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

  Future<void> signupUser(
      {required String username,
      required String email,
      required String phone,
      required String gender,
      required String role,
      required String password,
      context}) async {
    try {
      final existingUser = await _auth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        throw Exception('Email already exists');
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('passengers').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'gender': gender,
        'role': role,
        'uid': uid,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompleteProfile()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signupDriver(
      {required String fullname,
      required String phone,
      required String email,
      required String street,
      required String city,
      required String district,
      required String vehicleType,
      required String vehicleNumber,
      required String vehicleColor,
      required String idProof,
      required String drivingLicense,
      required String vehicleRegistrationCertificate,
      required String vehiclePicture,
      required String password,
      context}) async {
    try {
      final existingUser = await _auth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        throw Exception('Email already exists');
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('drivers').doc(uid).set({
        'uid': uid,
        'fullname': fullname,
        'phone': phone,
        'email': email,
        'street': street,
        'city': city,
        'district': district,
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber,
        'vehicleColor': vehicleColor,
        'idProof': idProof,
        'drivingLicense': drivingLicense,
        'vehicleRegistrationCertificate': vehicleRegistrationCertificate,
        'vehiclePicture': vehiclePicture,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      
    } catch (e) {
      log('Error signing out: $e');
    }
  }
}
