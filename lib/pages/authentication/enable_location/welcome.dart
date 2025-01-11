import 'package:edt/pages/authentication/login/login.dart';
import 'package:edt/pages/authentication/signup/signup.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: getHeight(context) * 0.13,
            ),
            SizedBox(
              width: getWidth(context) * 0.9,
              child: Image.asset('assets/images/welcome.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Color(0xff2a2a2a),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Have a better sharing experience',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Color(0xffa0a0a0),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: getContainer(context, 'Create an account'),
              )),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff163051)),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                      child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      color: Color(0xff163051),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
            ),
            SizedBox(height: 35,)
          ],
        ),
      ),
    );
  }
}
