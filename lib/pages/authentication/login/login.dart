import 'dart:developer';
import 'package:edt/pages/authentication/login/forget_pass.dart';
import 'package:edt/pages/authentication/login/services/login_service.dart';
import 'package:edt/pages/authentication/login/verify_screen.dart';
import 'package:edt/pages/authentication/signup/widgets/google_container.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailOrPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false;

  final LoginService _loginService = LoginService();

  void _login(String emailOrPhone,String password) async {
    String email = emailOrPhone;
    String pass = password;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var user = await _loginService.loginUser(email, pass);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackButton(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Sign in',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff2a2a2a),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              CustomTextFormField(
                hintText: 'Email or Phone Number',
                controller: emailOrPhone,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                hintText: 'Enter Your Password',
                imagePath: 'assets/icons/visibility_off.svg',
                controller: password,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen()));
                    },
                    child: Text(
                      'Forget Password?',
                      style: GoogleFonts.poppins(
                          color: Color(0xff0F69DB),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    log('tapped');
                    _isLoading ? null : _login(emailOrPhone.text,password.text);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => VerifyScreen()));
                  },
                  child: getContainer(context, 'Sign in')),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(endIndent: 10, color: Color(0xffB8B8B8))),
                  Text(
                    'or',
                    style: GoogleFonts.poppins(
                        color: Color(0xffB8B8B8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                      child: Divider(indent: 10, color: Color(0xffB8B8B8))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(svgPicture: 'assets/icons/gmail.svg'),
                  CustomContainer(svgPicture: 'assets/icons/facebook.svg'),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  spacing: 7,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account?',
                      style: GoogleFonts.poppins(
                          color: Color(0xff5a5a5a),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                          color: Color(0xff0F69DB),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
