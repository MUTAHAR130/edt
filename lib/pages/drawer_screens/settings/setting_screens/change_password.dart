import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/password_field.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      EasyLoading.showError('All fields are required!');
      return;
    }

    if (newPassword != confirmPassword) {
      EasyLoading.showError('New passwords do not match!');
      return;
    }

    EasyLoading.show(status: 'Updating Password...');

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      EasyLoading.showSuccess('Password updated successfully!');
      
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      EasyLoading.showError('Old Password is Incorrect');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios, size: 24, color: Color(0xff414141)),
                            Text(
                              'Back',
                              style: GoogleFonts.poppins(color: const Color(0xff414141), fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.poppins(color: const Color(0xff2a2a2a), fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                PasswordField(hintText: 'Old Password',controller: _oldPasswordController,),
                const SizedBox(height: 16),
                PasswordField(
                  hintText: 'New Password',
                  controller: _newPasswordController,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: _changePassword,
                  child: getContainer(context, 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
