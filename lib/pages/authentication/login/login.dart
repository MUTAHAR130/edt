import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/authentication/login/forget_pass.dart';
import 'package:edt/pages/authentication/login/services/login_service.dart';
import 'package:edt/pages/authentication/signup/services/google_signin.dart';
import 'package:edt/pages/authentication/signup/signup.dart';
import 'package:edt/pages/authentication/signup/widgets/google_container.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/password_field.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  void _login(String emailOrPhone, String password) async {
  if (emailOrPhone.isEmpty || password.isEmpty) {
    EasyLoading.showError("Please fill in all fields");
    return;
  }

  setState(() {
    _isLoading = true;
  });
  EasyLoading.show(status: "Logging in...");

  try {
    var user = await _loginService.loginUser(emailOrPhone, password);
    
    if (user != null) {
      var rolePro=Provider.of<UserRoleProvider>(context,listen: false);
      String? userRole = rolePro.role;

      if (userRole == null) {
        EasyLoading.showError("User role not found");
        return;
      }

      bool userExists = false;
      
      if (userRole == 'Passenger') {
        userExists = await _checkUserExistsInCollection(
          emailOrPhone, 
          'passengers', 
          'Passenger'
        );
      } else if (userRole == 'Driver') {
        userExists = await _checkUserExistsInCollection(
          emailOrPhone, 
          'drivers', 
          'Driver'
        );
      } else {
        EasyLoading.showError("Invalid Credentials");
        return;
      }
      String collectionName = userRole == 'Passenger' ? 'passengers' : 'drivers';

      if (userExists) {
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        
        if (deviceToken != null) {
          await _updateUserToken(emailOrPhone, collectionName, deviceToken);
        }
        EasyLoading.showSuccess("Login Successful");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
          (route) => false
        );
      } else {
        EasyLoading.showError("User does not exist");
      }
    }
  } catch (e) {
    EasyLoading.showError("Login failed: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
    EasyLoading.dismiss();
  }
}

Future<void> _updateUserToken(String email, String collectionName, String token) async {
  try {
    var userRef = FirebaseFirestore.instance.collection(collectionName).where('email', isEqualTo: email);
    
    var querySnapshot = await userRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.reference;

      await userDoc.update({
        'tokens': FieldValue.arrayUnion([token])
      });

      log('FCM Token updated successfully');
    }
  } catch (e) {
    log('Error updating user token: $e');
  }
}

Future<bool> _checkUserExistsInCollection(
  String email, 
  String collectionName, 
  String roleField
) async {
  try {
    var userSnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .where('role', isEqualTo: roleField)
        .get();

    return userSnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking user existence: $e');
    return false;
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
              PasswordField(
                  hintText: 'Enter Your Password', controller: password),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => ForgetPasswordScreen()));
              //       },
              //       child: Text(
              //         'Forget Password?',
              //         style: GoogleFonts.poppins(
              //             color: Color(0xff0F69DB),
              //             fontSize: 14,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    log('tapped');
                    _isLoading
                        ? null
                        : _login(emailOrPhone.text, password.text);
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
                  GestureDetector(
                      onTap: () {
                        GoogleButton().loginWithGoogle(context);
                      },
                      child: CustomContainer(
                          svgPicture: 'assets/icons/gmail.svg')),
                  // CustomContainer(svgPicture: 'assets/icons/facebook.svg'),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
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
