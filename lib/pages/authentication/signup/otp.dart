import 'package:edt/pages/authentication/signup/services/phone_auth.dart';
import 'package:edt/pages/authentication/signup/set_password.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String enteredOtp = '';

  void verifyOtp() {
  PhoneAuthHelper.verifyOtp(
    verificationId: widget.verificationId,
    smsCode: enteredOtp,
    onError: (FirebaseAuthException e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Invalid OTP'),
          backgroundColor: Colors.red,
        ),
      );
    },
  ).then((success) {
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SetPassword(role: 'Passenger',)),
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackButton(context),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Phone Verification',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xff2a2a2a),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 13),
          Text(
            'Enter your OTP Code',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xffa0a0a0),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 40),
          OtpTextField(
            fieldHeight: 60,
            fieldWidth: 55,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            numberOfFields: 6,
            focusedBorderColor: Color(0xff0F69DB),
            showFieldAsBox: true,
            onCodeChanged: (String code) {
              setState(() {
                enteredOtp = code;
              });
            },
            onSubmit: (String verificationCode) {
              setState(() {
                enteredOtp = verificationCode;
              });
            },
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // Resend OTP Logic
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn’t receive code?',
                  style: GoogleFonts.poppins(
                    color: Color(0xff5a5a5a),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Resend again',
                  style: GoogleFonts.poppins(
                    color: Color(0xff0F69DB),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: verifyOtp,
              child: getContainer(context, 'Verify'),
            ),
          )
        ],
      ),
    );
  }
}