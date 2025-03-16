import 'package:edt/pages/authentication/enable_location/welcome.dart';
import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/drawer_screens/address/address.dart';
import 'package:edt/pages/drawer_screens/settings/setting_screens/change_password.dart';
import 'package:edt/pages/drawer_screens/settings/setting_screens/contact_us.dart';
import 'package:edt/pages/drawer_screens/settings/setting_screens/delete_account.dart';
import 'package:edt/pages/drawer_screens/settings/setting_screens/privacy_policy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 24,
                              color: Color(0xff414141),
                            ),
                            Text(
                              'Back',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff414141),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Settings',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff2a2a2a),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    List title = [
      'Edit Profile',
      'Address',
      'Change Password',
      'Privacy Policy',
      'Contact Us',
      'Delete Account',
      // 'Logout'
    ];
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10),
      itemCount: title.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () async {
              if (title[index] == 'Change Password') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              } else if (title[index] == 'Edit Profile') {
                
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomBar()),
                    (route) => false);
                    Provider.of<BottomNavProvider>(context, listen: false)
                    .setIndex(2);
              } else if (title[index] == 'Privacy Policy') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              } else if (title[index] == 'Address') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressScreen()));
              } else if (title[index] == 'Delete Account') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteAccountScreen()));
              } else if (title[index] == 'Contact Us') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUsScreen()));
              }
              // else if (title[index] == 'Logout') {
              //   bool confirmLogout = await _showLogoutConfirmation(context);
              //   if (confirmLogout) {
              //     await _logout(context);
              //   }
              // }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xff0F69DB)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        title[index],
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff414141)),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<bool> _showLogoutConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ??
      false;
}

Future<void> _logout(BuildContext context) async {
  try {
    EasyLoading.show(status: 'Logging out...');
    User? user = FirebaseAuth.instance.currentUser;
    bool isGoogleUser =
        user?.providerData.any((info) => info.providerId == 'google.com') ??
            false;

    if (isGoogleUser) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } else {
      await SignupService().signOut();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (route)=>false
    );
    EasyLoading.showSuccess('Logged Out Successfully');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}
