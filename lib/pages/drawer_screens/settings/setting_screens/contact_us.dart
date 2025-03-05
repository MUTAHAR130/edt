import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _populateControllers() {
    final profile = Provider.of<UserProfileProvider>(context, listen: false);
    _nameController.text = profile.username;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
  }

  Future<void> _sendMessage() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _messageController.text.isEmpty) {
      EasyLoading.showError("All fields are required");
      return;
    }
    try {
      EasyLoading.show(status: "Sending...");
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        EasyLoading.showError("User not logged in");
        return;
      }
      await FirebaseFirestore.instance.collection("contact_us").add({
        "uid": user.uid,
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "message": _messageController.text,
        "timestamp": FieldValue.serverTimestamp(),
      });
      EasyLoading.showSuccess("Message Sent Successfully");
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    } catch (e) {
      EasyLoading.showError("Failed to send message");
    }
  }@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _populateControllers();
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
                            'Contact Us',
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
                Text(
                  'Contact us for Ride share',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff414141)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Address',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xff414141)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'House# 72, Road# 21, Banani, Dhaka-1213 (near Banani Bidyaniketon School &\nCollege, beside University of South Asia)\nCall : 13301 (24/7)\nEmail : support@pathao.com',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff898989)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Send Message',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xff414141)),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                    controller: _nameController, hintText: 'Name'),
                const SizedBox(height: 16),
                CustomTextFormField(
                    controller: _emailController, hintText: 'Email'),
                const SizedBox(height: 16),
                CustomTextFormField(
                    controller: _phoneController, hintText: 'Phone'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120.0,
                  child: TextField(
                    controller: _messageController,
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your text',
                      hintStyle: GoogleFonts.poppins(
                          color: Color(0xffb8b8b8), fontSize: 15),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffb8b8b8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _sendMessage,
                  child: getContainer(context, 'Send Message'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
