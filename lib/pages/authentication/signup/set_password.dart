import 'dart:developer';

import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SetPassword extends StatefulWidget {
  final String? role;
  const SetPassword({super.key, required this.role});

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var signupPro = Provider.of<SignupProvider>(context);
    var userPro = Provider.of<UserRoleProvider>(context);
    return Scaffold(
      appBar: getBackButton(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Set Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Color(0xff2a2a2a),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          'Set your password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa0a0a0),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 40),
                        PasswordField(
                          hintText: 'Enter Password',
                          controller: password,
                        ),
                        SizedBox(height: 20),
                        PasswordField(
                          hintText: 'Confirm Password',
                          controller: confirmPassword,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (_isLoading) return;

                              if (password.text.isEmpty ||
                                  confirmPassword.text.isEmpty) {
                                EasyLoading.showError(
                                    "Please fill in both password fields");
                                return;
                              }
                              if (password.text != confirmPassword.text) {
                                EasyLoading.showError("Passwords do not match");
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              EasyLoading.show(status: "Registering...");
                              try {
                                if (widget.role == 'Passenger') {
                                  await SignupService().signupUser(
                                    username: signupPro.name,
                                    email: signupPro.email,
                                    phone: signupPro.phone,
                                    gender: signupPro.gender,
                                    role: userPro.role,
                                    password: password.text,
                                    context: context,
                                  );
                                } else if (widget.role == 'Driver') {
                                  await SignupService().signupDriver(
                                    driverImage: signupPro.driverImage,
                                    fullname: signupPro.driverFullname,
                                    phone: signupPro.driverPhone,
                                    email: signupPro.driverEmail,
                                    street: signupPro.driverStreet,
                                    city: signupPro.driverCity,
                                    district: signupPro.driverDistrict,
                                    vehicleName: signupPro.driverVehicleName,
                                    vehicleType: signupPro.driverVehicleType,
                                    vehicleNumber:
                                        signupPro.driverVehicleNumber,
                                    vehicleColor: signupPro.driverVehicleColor,
                                    idProof: signupPro.driverIdProof,
                                    drivingLicense:
                                        signupPro.driverDrivingLicense,
                                    vehicleRegistrationCertificate: signupPro
                                        .driverVehicleRegistrationCertificate,
                                    vehiclePicture:
                                        signupPro.driverVehiclePicture,
                                    password: password.text,
                                    role: userPro.role,
                                    context: context,
                                  );
                                } else {
                                  EasyLoading.showError("No Role Specified");
                                }
                              } catch (e) {
                                EasyLoading.showError(e.toString());
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                                EasyLoading.dismiss();
                              }
                            },
                            child: getContainer(
                              context,
                              'Register',
                            ),
                          ),
                        )
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
