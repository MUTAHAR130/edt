import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/authentication/enable_location/welcome.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          'Help and Support',
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
              IntrinsicHeight(
                child: Text(
                  'Are you sure you want to delete your account? '
                  'Please read how account deletion will affect you. '
                  'Deleting your account removes personal information from our database. '
                  'Your email becomes permanently reserved and cannot be reused to register a new account.',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff5a5a5a)),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _confirmDeleteAccount(context),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xffBD0A00),
                  ),
                  child: Center(
                    child: Text(
                      'Delete',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Account Deletion'),
          content: const Text(
              'Are you sure you want to permanently delete your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await _deleteUserAccount(context);
                if (success && context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deleteUserAccount(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Deleting Account...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final userRoleProvider =
          Provider.of<UserRoleProvider>(context, listen: false);
      final String role = userRoleProvider.role;
      final String collection = role == 'Driver' ? 'drivers' : 'passengers';

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .delete();

      await user.delete();

      EasyLoading.showSuccess('Account Deleted Successfully!');
      return true;
    } catch (e) {
      log(e.toString());
      if (context.mounted) {
        EasyLoading.showError(e.toString());
      }
      return false;
    }
  }
}