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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Ensures the content fills at least the height of the viewport.
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: getHeight(context) * 0.13),
                        SizedBox(
                          width: getWidth(context) * 0.9,
                          child: Image.asset('assets/images/welcome.png'),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Welcome',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xff2a2a2a),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Have a better sharing experience',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xffa0a0a0),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          child: getContainer(context, 'Create an account'),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff163051),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff163051),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
