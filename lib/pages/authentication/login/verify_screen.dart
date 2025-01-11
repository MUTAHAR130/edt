import 'package:edt/pages/authentication/login/signin_otp.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

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
              'Verifivation email or phone number',
              style: GoogleFonts.poppins(
                color: Color(0xff2a2a2a),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CustomTextFormField(hintText: 'Email or Phone Number'),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginOtpScreen()));
                },
                child: getContainer(context, 'Send OTP')),
            )
          ],
        ),
      ),
    );
  }
}
