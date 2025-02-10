import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthHelper {
  static Future<void> sendOtp({
    required String phoneNumber,
    required BuildContext context,
    required void Function(String) onCodeSent,
    required void Function(FirebaseAuthException) onError,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
        forceResendingToken: null,
      );
    } catch (e) {
      print('Error sending OTP: $e');
      onError(FirebaseAuthException(
        code: 'send-otp-error',
        message: 'Failed to send OTP. Please try again.',
      ));
    }
  }

  static Future<bool> verifyOtp({
    required String verificationId,
    required String smsCode,
    required void Function(FirebaseAuthException) onError,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      onError(e);
      return false;
    }
  }
}