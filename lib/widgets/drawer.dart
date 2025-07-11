import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/authentication/enable_location/welcome.dart';
import 'package:edt/pages/authentication/login/login.dart';
import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:edt/pages/boarding/driver_passenger.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/pages/drawer_screens/address/address.dart';
import 'package:edt/pages/drawer_screens/complain/complain.dart';
import 'package:edt/pages/drawer_screens/emergency/emergency.dart';
import 'package:edt/pages/drawer_screens/help_and_support/help_and_support.dart';
import 'package:edt/pages/drawer_screens/history/history.dart';
import 'package:edt/pages/drawer_screens/about_us/about_us.dart';
import 'package:edt/pages/drawer_screens/settings/settings.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:svg_flutter/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Drawer getDrawer(BuildContext context) {
  var roleProvider = Provider.of<UserRoleProvider>(context);
  var userProfileProvider = Provider.of<UserProfileProvider>(context);

  String role = roleProvider.role;
  String collectionName = role == 'Driver' ? 'drivers' : 'passengers';

  // Load user profile if not already loaded
  if (!userProfileProvider.isLoaded) {
    userProfileProvider.loadUserProfile(collectionName);
  }

  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: Color(0xff414141),
                    ),
                    Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        color: Color(0xff414141),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Profile Image
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                backgroundImage: (userProfileProvider.profileImage.isNotEmpty)
                    ? NetworkImage(userProfileProvider.profileImage)
                    : null,
                child: userProfileProvider.profileImage.isEmpty
                    ? Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 8),
              // Display Name and Email
              Text(
                userProfileProvider.username,
                style: GoogleFonts.poppins(
                  color: Color(0xff414141),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                userProfileProvider.email,
                style: GoogleFonts.poppins(
                  color: Color(0xff414141),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
        ),
        _buildDrawerItem('assets/icons/dicon1.svg', 'Edit Profile', () {
          Provider.of<BottomNavProvider>(context, listen: false).setIndex(2);
          Navigator.pop(context);
        }),
        _buildDrawerItem('assets/icons/dicon2.svg', 'Address', () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddressScreen()));
        }),
        // _buildDrawerItem('assets/icons/dicon3.svg', 'History', () {
        //   Navigator.pop(context);
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => HistoryScreen()));
        // }),
        _buildDrawerItem('assets/icons/dicon4.svg', 'Complain', () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComplainScreen()));
        }),
        // _buildDrawerItem('assets/icons/dicon5.svg', 'Rewards', () {}),
        _buildDrawerItem('assets/icons/dicon6.svg', 'About Us', () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AboutUsScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon7.svg', 'Settings', () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsScreen()));
        }),
        // _buildDrawerItem('assets/icons/dicon8.svg', 'Emergency', () {
        //   Navigator.pop(context);
        //   emergencySheet(context);
        // }),
        _buildDrawerItem('assets/icons/dicon9.svg', 'Help and Support', () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelpAndSupport()));
        }),
        _buildDrawerItem('assets/icons/dicon10.svg', 'Logout', () async {
          Navigator.pop(context);
          bool confirmLogout = await _showLogoutConfirmation(context);
          if (confirmLogout) {
            await _logout(context);
          }
        }),
      ],
    ),
  );
}

Future<bool> _showLogoutConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);
                Provider.of<PaymentProvider>(context, listen: false).reset();
                final userRole =
                    Provider.of<UserRoleProvider>(context, listen: false);
                userRole.resetRole();
                await removeDeviceTokenOnLogout(userRole.role);
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ) ??
      false;
}

// 3️⃣ Add this function below your _logout method

Future<void> _deleteAccount(BuildContext context) async {
  try {
    EasyLoading.show(status: 'Deleting account...');
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // Get role
    final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    String collectionName =
        roleProvider.role == 'Driver' ? 'drivers' : 'passengers';

    // Remove FCM token from Firestore
    await removeDeviceTokenOnLogout(roleProvider.role);

    // Delete user data from Firestore
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(uid)
        .delete();

    // Delete Firebase Auth account
    await user.delete();

    // Reset providers
    Provider.of<PaymentProvider>(context, listen: false).reset();
    roleProvider.resetRole();

    EasyLoading.showSuccess('Account deleted');

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  } catch (e) {
    EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
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
        MaterialPageRoute(builder: (context) => DriverPassenger()),
        (route) => false);
    EasyLoading.showSuccess('Logged Out Successfully');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

Future<void> removeDeviceTokenOnLogout(String userRole) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;

    final collectionName = userRole == 'Driver' ? 'drivers' : 'passengers';

    final userDocRef =
        FirebaseFirestore.instance.collection(collectionName).doc(userId);

    await userDocRef.update({
      'tokens': FieldValue.arrayRemove([fcmToken])
    });

    print('FCM Token removed successfully on logout for $userRole: $fcmToken');

    await FirebaseMessaging.instance.deleteToken();
  } catch (e) {
    print('Error removing device token: $e');
  }
}

Widget _buildDrawerItem(String iconPath, String title, VoidCallback? onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Divider(
        color: Color(0xffE8E8E8),
      ),
      ListTile(
        splashColor: Colors.transparent,
        tileColor: Colors.white,
        leading:
            SizedBox(width: 20, height: 20, child: SvgPicture.asset(iconPath)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Color(0xff414141),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    ],
  );
}
