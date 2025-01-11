import 'package:edt/pages/authentication/login/forget_pass_otp.dart';
import 'package:edt/pages/authentication/login/widgets/selection_container.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String selectedOption = 'sms';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackButton(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff2a2a2a),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Select which contact details should we use to reset your password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xffa0a0a0),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 36),
              GetSelectionContainer(
                  iconPath: 'assets/icons/sms.svg',
                  via: 'Via SMS',
                  subtitle: '***** ***70',
                  isSelected: selectedOption == 'sms',
                onTap: () => setState(() => selectedOption = 'sms')),
              SizedBox(
                height: 16,
              ),
              GetSelectionContainer(
                  iconPath: 'assets/icons/email.svg',
                  via: 'Via EMAIL',
                  subtitle: '**** **** **** xyz@xyz.com',
                  isSelected: selectedOption == 'email',
                onTap: () => setState(() => selectedOption = 'email'),
                  ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassOtpScreen(selected: selectedOption,)));
                  },
                  child: getContainer(context, 'Continue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
