import 'package:edt/pages/authentication/signup/complete_profile.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetNewPassword extends StatelessWidget {
  const SetNewPassword({super.key});

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
                'Set New Password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff2a2a2a),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'Set your new password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xffa0a0a0),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomTextFormField(hintText: 'Enter your New Password',imagePath: 'assets/icons/visibility_off.svg',),
              SizedBox(height: 20,),
              CustomTextFormField(hintText: 'Confirm Password',imagePath: 'assets/icons/visibility_off.svg'),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Atleast 1 number or a special character',
                  style: GoogleFonts.poppins(
                    color: Color(0xffa6a6a6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteProfile()));
                },
                child: getContainer(context, 'Save')),
            )
            ],
          ),
        ),
      ),
    );
  }
}