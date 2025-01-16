import 'package:edt/pages/authentication/signup/widgets/phone_field.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
                SizedBox(
                  height: 16,
                ),
                CustomTextFormField(hintText: 'Name'),
                SizedBox(
                  height: 16,
                ),
                CustomTextFormField(hintText: 'Email'),
                SizedBox(
                  height: 16,
                ),
                PhoneInputField(),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 120.0,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your text',
                      hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xffd0d0d0)),
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
                SizedBox(height: 150,),
                getContainer(context, 'Send Message')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
