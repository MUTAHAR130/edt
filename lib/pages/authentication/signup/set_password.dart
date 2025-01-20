import 'package:edt/pages/authentication/signup/complete_profile.dart';
import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SetPassword extends StatelessWidget {
  const SetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();
    var signupPro = Provider.of<SignupProvider>(context);
    var userPro = Provider.of<UserRoleProvider>(context);
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
                'Set Password',
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
                'Set your password',
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
              CustomTextFormField(
                hintText: 'Enter Password',
                imagePath: 'assets/icons/visibility_off.svg',
                controller: password,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                hintText: 'Confirm Password',
                imagePath: 'assets/icons/visibility_off.svg',
                controller: confirmPassword,
              ),
              SizedBox(
                height: 10,
              ),
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
                      if (password.text.isEmpty ||
                          confirmPassword.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please fill in both password fields")),
                        );
                        return;
                      }
                      if (password.text != confirmPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }
                      SignupService().signupUser(
                        username: signupPro.name,
                        email: signupPro.email,
                        phone: signupPro.phone,
                        gender: signupPro.gender,
                        role: userPro.role,
                        password: password.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompleteProfile()),
                      );
                    },
                    child: getContainer(context, 'Register')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
