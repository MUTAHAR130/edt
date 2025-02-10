import 'package:edt/pages/authentication/login/signin_otp.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  Future<void> _validateEmailOrPhone() async {
    String inputValue = _controller.text.trim();

    if (inputValue.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email or phone number.';
      });
      return;
    }

    try {
      var roleProvider=Provider.of<UserRoleProvider>(context);
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
      final userQuery = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('email', isEqualTo: inputValue)
          .get();

      if (userQuery.docs.isEmpty) {
        final phoneQuery = await FirebaseFirestore.instance
            .collection(collectionName)
            .where('phone', isEqualTo: inputValue)
            .get();

        if (phoneQuery.docs.isEmpty) {
          setState(() {
            _errorMessage = 'This email or phone number is not associated with any account.';
          });
        } else {
          setState(() {
            _errorMessage = null;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginOtpScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = null;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginOtpScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackButton(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Verification email or phone number',
              style: GoogleFonts.poppins(
                color: Color(0xff2a2a2a),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CustomTextFormField(
              controller: _controller,
              hintText: 'Email or Phone Number',
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: _validateEmailOrPhone,
                child: getContainer(context, 'Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
