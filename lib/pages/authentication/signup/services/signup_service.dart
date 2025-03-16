import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/authentication/signup/complete_profile.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadFile(String filePath, String folderName) async {
    File file = File(filePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child(folderName).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateUserProfile(
      String fullName,
      String phone,
      String email,
      String street,
      String city,
      String district,
      String? passengerImagePath,
      String role,
      context) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
      var userRef = _firestore.collection(collectionName).doc(currentUser.uid);

        String? passengerImageUrl;
        if (passengerImagePath != null && passengerImagePath.isNotEmpty) {
          passengerImageUrl =
              await uploadFile(passengerImagePath, "passenger_images");
        }


        await userRef.set({
          if (passengerImageUrl != null) 'passengerImage': passengerImageUrl,
          'fullName': fullName,
          'phone': phone,
          'email': email,
          'street': street,
          'city': city,
          'district': district,
        }, SetOptions(merge: true));

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
    context,
  }) async {
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
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      await _firestore.collection('passengers').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'gender': gender,
        'role': role,
        'uid': uid,
        'tokens': fcmToken != null ? [fcmToken] : [],
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CompleteProfile()),
          (route) => false,
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signupDriver({
    required String driverImage,
    required String fullname,
    required String phone,
    required String email,
    required String street,
    required String city,
    required String district,
    required String vehicleName,
    required String vehicleType,
    required String vehicleNumber,
    required String vehicleColor,
    required String idProof,
    required String drivingLicense,
    required String vehicleRegistrationCertificate,
    required String vehiclePicture,
    required String password,
    required String role,
    context,
  }) async {
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

      String driverImageUrl = await uploadFile(driverImage, "driver_images");
      String idProofUrl = await uploadFile(idProof, "driver_documents");
      String drivingLicenseUrl =
          await uploadFile(drivingLicense, "driver_documents");
      String vehicleRegistrationCertificateUrl =
          await uploadFile(vehicleRegistrationCertificate, "driver_documents");
      String vehiclePictureUrl =
          await uploadFile(vehiclePicture, "driver_documents");

          String? fcmToken = await FirebaseMessaging.instance.getToken();

      await _firestore.collection('drivers').doc(uid).set({
        'uid': uid,
        'driverImage': driverImageUrl,
        'fullname': fullname,
        'phone': phone,
        'email': email,
        'street': street,
        'city': city,
        'district': district,
        'vehicleName':vehicleName,
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber,
        'vehicleColor': vehicleColor,
        'idProof': idProofUrl,
        'drivingLicense': drivingLicenseUrl,
        'vehicleRegistrationCertificate': vehicleRegistrationCertificateUrl,
        'vehiclePicture': vehiclePictureUrl,
        'role':role,
        'tokens': fcmToken != null ? [fcmToken] : [],
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
          (route) => false,
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
